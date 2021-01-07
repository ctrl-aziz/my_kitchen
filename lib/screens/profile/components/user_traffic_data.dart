import 'package:flutter/material.dart';

class UserTrafficData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 35.0,),
        Column(
          children: [
            Text("40", style: TextStyle(fontWeight: FontWeight.bold),),
            Text("أتابعه", style: TextStyle(fontSize: 12.0),),
          ],
        ),
        SizedBox(width: 30.0,),
        Column(
          children: [
            Text("133.7K", style: TextStyle(fontWeight: FontWeight.bold),),
            Text("متابعون", style: TextStyle(fontSize: 12.0),),
          ],
        ),
        SizedBox(width: 10.0,),
        Column(
          children: [
            Text("906.0K", style: TextStyle(fontWeight: FontWeight.bold),),
            Text("تسجيلات الإعجاب", style: TextStyle(fontSize: 12.0),),
          ],
        ),
        SizedBox(width: 10.0,),
      ],
    );
  }
}
