import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

const commonColor = Colors.blueAccent;
const commonBackgroundColor = Colors.white;

class Loading extends StatelessWidget {
  final String? message;

  const Loading({
    Key? key,
    this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
          color: commonBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitSpinningCircle(
                color: commonColor,
                size: 50,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message ?? '로딩중입니다',
                    style: TextStyle(fontSize: 17, color: commonColor),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(fontSize: 17, color: commonColor),
                    child: AnimatedTextKit(
                      animatedTexts: [WavyAnimatedText('.....')],
                      isRepeatingAnimation: true,
                    ),
                  )
                ],
              )
            ],
          )
      )
    );
  }
}