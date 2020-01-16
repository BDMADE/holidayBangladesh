import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holidaybangladesh/models/month.dart';
import 'package:holidaybangladesh/models/holiday.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main () {
  Admob.initialize(getAppId());
//  run the app
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
        fontFamily: 'Raleway'),
    home: SplashScreen(),
  ));
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Month> monthList = [
    Month(title: 'January', url: 'assets/json/jan.json'),
    Month(title: 'February', url: 'assets/json/feb.json'),
    Month(title: 'March', url: 'assets/json/mar.json'),
    Month(title: 'April', url: 'assets/json/apr.json'),
    Month(title: 'May', url: 'assets/json/may.json'),
    Month(title: 'June', url: 'assets/json/jun.json'),
    Month(title: 'July', url: 'assets/json/jul.json'),
    Month(title: 'August', url: 'assets/json/aug.json'),
    Month(title: 'September', url: 'assets/json/sep.json'),
    Month(title: 'October', url: 'assets/json/oct.json'),
    Month(title: 'November', url: 'assets/json/nov.json'),
    Month(title: 'December', url: 'assets/json/dec.json'),
  ];

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),
            ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => FirstScreen(months: monthList)
        )));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Center(
        child: Text('Holidays',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 50.0,
          color: Colors.white),
        ),
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  final List<Month> months;
  FirstScreen({Key key, @required this.months}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Holidays'), centerTitle: true,),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.builder(
          itemCount: months.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Card(
                elevation: 10.0,
                margin: EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen(month: months[index]),),);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                        SizedBox(height: 40.0),
                        Center(
                            child: Icon(
                              Icons.calendar_today,
                              size: 20.0,
                              color: Colors.white,
                            )),
                        SizedBox(height: 20.0),
                        new Center(
                          child: new Text(months[index].title, style:TextStyle(fontSize: 16.0, color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  // Declare a field that holds the Month.
  final Month month;
  // In the constructor, require a Month.
  SecondScreen({Key key, @required this.month}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.month.title,
          style: TextStyle(fontFamily: 'Raleway'),
        ),
          centerTitle: true,),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Container(
          child: Center(
            // Use future builder and DefaultAssetBundle to load the local JSON file
            child: FutureBuilder(
                future: DefaultAssetBundle.of(context).loadString(widget.month.url),
                builder: (context, snapshot) {
                  List<Holiday> holidays = parseJson(snapshot.data);
                  return holidays.isEmpty? Center(child: CircularProgressIndicator()): HolidayList(holiday: holidays);
                }),
          ),
        )
    );
  }

  List<Holiday> parseJson(String response) {
    if(response==null) {
      return [];
    }
    final parsed = json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Holiday>((json) => Holiday.fromJson(json)).toList();
  }
}

class HolidayList extends StatelessWidget {
  final List<Holiday> holiday;
  HolidayList({Key key, this.holiday}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: holiday == null ? 0 : holiday.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 10.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(padding: EdgeInsets.only(right: 12.0),decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.white24))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                      child: Column(
                        children: <Widget>[
                          Text(holiday[index].date, style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),),
                          Text(holiday[index].day, style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                  title: Text(holiday[index].name,style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold),),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Container(
                            // tag: 'hero',
                            child: LinearProgressIndicator(
                                backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                                value: 1.0,
                                valueColor: AlwaysStoppedAnimation(Color(int.parse(holiday[index].color)))),
                          )),
                      Expanded(
                        flex: 4,
                        child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(holiday[index].type,
                                style: TextStyle(color: Colors.white))),
                      )
                    ],
                  ),
                  trailing:Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ThirdScreen(data: holiday[index]),),);},
                ),
              )
          );
        });
  }
}

class ThirdScreen extends StatefulWidget {
  final Holiday data;
  ThirdScreen({Key key, @required this.data}) : super(key: key);
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.name, style: TextStyle(fontFamily: 'IndieFlower'),),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Card(
                elevation: 10.0,
                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    subtitle: Padding(padding: EdgeInsets.only(left: 10.0),
                        child: Text(widget.data.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        )
                    ),
                  ),
                )
            ),
            AdmobBanner(
              adUnitId: getBannerAdUnitId(),
              adSize: AdmobBannerSize.LARGE_BANNER,
            ),
          ],
        ),
      ),
    );
  }
}

String getAppId() {
  // test code
  return 'ca-app-pub-3940256099942544~3347511713';
  // real code
//  return 'ca-app-pub-8933442195154449~4178301396';

}

String getBannerAdUnitId() {
  //test code
  return 'ca-app-pub-3940256099942544/6300978111';
  // real code
 // return 'ca-app-pub-8933442195154449/9486468398';
}
