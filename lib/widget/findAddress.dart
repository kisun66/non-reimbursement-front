import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'kakao_map.dart' as kakaoMap;
import './loading.dart' as loading;

class FindAddress extends StatefulWidget {
  const FindAddress({Key? key}) : super(key: key);

  @override
  State<FindAddress> createState() => _findAdressState();
}

class _findAdressState extends State<FindAddress> {
  String postCode = '-';
  String address = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.all(0.0), // 기본 padding 제거
          icon: Icon(Icons.book, size: 50), // 50 이상으로 설정 시 오른쪽으로 넘어감
          onPressed: () async {
            Kpostal kPostal = await Navigator.push(context, MaterialPageRoute(builder: (_) => KpostalView(
                kakaoKey: '53a136cf20bd4263c00b68fbf310d71f',
                onLoading: loading.Loading(
                  message: '주소창을 불러오고있습니다',
                )
            )));
            if(kPostal.postCode.isNotEmpty){
              try{
                kakaoLatitude = kPostal.kakaoLatitude.toString();
                kakaoLongitude = kPostal.kakaoLongitude.toString();

                await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => kakaoMap.KakaoMap(kakaoLatitude : kakaoLatitude, kakaoLongitude : kakaoLongitude),
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
                      transitionDuration: Duration(milliseconds: 200),
                    )
                );
              } catch(e) {
                Text('문제가 발생했습니다.');
              }
            }
          },
        ),
        SizedBox(height: 10),
        Text('주소로 검색')
      ]
    );
  }
}