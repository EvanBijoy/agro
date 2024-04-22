import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data.dart';
import 'home_section.dart';
import 'input_section.dart';
import 'analytics_section.dart';
import 'line_chart.dart';

// mqtt import stuff
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// mqtt variables
String broker = "192.168.12.1";
String username = "user1";
String password = "password";

String topicString = "/oneM2M/req/AE-TEST/in-cse/json";
String motorTopic = "/motor";
String motorStringStart = "{\n	\"m2m:rqp\": {\n		\"m2m:fr\": \"admin:admin\",\n		\"m2m:to\": \"/in-cse/in-name/AE-TEST/Node-1/motor\",\n		\"m2m:op\": 1,\n		\"m2m:pc\": {\n			\"m2m:cin\": {\n				\"con\": ";
String motorStringEnd = "\n			}\n		},\n		\"m2m:ty\": 4\n	}\n}";


late Future<List<Data>> dataList;
late List<Data> moisPlot;
late List<Data> moisMotorOnPlot;
late List<Data> moisMotorOffPlot;

late String currTemp;
late String currMois;
late String currHumd;
late String currWlvl;

int y_max = 5000;
int y_interval = 1000;

int which = 1;
String water_level = "";

late Data currData;
var currDataStream = ValueNotifier<Data>(const Data(index: 0, timestamp: "", motorstate: 0, mois: 0, temp: 0.0, humd: 0.0));

Timer? timer;

int max_instances = 2000;

void main() {
  // code for mqtt
  client = MqttServerClient.withPort(broker, '', 1883); // Replace with your broker's address
  // client.connect('my_user'); // Replace with a unique client ID

      final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        // .withWillTopic('willtopic') // If you set this you must set a will message
        // .withWillMessage('My Will message')
        // .startClean() // Non persistent session for testing
        .authenticateAs(username, password) // additional code when connecting to a broker w/ creds
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      client.connect(username, password);
    } catch (e) {
      print("ERROR: " + e.toString());
    }

  // code for fetching data from om2m by http

  dataList = fetchData();

  fetchRealTimeData();
  timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => fetchRealTimeData());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1; // Set initial index to center (Home)
  final List<Widget> _sections = [
    InputSection(),
    const HomeSection(),
    AnalyticsSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(child: _sections[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _sections[2] = AnalyticsSection();
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.anchor),
            label: 'Values',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

Future<List<Data>> fetchData() async {
  final response = await http.get(Uri.parse('http://192.168.12.1:8080/~/in-cse/in-name/AE-TEST/Node-1/DataUnlimited2?rcn=4'), headers: {
    'X-M2M-Origin': 'admin:admin',
    'Accept': 'application/json'
  });
  
  // print(response);
  // print("hello");
  // print(jsonDecode(response.body));

  var json = jsonDecode(response.body);

  if (response.statusCode == 200) {
    Iterable dataPoints = json["m2m:cnt"]["m2m:cin"];
    List<Data> dataList = List<Data>.from(List.from(dataPoints.toList().reversed.take(max_instances).toList().reversed).asMap().entries.map((model)=> Data.fromJson(model.value, model.key)));

    int x = 0;

    moisPlot = [];
    moisMotorOnPlot = [];
    moisMotorOffPlot = [];

    for (Data data in dataList)
      {
        // FlSpot tmp = FlSpot(x.toDouble(), data.mois.toDouble());
        if (x % 1 == 0)
          {
            moisPlot.add(data);
            Data dummy = Data(index: data.index, mois: null, humd: null, temp: null, motorstate: null, timestamp: data.timestamp);
            if (data.motorstate == 1)
              {
                // print(data.index);
                moisMotorOnPlot.add(data);
                moisMotorOffPlot.add(dummy);
              }
            else
              {
                moisMotorOffPlot.add(data);
                moisMotorOnPlot.add(dummy);
              }
          }
        ++x;
      }



    return dataList;
  } else {
    throw Exception('Failed to load album');
  }
}

void fetchWaterLevel() async {
  final response = await http.get(Uri.parse('http://192.168.12.1:8080/~/in-cse/in-name/AE-TEST/Node-1/WaterLevel/la'), headers: {
    'X-M2M-Origin': 'admin:admin',
    'Accept': 'application/json'
  });

  print(response);
  print("hello");
  print(jsonDecode(response.body));


  if (response.statusCode == 200) {
    String tmp = jsonDecode(response.body)["m2m:cin"]["con"].toString().trim();

    if (tmp == "0")
      {
        water_level = "LOW";
      }
    else
      {
        water_level = "HIGH";
      }

    print(water_level);
  } else {
    throw Exception('Failed to load album');
  }
}

void fetchRealTimeData() async {
  final response = await http.get(Uri.parse('http://192.168.12.1:8080/~/in-cse/in-name/AE-TEST/Node-1/DataUnlimited2/la'), headers: {
    'X-M2M-Origin': 'admin:admin',
    'Accept': 'application/json'
  });

  print(response);
  print("hello");
  print(jsonDecode(response.body));


  if (response.statusCode == 200) {
    var json = jsonDecode(response.body)["m2m:cin"];
    Data data = Data.fromJson(json, 0);
    currData = data;
    currDataStream.value = currData;
  } else {
    throw Exception('Failed to load album');
  }

  fetchWaterLevel();
  fetchData();
}