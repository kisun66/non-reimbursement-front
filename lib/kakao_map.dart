import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

const String kakaoMapKey = '53a136cf20bd4263c00b68fbf310d71f';

class KakaoMap extends StatelessWidget {
  const KakaoMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    try{
      return KakaoMapView(
        width: size.width,
        height: 400,
        kakaoMapKey: kakaoMapKey,
        lat: 33.450701,
        lng: 126.570667,
        showMapTypeControl: true,
        showZoomControl: true,
        markerImageURL: 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
        onTapMarker: (message) {
          //event callback when the marker is tapped
        });
    } catch(e) {
      return Text('Error');
    }

  }
}
