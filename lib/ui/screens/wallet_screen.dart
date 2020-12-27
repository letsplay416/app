import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zephyr18112020/ui/widgets/chat_item.dart';
import 'package:zephyr18112020/ui/widgets/my_app_bar.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zephyr18112020/ui/screens/recharge_screen.dart';
import 'package:zephyr18112020/ui/screens/withdraw_screen.dart';

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          context: context, title: "Wallet", todo: () => context.pop()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Card(
                color: Theme.of(context).accentColor,
                child: BettingGraph(),
                elevation: 5,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Wallet(),
            BetList([]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: "Ajouter",
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20)),
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.upload,
                        color: Color(0xFFe5e5e5),
                      ),
                      title: Text(
                        'Recharger',
                        style: TextStyle(color: Colors.amber),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        context.nextPage(Recharge());
                      },
                    ),
                    ListTile(
                        leading: Icon(
                          FontAwesomeIcons.handHoldingUsd,
                          color: Color(0xFFe5e5e5),
                        ),
                        title: Text(
                          'Retrait',
                          style: TextStyle(color: Colors.amber),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          context.nextPage(WithdrawScreen());
                        }),
                  ],
                ),
              ),
            ),
          );
        },
        child: Icon(
          FontAwesomeIcons.wallet,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

class BetList extends StatelessWidget {
  final List bets;

  const BetList(this.bets);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: bets.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Aucun pari",
                  style: TextStyle(color: Color(0xFFe5e5e5), fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: Image.asset(
                  "assets/images/gaming.png",
                  fit: BoxFit.cover,
                  height: 200,
                )),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) => Card(
                color: Color(0xFF1b1e44),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).accentColor, width: 2),
                      ),
                      child: Text(
                        bets[index].amount.toStringAsFixed(2),
                        style: TextStyle(
                          color: Color(0xFFe5e5e5),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(bets[index].title,
                            style: TextStyle(
                              color: Color(0xFFfca311),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                        Text(DateFormat('kk:mm:ss').format(bets[index].date),
                            style: TextStyle(
                                color: Color.fromRGBO(184, 194, 199, 1.0)))
                      ],
                    )
                  ],
                ),
              ),
              itemCount: bets.length,
            ),
    );
  }
}

class Wallet extends StatefulWidget {
  static const namedRoute = "/wallet-screen";

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GetPseudo(
                      uid: context.watch<User>().uid,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Let's Play",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(FontAwesomeIcons.question),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GetWalletData(
                  color: Theme.of(context).accentColor,
                  dataType: "bullets",
                  icon: FontAwesomeIcons.edge,
                ),
                GetWalletData(
                  color: Colors.amber,
                  dataType: "coins",
                  icon: FontAwesomeIcons.coins,
                ),
                GetWalletData(
                  color: Colors.blue,
                  dataType: "diamonds",
                  icon: FontAwesomeIcons.gem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardStatus extends StatelessWidget {
  final IconData iconName;
  final Color colorCard;
  final String newCases;
  final String totalCases;
  final String status;
  const CardStatus({
    this.iconName,
    this.colorCard,
    this.newCases,
    this.totalCases,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220, padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      // width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF2d3447).withOpacity(0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40 / 2),
                border: Border.all(color: colorCard, width: 2),
                color: colorCard.withOpacity(0.5),
              ),
              width: 40,
              height: 40,
              child: Icon(iconName),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "[+$newCases]",
              style: TextStyle(color: colorCard, fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "$totalCases",
              style: TextStyle(
                  color: colorCard, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              status,
              style: TextStyle(color: colorCard, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class GetWalletData extends StatefulWidget {
  final String dataType;
  final Color color;
  final IconData icon;
  const GetWalletData({
    @required this.dataType,
    @required this.color,
    @required this.icon,
  });
  @override
  _GetWalletDataState createState() => _GetWalletDataState();
}

class _GetWalletDataState extends State<GetWalletData> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(context.watch<User>().uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new SpinKitFadingCircle(
              size: 20,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                  ),
                );
              },
            );
          }
          var userDocument = snapshot.data;
          String bullet = userDocument[widget.dataType].toString();
          var bullets = bullet.length > 4
              ? toCurrencyString(userDocument[widget.dataType].toString(),
                  shorteningPolicy: ShorteningPolicy.Automatic)
              : bullet;
          return CardStatus(
            colorCard: widget.color,
            iconName: widget.icon,
            newCases: "1",
            status: widget.dataType.toUpperCase(),
            totalCases: bullets,
          );
        },
      ),
    );
  }
}

class BettingGraph extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  @override
  State<StatefulWidget> createState() => BettingGraphState();
}

class BettingGraphState extends State<BettingGraph> {
  final Color barBackgroundColor = Color(0xFF2d3447);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Color(0xFF1b1e44),
        elevation: 6,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Historique',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Semaine derniere',
                    style: TextStyle(
                        color: Color(0xFFe5e5e5),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        refreshState();
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.amber,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: [isTouched ? Theme.of(context).accentColor : barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            colors: [barBackgroundColor],
            y: 20,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 7.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Lundi';
                  break;
                case 1:
                  weekDay = 'Mardi';
                  break;
                case 2:
                  weekDay = 'Mercredi';
                  break;
                case 3:
                  weekDay = 'Jeudi';
                  break;
                case 4:
                  weekDay = 'Vendredi';
                  break;
                case 5:
                  weekDay = 'Samedi';
                  break;
                case 6:
                  weekDay = 'Dimanche';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'L';
              case 1:
                return 'M';
              case 2:
                return 'M';
              case 3:
                return 'J';
              case 4:
                return 'V';
              case 5:
                return 'S';
              case 6:
                return 'D';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'L';
              case 1:
                return 'M';
              case 2:
                return 'M';
              case 3:
                return 'J';
              case 4:
                return 'V';
              case 5:
                return 'S';
              case 6:
                return 'D';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return null;
        }
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
