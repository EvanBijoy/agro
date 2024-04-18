import 'package:flutter/material.dart';

import 'data.dart';
import 'main.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({Key? key}) : super(key: key);

  @override
  _HomeSectionState createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  bool _isMotorOn = false;

  String temp = "-";
  String mois = "-";
  String humd = "-";
  String wlvl = "-";

  void _toggleMotor() {
    setState(() {
      _isMotorOn = !_isMotorOn;
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
                          _buildTile(
                              'Water Level', 'High', Colors.indigo[900]!, 1),
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
          GestureDetector(
            onTap: _toggleMotor,
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _isMotorOn ? Colors.red : Colors.green,
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

          if (click == 1)
            {
              y_max = 70;
              y_interval = 1;
            }
          else if (click == 2)
            {
              y_max = 5000;
              y_interval = 1000;
            }
          else {
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
