import 'package:flutter/material.dart';

class HomeSection extends StatefulWidget {
  @override
  _HomeSectionState createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  bool _isMotorOn = false;

  void _toggleMotor() {
    setState(() {
      _isMotorOn = !_isMotorOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTile('Temperature', '25°C', Colors.blue[900]),
                      _buildTile('Soil Moisture', '60%', Colors.green[900]),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTile('Relative Humidity', '40%', Colors.orange[900]),
                      _buildTile('Water Level', 'High', Colors.indigo[900]),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _toggleMotor,
            child: Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _isMotorOn ? Colors.red : Colors.green,
              ),
              alignment: Alignment.center,
              child: Text(
                _isMotorOn ? 'Turn Motor Off' : 'Turn Motor On',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(16.0),
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
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
