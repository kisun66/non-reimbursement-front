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
var spinningCircle = Container(
  color: commonBackgroundColor,
  child: SpinKitSpinningCircle(
    color: commonColor,
    size: 50,
  )
);