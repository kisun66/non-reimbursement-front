import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import './loading.dart' as loading;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

class HospitalDetail extends StatelessWidget {
  const HospitalDetail({Key? key, required this.sidoCd, required this.yadmNm}) : super(key: key);
  final String sidoCd;
  final String yadmNm;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHospitalDetail(sidoCd, yadmNm),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        print(snapshot.data);
        if (snapshot.hasData == false) {
          return loading.spinningCircle('비급여 정보를 불러오고 있습니다');
        } else if (snapshot.hasError) {
          return Text('Error');
        } else {
          if(snapshot.data.length < 1){
            return Scaffold(
              appBar: AppBar(
                title: Text('${yadmNm}'),
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
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('${yadmNm}'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
              ),
              body: Container(
                child: ListView.separated(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return ListTile(
                        leading: Icon(Icons.list),
                        trailing: Text('병원'),
                        title: Text(snapshot.data[index]['npaySdivCdNm'])
                    );
                  },
                  separatorBuilder: (context, index){
                    return Divider();
                  },
                ),
              ),
              backgroundColor: Colors.white,
            );
          }
        }
      },
    );
  }
}

getHospitalDetail(String sidoCd, String yadmNm) async {
  XmlDocument? XmlData;
  const serviceKey = 'HkDNhACAjb48Slc6oza%2Fklg%2FYmuIq%2FlHal3RgZDe3kc%2FpfhCWqYDJxC9XjMQ0tCPJdyx%2FRT%2FfgPImhlnn5G19Q%3D%3D';
  const pageNo = '1';
  const numOfRows = '1000';
  const url = 'http://apis.data.go.kr/B551182/nonPaymentDamtInfoService/getNonPaymentItemHospList2?';
  var result = [];

  try {
    http.Response response = await http.get(
        Uri.parse('${url}serviceKey=${serviceKey}&pageNo=${pageNo}&numOfRows=${numOfRows}&sidoCd=${sidoCd}&yadmNm=${yadmNm}')
    );
    XmlData = XmlDocument.parse(utf8.decode(response.bodyBytes));
    final myTransformer = Xml2Json();
    myTransformer.parse(XmlData.toString());
    var json = jsonDecode(myTransformer.toParker());

    json['response']['body']['items']['item'].forEach((element) => result.add(element));

    return result;
  } catch (e) {
    return result;
  }
}