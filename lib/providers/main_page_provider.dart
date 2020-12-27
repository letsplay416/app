import 'package:flutter/cupertino.dart';

enum mPP {
  Home,
  ZoneGaming,
  ChatRoom,
  Menu,
}

class MainPageProvider with ChangeNotifier {
  mPP _currentPage;
  mPP get currentPage => _currentPage;

  MainPageProvider() {
    _currentPage = mPP.Home;
  }

 void changePage(mPP goTo) {
    _currentPage = goTo;
    notifyListeners();
  }
}
