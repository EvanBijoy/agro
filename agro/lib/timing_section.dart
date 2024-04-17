import 'package:flutter/material.dart';

class TimingSection extends StatefulWidget {
  @override
  _TimingSectionState createState() => _TimingSectionState();
}

class _TimingSectionState extends State<TimingSection> {
  List<String> wateringTimes = [];

  void _addTime(String time) {
    setState(() {
      wateringTimes.add(time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Set Watering Times',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showTimePickerDialog(context);
            },
            child: Text('Add Time'),
          ),
          SizedBox(height: 20),
          Text(
            'Watering Times:',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: wateringTimes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  wateringTimes[index],
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      wateringTimes.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePickerDialog(BuildContext context) async {
    String? selectedTime = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return TimePickerDialog();
      },
    );

    if (selectedTime != null) {
      _addTime(selectedTime);
    }
  }
}

class TimePickerDialog extends StatefulWidget {
  @override
  _TimePickerDialogState createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  int selectedHour = 12;
  int selectedMinute = 0;
  bool isAm = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set Watering Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatableNumber(
                  value: selectedHour,
                  minValue: 1,
                  maxValue: 12,
                  onChanged: (value) {
                    setState(() {
                      selectedHour = value;
                    });
                  },
                ),
                SizedBox(width: 20),
                RotatableNumber(
                  value: selectedMinute,
                  minValue: 0,
                  maxValue: 59,
                  onChanged: (value) {
                    setState(() {
                      selectedMinute = value;
                    });
                  },
                ),
                SizedBox(width: 20),
                ToggleButtons(
                  isSelected: [isAm, !isAm],
                  onPressed: (index) {
                    setState(() {
                      isAm = index == 0;
                    });
                  },
                  children: [
                    Text('AM', style: TextStyle(color: Colors.white)),
                    Text('PM', style: TextStyle(color: Colors.white)),
                  ],
                  color: Colors.grey,
                  selectedColor: Colors.white,
                  fillColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  borderWidth: 2,
                  borderColor: Colors.grey,
                  selectedBorderColor: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String time = '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')} ${isAm ? 'AM' : 'PM'}';
                Navigator.of(context).pop(time);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class RotatableNumber extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  RotatableNumber({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  _RotatableNumberState createState() => _RotatableNumberState();
}

class _RotatableNumberState extends State<RotatableNumber> {
  late int _value;
  double _startAngle = 0.0;
  double _currentAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _startAngle = _currentAngle;
      },
      onPanUpdate: (details) {
        setState(() {
          _currentAngle = _startAngle + details.delta.dx * 0.01;
          int newValue = ((_currentAngle / (2 * 3.14)) * (widget.maxValue - widget.minValue)).toInt() + widget.minValue;
          if (newValue >= widget.minValue && newValue <= widget.maxValue) {
            _value = newValue;
            widget.onChanged(newValue);
          }
        });
      },
      child: Transform.rotate(
        angle: _currentAngle,
        child: Text(
          _value.toString().padLeft(2, '0'),
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }
}
