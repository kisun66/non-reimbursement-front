import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:http/http.dart' as http;
import './loading.dart' as loading;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:xml/xml.dart';
import '../util/common_util.dart' as commonUtil;
import 'hospitalDetail.dart';

const String kakaoMapKey = '53a136cf20bd4263c00b68fbf310d71f';

class KakaoMap extends StatefulWidget {
  const KakaoMap({Key? key, this.kakaoLatitude, this.kakaoLongitude}) : super(key: key);
  final kakaoLatitude;
  final kakaoLongitude;

  @override
  State<KakaoMap> createState() => _KakaoMapState();
}

class _KakaoMapState extends State<KakaoMap> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double parseLatitude = double.parse(widget.kakaoLatitude);
    double parseLongitude = double.parse(widget.kakaoLongitude);
    var _mapController;

    return FutureBuilder(
        future: getHospitalMarker(widget.kakaoLatitude, widget.kakaoLongitude),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData == false) { // 로딩 시 표출할 부분
            return loading.Loading(
              message: '지도를 불러오고 있습니다',
            );
          } else if (snapshot.hasError) { // 에러 발생시 표출할 부분
            return Text('Error');
          } else { // 성공 시 표출할 부분
            return Scaffold(
            appBar: AppBar(title: Text('병원 목록')),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                KakaoMapView(
                width: size.width,
                height: 300,
                kakaoMapKey: kakaoMapKey,
                mapController: (controller) {
                  _mapController = controller;
                },
                lat: parseLatitude,
                lng: parseLongitude,
                showMapTypeControl: true,
                showZoomControl: true,
                customScript: '''
                var markers = [];
            
                function addMarker(position) {
                  var marker = new kakao.maps.Marker({position: position});
                  marker.setMap(map);
                  markers.push(marker);
                }
                
                function panTo(lat, lng) {
                    var moveLatLon = new kakao.maps.LatLng(lat, lng);
                    map.panTo(moveLatLon);            
                }        
                
                ${snapshot.data['markers']}
                
                var zoomControl = new kakao.maps.ZoomControl();
                map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
          
                var mapTypeControl = new kakao.maps.MapTypeControl();
                map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
              ''',
                onTapMarker: (message) {}),
              Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    height: 500,
                    color: Colors.white,
                    child: ListView.separated(
                      itemCount: snapshot.data['resultList'].length,
                      itemBuilder: (context, index){
                        return ListTile(
                            leading: Icon(Icons.list),
                            trailing: TextButton(
                              child: Text('상세보기', style: TextStyle(color: Colors.green, fontSize: 15)),
                              onPressed: (){
                                print(snapshot.data['resultList'][index]);
                                var sidoCd = '${commonUtil.getSidoCode(snapshot.data['resultList'][index]['addr'])}0000';
                                var yadmNm = snapshot.data['resultList'][index]['yadmNm'];
                                // getHospitalDetail(sidoCd, yadmNm);
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => HospitalDetail(hospitalData : snapshot.data['resultList'][index]),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  )
                                );
                              },
                            ),
                            title: InkWell(
                              onTap: (){
                                var lat = snapshot.data['resultList'][index]['YPos'];
                                var lng = snapshot.data['resultList'][index]['XPos'];
                                _mapController.evaluateJavascript('panTo(${lat}, ${lng})');
                              },
                              child: Text(snapshot.data['resultList'][index]['yadmNm']),
                            )
                        );
                      },
                      separatorBuilder: (context, index){
                        return Divider();
                      },
                    ),
                ))
              ],
            )
            );
          }
        }
    );
  }
}

/// 병원 목록 호출 API
getHospital(String latitude, String longitude) async {
  XmlDocument? XmlData;
  const serviceKey = 'HkDNhACAjb48Slc6oza%2Fklg%2FYmuIq%2FlHal3RgZDe3kc%2FpfhCWqYDJxC9XjMQ0tCPJdyx%2FRT%2FfgPImhlnn5G19Q%3D%3D';
  const pageNo = '1';
  const numOfRows = '100';
  const radius = '500';
  const url = 'http://apis.data.go.kr/B551182/hospInfoService1/getHospBasisList1?';
  var xPos = longitude;
  var yPos = latitude;
  var result = [];

  try {
    http.Response response = await http.get(
        Uri.parse('${url}serviceKey=${serviceKey}&pageNo=${pageNo}&numOfRows=${numOfRows}&radius=${radius}&xPos=${xPos}&yPos=${yPos}')
    );
    XmlData = XmlDocument.parse(utf8.decode(response.bodyBytes));
    final myTransformer = Xml2Json();
    myTransformer.parse(XmlData.toString());
    var json = jsonDecode(myTransformer.toParker());

    json['response']['body']['items']['item'].forEach((element) => result.add(element));

    return result;
  } catch (e) {
    print('url 정보 불러오기 실패');
    return result;
  }
}

/// 멀티마커 호출
addMultiMarker(data){
  var result = '';

  for(int i = 0; i < data.length; i++) {
    result += 'addMarker(new kakao.maps.LatLng(${data[i]['YPos']}, ${data[i]['XPos']}));';
  }

  return result;
}

/// KakaoMap에 보낼 데이터
getHospitalMarker(String latitude, String longitude) async {
  var hospitalData = await getHospital(latitude, longitude);
  var result = {
   'markers' : await addMultiMarker(hospitalData),
   'resultList' : hospitalData
  };
  return result;
}