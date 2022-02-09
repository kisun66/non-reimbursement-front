import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import './loading.dart' as loading;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class HospitalDetail extends StatelessWidget {
  const HospitalDetail({Key? key, required this.hospitalData}) : super(key: key);
  final hospitalData;

  @override
  Widget build(BuildContext context) {
    print('hospitalData : ${hospitalData}');
    var _sidoCd = hospitalData['sidoCd'];
    var _yadmNm = hospitalData['yadmNm'];

    return FutureBuilder(
      future: getHospitalDetail(_sidoCd, _yadmNm),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        print(snapshot.data);
        if (snapshot.hasData == false) {
          return loading.Loading(
            message: '비급여 정보를 불러오고 있습니다',
          );
        } else if (snapshot.hasError) {
          return Text('Error');
        } else {
          if(snapshot.data.length < 1){
            return Nodata(hospitalName : _yadmNm);
          } else {
            return HospitalDetailList(
              hospitalData : hospitalData,
              data : snapshot.data
            );
          }
        }
      },
    );
  }
}


/// 비급여 정보 API
getHospitalDetail(String sidoCd, String yadmNm) async {
  XmlDocument? _XmlData;
  const _serviceKey = 'HkDNhACAjb48Slc6oza%2Fklg%2FYmuIq%2FlHal3RgZDe3kc%2FpfhCWqYDJxC9XjMQ0tCPJdyx%2FRT%2FfgPImhlnn5G19Q%3D%3D';
  const _pageNo = '1';
  const _numOfRows = '1000';
  const _url = 'http://apis.data.go.kr/B551182/nonPaymentDamtInfoService/getNonPaymentItemHospList2?';
  var _result = [];

  try {
    http.Response response = await http.get(
        Uri.parse('${_url}serviceKey=${_serviceKey}&pageNo=${_pageNo}&numOfRows=${_numOfRows}&sidoCd=${sidoCd}&yadmNm=${yadmNm}')
    );
    _XmlData = XmlDocument.parse(utf8.decode(response.bodyBytes));
    final myTransformer = Xml2Json();
    myTransformer.parse(_XmlData.toString());
    var json = jsonDecode(myTransformer.toParker());

    json['response']['body']['items']['item'].forEach((element) => _result.add(element));

    return _result;
  } catch (e) {
    return _result;
  }
}


/// 데이터가 없을 때
class Nodata extends StatelessWidget {
  final String? hospitalName;

  const Nodata({
    Key? key,
    this.hospitalName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$hospitalName'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: Text(
          '데이터가 없습니다.',
          style: TextStyle(fontSize: 17),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class HospitalDetailList extends StatelessWidget {
  final hospitalData;
  final List? data;

  HospitalDetailList({
    Key? key,
    this.hospitalData,
    this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _resultData = data ?? [];
    const String _noData = '정보없음';

    return Scaffold(
      appBar: AppBar(
        title: Text(hospitalData['yadmNm'] ?? _noData),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          hospitalInfo(
            addr: hospitalData['addr'],
            telno: hospitalData['telno'],
          ),
          SliverFillRemaining(
            child: ListView.separated(
            itemCount:_resultData.length,
            separatorBuilder: (BuildContext context, int index){
              return Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(
                    _resultData[index]['npayKorNm'] ?? _noData,
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_drop_up,
                            color: Colors.redAccent,
                          ),
                          Text(_resultData[index]['maxPrc']),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blueAccent,
                          ),
                          Text(_resultData[index]['minPrc']),
                        ],
                      ),
                    ],
                  )
              );
            })
          )
        ],
      ),
    );
  }
}

class hospitalInfo extends StatelessWidget {
  final String addr;
  final String telno;

  const hospitalInfo({
    Key? key,
    required this.addr,
    required this.telno
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          ListTile(
              trailing: IconButton(
                icon: Icon(Icons.pin_drop),
                onPressed: (){

                },
              ),
              title: Text(
                addr,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600
                ),
              )
          ),
          ListTile(
              trailing: IconButton(
                icon: Icon(Icons.local_phone),
                onPressed: (){
                  UrlLauncher.launch("tel://${telno}");
                },
              ),
              title: Text(
                telno,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600
                ),
              )
          )
        ],
      )
    );
  }
}
