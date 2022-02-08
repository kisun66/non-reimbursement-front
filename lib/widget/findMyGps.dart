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
    return IconButton(
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
                      return loading.spinningCircle('GPS정보를 수신중입니다...');
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
      }
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