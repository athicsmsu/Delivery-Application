import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Appdata with ChangeNotifier {
  String userStatus = '';
  String page = '';
  LatLng latLng = const LatLng(0, 0);
  late UserProfile user;
  late ForgotPassword forgotUser;
}

class UserProfile {
  int id = 0;
}

class ForgotPassword {
  int id = 0;
  String type = '';
  String phone = '';
}
