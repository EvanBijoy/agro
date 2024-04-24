import 'package:flutter/material.dart';

// mqtt import stuff
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'data.dart';
import 'main.dart';

// mqtt stuff
String broker = "10.42.0.60"; // change IP addr accordingly
String username = "user1";
String password = "password";

String topicString = "/oneM2M/req/AE-TEST/in-cse/json";
String motorTopic = "/motor";
String motorStringStart =
    "{\n	\"m2m:rqp\": {\n		\"m2m:fr\": \"admin:admin\",\n		\"m2m:to\": \"/in-cse/in-name/AE-TEST/Node-1/motor\",\n		\"m2m:op\": 1,\n		\"m2m:pc\": {\n			\"m2m:cin\": {\n				\"con\": ";
String motorStringEnd = "\n			}\n		},\n		\"m2m:ty\": 4\n	}\n}";

var state = 0;

var client;

bool _isMotorOn = false;

bool user_override = false;

void publish() {
  if (_isMotorOn) {
    state = 1;
  } else {
    state = 0;
  }

  String motorString = motorStringStart + state.toString() + motorStringEnd;

  final builder1 = MqttClientPayloadBuilder();
  builder1.addString(motorString);
  print('EXAMPLE:: <<<< PUBLISH 1 >>>>');
  client.publishMessage(topicString, MqttQos.atLeastOnce, builder1.payload!);

  final builder2 = MqttClientPayloadBuilder();
  builder2.addString(state.toString());
  print('EXAMPLE:: <<<< PUBLISH 2 >>>>');
  client.publishMessage(motorTopic, MqttQos.atLeastOnce, builder2.payload!);
}


void publishOverride(bool override) {
  String overrideString = override ? "1" : "0";
  String overrideTopic = "/override";

  final builder2 = MqttClientPayloadBuilder();
  builder2.addString(overrideString);
  print('EXAMPLE:: <<<< PUBLISH 2 >>>>');
  client.publishMessage(overrideTopic, MqttQos.atLeastOnce, builder2.payload!);
}

class HomeSection extends StatefulWidget {
  const HomeSection({Key? key}) : super(key: key);

  @override
  _HomeSectionState createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {

  String temp = "-";
  String mois = "-";
  String humd = "-";
  String wlvl = "-";

  void _toggleMotor() {
    setState(() {
      _isMotorOn = !_isMotorOn;
      publish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ValueListenableBuilder(
            //TODO 2nd: listen playerPointsToAdd
            valueListenable: currDataStream,
            builder: (context, value, widget) {
              //TODO here you can setState or whatever you need
              return Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTile('Temperature', value.temp.toString(),
                              Colors.blue[900]!, 1),
                          _buildTile('Soil Moisture', value.mois.toString(),
                              Colors.green[900]!, 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTile('Relative Humidity', value.humd.toString(),
                              Colors.orange[900]!, 3),
                          _buildTile('Water Level', water_level,
                              Colors.indigo[900]!, 1),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Switch(
            // This bool value toggles the switch.
            value: user_override,
            activeColor: Colors.red,
            onChanged: (bool value) {
              publishOverride(value);
              setState(() {
                user_override = value;
              });
            },
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: user_override ? _toggleMotor : null,
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: user_override ? (_isMotorOn ? Colors.red : Colors.green) : Colors.blueGrey,
              ),
              alignment: Alignment.center,
              child: Text(
                _isMotorOn ? 'Turn Motor Off' : 'Turn Motor On',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(String title, String value, Color color, int click) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Your onPressed logic here
          which = click;

          if (click == 1) {
            y_max = 100;
            y_interval = 1;
          } else if (click == 2) {
            y_max = 100;
            y_interval = 1;
          } else {
            y_max = 100;
            y_interval = 1;
          }

          print('Container pressed!');
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
