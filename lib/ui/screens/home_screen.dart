import 'package:flutter/material.dart';
import 'package:zephyr18112020/ui/widgets/actu_carousel.dart';
import 'package:zephyr18112020/ui/widgets/casino_row.dart';
import 'package:zephyr18112020/ui/widgets/daily_mission_banner.dart';
import 'package:zephyr18112020/ui/widgets/event_carousel.dart';
import 'package:zephyr18112020/ui/widgets/main_app_bar.dart';
import 'package:zephyr18112020/ui/widgets/posts_carousel.dart';
import 'package:zephyr18112020/ui/widgets/sponsored_carousel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(
              double.infinity,
              50,
            ),
            child: MainAppBar(),
          ),
          body: ListView(
            children: [
              DailyMissionBanner(),
              CasinoRow(),
              EventCarousel(),
              SponsoredCarousel(),
              ActuCarousel(),
              PostsCarousel(),
              // GameCarousel(),
            ],
          ),
        ),
      ),
    );
  }
}
