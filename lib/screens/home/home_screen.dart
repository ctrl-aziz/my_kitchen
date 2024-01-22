import 'package:flutter/material.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
      body: const Stack(
        children: [
          Body(),
        ],
      ),
    );
  }

  upperAppBar () {
    return AppBar(
      title: Center(
        child: Text(AppLocalizations.of(context)!.translate("Kitchen list")!,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}



