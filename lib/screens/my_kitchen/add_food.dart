import 'package:flutter/material.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import 'components/add_new_food.dart';

class AddFood extends StatelessWidget {
  final String? position;

  const AddFood({Key? key, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamProvider<AppUser?>.value(
          initialData: GoogleSignInProvider().appUser,
          value: GoogleSignInProvider().user,
          child: ShowCaseWidget(
            builder: Builder(builder: (_) => AddNewFood(position: position),),
            autoPlay: true,
          )
      ),
    );
  }
}
