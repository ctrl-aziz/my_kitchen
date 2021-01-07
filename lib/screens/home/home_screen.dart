import 'package:flutter/material.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final _toggleNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _toggleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: upperAppBar(),
      body: Stack(
        children: [
          Body(),
        ],
      ),
    );
  }

  upperAppBar () {
    return AppBar(
      title: Center(
        child: Text(AppLocalizations.of(context).translate("Kitchen list"),
          style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}



