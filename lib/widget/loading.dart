import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

var commonColor = Colors.blueAccent;
var commonBackgroundColor = Colors.white;

/// 원형 로딩창
var circularLoading = Container(
  color: commonBackgroundColor,
  child: Center(
    child: CircularProgressIndicator(backgroundColor: commonColor),
  )
);

/// HourGlass
var hourGlass = Container(
  color: commonBackgroundColor,
  child: SpinKitHourGlass(color: commonColor)
);

/// CubeGrid
var cubeGrid = Container(
  color: commonBackgroundColor,
  child: SpinKitCubeGrid(
    color: commonColor,
    size: 50,
  )
);

/// Wave
var wave = Container(
  color: commonBackgroundColor,
  child: SpinKitWave(
    color: commonColor,
    size: 50,
  )
);

/// SpinningCircle
spinningCircle(String message){
  if(message.isEmpty){
    message = '로딩중입니다...';
  }

  return Material(
    type: MaterialType.transparency,
    child: Container(
        color: commonBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSpinningCircle(
              color: commonColor,
              size: 50,
            ),
            SizedBox(height: 30),
            Text(
              message,
              style: TextStyle(fontSize: 15, color: commonColor),
            )
          ],
        )
    ),
  );
}