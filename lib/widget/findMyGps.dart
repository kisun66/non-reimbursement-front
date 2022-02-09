import 'kakao_map.dart' as kakaoMap;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'kakao_map.dart' as kakaoMap;
import './loading.dart' as loading;

class FindMyGps extends StatefulWidget {
  const FindMyGps({Key? key}) : super(key: key);

  @override
  _FindMyGpsState createState() => _FindMyGpsState();
}

class _FindMyGpsState extends State<FindMyGps> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.gps_fixed, size: 50),
          onPressed: () async {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => FutureBuilder(
                      future: getCurrentLocation(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.hasData == false) {
                          return loading.Loading(
                            message: 'GPS정보를 수신중입니다',
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          return kakaoMap.KakaoMap(
                            kakaoLatitude: snapshot.data.latitude.toString(),
                            kakaoLongitude: snapshot.data.longitude.toString(),
                          );
                        }
                      }
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const _begin = Offset(0.0, 1.0);
                    const _end = Offset.zero;
                    const _curve = Curves.ease;

                    var _tween = Tween(begin: _begin, end: _end).chain(CurveTween(curve: _curve));

                    return SlideTransition(
                      position: animation.drive(_tween),
                      child: child,
                    );
                  },
                )
            );
          }
        ),
        SizedBox(height: 10),
        Text('현재위치로 검색')
      ],
    );
  }
}

Future<Position> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
  );

  return position;
}