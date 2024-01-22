import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_kitchen/models/user.dart';
import 'database/user_database.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  bool _isSigningIn = false;


  static final GoogleSignInProvider _singleton = GoogleSignInProvider._internal();

  factory GoogleSignInProvider() {
    return _singleton;
  }

  GoogleSignInProvider._internal();

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  AppUser? get appUser => _userFromFirebaseUser(_auth.currentUser);


  AppUser? _userFromFirebaseUser(User? user){
    if (user != null) {
      return AppUser.uid(uid: user.uid);
    } else {
      return null;
    }
  }

  Stream<AppUser?> get user{
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Future signInWithGoogle() async {
  //   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  //   print("Sign in success");
  //   final GoogleSignInAuthentication googleAuth = await googleUser
  //       .authentication;
  //   print("Getting user success");
  //
  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //       idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
  //
  //   final User user = (await _auth.signInWithCredential(credential)).user;
  //   print("This is ${user.displayName}");
  //   print("This is ${user.email}");
  //   await DatabaseService(uid: user.uid).updateUserData(user.displayName.toString(), user.photoURL.toString(), 'fid(15)', 'fid(64)', '300', '200');
  //
  //   return _userFromFirebaseUser(user);
  // }
  Future login() async {
    isSigningIn = true;

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      print("This is ${user?.displayName}");

      if(user != null)
      await UserDatabaseService(uid: user.uid).updateUserData(user.displayName.toString(), user.photoURL.toString(), [], [], [], []);


      isSigningIn = false;
      return _userFromFirebaseUser(user);
    }
  }

  void logout() async{
    try{
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}