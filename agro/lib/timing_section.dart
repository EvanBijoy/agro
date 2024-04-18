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
            physics: CustomScrollPhysics(),
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
    Map<String, dynamic>? selectedTime = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return TimePickerDialog();
      },
    );

    if (selectedTime != null) {
      String time = selectedTime['time'];
      int duration = selectedTime['duration'];
      _addTime('$time ($duration minutes)');
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
  int selectedDuration = 10; // Default duration

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set Watering Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatableNumber(
                  value: selectedHour,
                  minValue: 0,
                  maxValue: 23,
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
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Duration (minutes)',
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String time = '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
                Navigator.of(context).pop({'time': time, 'duration': selectedDuration});
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

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        int newValue = _value - details.primaryDelta!.sign.toInt();
        if (newValue >= widget.minValue && newValue <= widget.maxValue) {
          setState(() {
            _value = newValue;
          });
          widget.onChanged(newValue);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          _value.toString().padLeft(2, '0'),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return ScrollSpringSimulation(
      SpringDescription(
        mass: 100000000,
        stiffness: 1.0,
        damping: 100.0,
      ),
      position.pixels,
      position.maxScrollExtent,
      velocity,
      tolerance: Tolerance(
        velocity: 0,
        distance: 10000000000000,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Timing Section'),
      ),
      body: TimingSection(),
    ),
  ));
}
