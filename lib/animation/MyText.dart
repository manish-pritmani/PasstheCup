import 'package:flutter/material.dart';

class MyText extends StatelessWidget {

  final text;
  final TextStyle style;
  final TextAlign textAlign;

  MyText(this.text, {this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    if(text==null){
      return Text('null', style: style, textAlign: textAlign,);
    }
    return Text(this.text, style: style, textAlign: textAlign,);
  }
}
