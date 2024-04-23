import 'dart:convert';

import 'package:agro/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';

import 'home_section.dart';

class InputSection extends StatefulWidget {
  @override
  _InputSectionState createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  int soilMoisture = 0;
  int temperature = 0;
  int relativeHumidity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900], // Dark background color
      padding: EdgeInsets.all(24.0), // Increased padding for the container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          IntegerInputField(
            label: 'Soil Moisture',
            value: mois_thres,
            onChanged: (value) {
              setState(() {
                mois_thres = value;
              });
            },
          ),
          SizedBox(height: 20),
          IntegerInputField(
            label: 'Temperature',
            value: temp_thres.toInt(),
            onChanged: (value) {
              setState(() {
                temp_thres = value.toDouble();
              });
            },
          ),
          SizedBox(height: 20),
          IntegerInputField(
            label: 'Relative Humidity',
            value: humd_thres.toInt(),
            onChanged: (value) {
              setState(() {
                humd_thres = value.toDouble();
              });
            },
          ),
          Spacer(), // Add Spacer to distribute space
          ElevatedButton(
            onPressed: () {
              // Apply the values if they are valid
              if (_areValuesValid()) {
                // Perform action with the validated values, e.g., save to database
                sendThreshold();
                publishThreshold();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Values set successfully')),
                );
              } else {
                // Show error message if values are not valid
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter values between 0 and 100')),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Green background color for button
              minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)), // Bigger button size
            ),
            child: Text(
              'Set',
              style: TextStyle(fontSize: 20), // Increased font size
            ),
          ),
        ],
      ),
    );
  }

  // Validation check for input values
  bool _areValuesValid() {
    return soilMoisture >= 0 &&
        soilMoisture <= 100 &&
        temperature >= 0 &&
        temperature <= 100 &&
        relativeHumidity >= 0 &&
        relativeHumidity <= 100;
  }
}

class IntegerInputField extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  IntegerInputField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold), // Increased font size
        ),
        SizedBox(height: 12), // Increased spacing
        TextFormField(
          keyboardType: TextInputType.number,
          initialValue: value.toString(),
          onChanged: (value) {
            int parsedValue = int.tryParse(value) ?? 0;
            onChanged(parsedValue);
          },
          style: TextStyle(color: Colors.white, fontSize: 18), // Increased font size
          decoration: InputDecoration(
            filled: true,
            fillColor:
                Colors.grey[800], // Dark grey background color for input field
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey[700]!)),
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0), // Increased padding
          ),
          validator: (value) {
            if (value != null) {
              int? parsedValue = int.tryParse(value);
              if (parsedValue == null ||
                  parsedValue < 0 ||
                  parsedValue > 100) {
                return 'Enter a value between 0 and 100';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}

void sendThreshold() async {
  final response = await http.post(
      Uri.parse(
          'http://192.168.12.1:8080/~/in-cse/in-name/AE-TEST/Node-1/threshold/'),
      headers: {'X-M2M-Origin': 'admin:admin', 'Content-Type': 'application/json;ty=4'},
  body: "{\n    \"m2m:cin\": {\n        \"con\": \"[$mois_thres, $temp_thres, $humd_thres]\"\n    } \n }");
  print("{\n    \"m2m:cin\": {\n        \"con\": \"[$mois_thres, $temp_thres, $humd_thres]\"\n    } \n }");
  print(response);
  print("hellodear");
  print(response.body);
}


void publishThreshold()
{
  String topicString = "/threshold";
  String thresholdString = mois_thres.toString() + " " + temp_thres.toString() + " " + humd_thres.toString();
  final builder1 = MqttClientPayloadBuilder();
  builder1.addString(thresholdString);
  print('EXAMPLE:: <<<< PUBLISH 3 >>>>');
  client.publishMessage(topicString, MqttQos.atLeastOnce, builder1.payload!);
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Input Section'),
      ),
      body: InputSection(),
    ),
  ));
}
