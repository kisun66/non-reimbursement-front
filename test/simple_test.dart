import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';


void main() {
  test('xml파싱 테스트', () async {
    XmlDocument? XmlData;
    const serviceKey = 'HkDNhACAjb48Slc6oza%2Fklg%2FYmuIq%2FlHal3RgZDe3kc%2FpfhCWqYDJxC9XjMQ0tCPJdyx%2FRT%2FfgPImhlnn5G19Q%3D%3D';
    const pageNo = '1';
    const numOfRows = '100';
    const radius = '500';
    const url = 'http://apis.data.go.kr/B551182/hospInfoService1/getHospBasisList1?';
    const xPos = '127.09854004628151';
    const yPos = '37.6132113197367';

    try {

      http.Response response = await http.get(
        Uri.parse('${url}serviceKey=${serviceKey}&pageNo=${pageNo}&numOfRows=${numOfRows}&radius=${radius}&xPos=${xPos}&yPos=${yPos}')
      );
      XmlData = XmlDocument.parse(response.body);
      final myTransformer = Xml2Json();
      myTransformer.parse(XmlData.toString());
      var json = jsonDecode(myTransformer.toParker());

      var result = [];
      json['response']['body']['items']['item'].forEach((element) => result.add(element));
    } catch (e) {
      print('url 정보 불러오기 실패');
    }
  });

  test('카카오맵 멀티마커 테스트', (){
    addMultiMarker(){
      var data = [{'XPos': '127.0165047'}, {'XPos': '127.0165047'}];
      var result = '';

      for(int i = 0; i < data.length; i++) {
        result += '''
          addMarker(new kakao.maps.LatLng(${data[i]['XPos']}, ${data[i]['XPos']}));
          kakao.maps.event.addListener(markers[${i}], 'click', function(){
            onTapMarker.postMessage('marker is tapped');
          });
        ''';
      }

      return result;
    }

    print(addMultiMarker());
  });
}