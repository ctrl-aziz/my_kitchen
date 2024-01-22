import 'package:flutter/material.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/auth.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';
import 'components/food_name_with_title.dart';

class DetailsScreen extends StatelessWidget {
  final String position;

  DetailsScreen({Key? key, required this.position}) : super(key: key);

  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamProvider<AppUser?>.value(
        initialData: GoogleSignInProvider().appUser,
        value: GoogleSignInProvider().user,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: FoodNameWithTitle(position: position),
            ),
            Expanded(
              flex: 3,
              child: Body(position: position, pageController: _controller,),
            ),
          ],
        ),
      ),
    );
  }
}
