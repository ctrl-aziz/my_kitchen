import 'package:flutter/material.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/auth.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';
import 'components/food_name_with_title.dart';

class DetailsScreen extends StatelessWidget {
  final String position;

  const DetailsScreen({Key? key,required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: StreamProvider<AppUser?>.value(
        initialData: GoogleSignInProvider().appUser,
        value: GoogleSignInProvider().user,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FoodNameWithTitle(position: position),
            Body(position: position),
          ],
        ),
      ),
    );
  }
}
