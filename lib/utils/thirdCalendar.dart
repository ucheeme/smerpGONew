import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar2 extends StatefulWidget {
  @override
  _CustomCalendar2State createState() => _CustomCalendar2State();
}

class _CustomCalendar2State extends State<CustomCalendar2> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final dayOfWeek = (index + 1) % 7; // Adjust to start from Monday
        return Text(
          DateFormat.E().format(DateTime(2023, 1, dayOfWeek)),
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      }),
    );
  }

  Widget _buildCalendarBody() {
    final List<DateTime> daysInMonth = List.generate(
      DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day,
          (index) => DateTime(_currentMonth.year, _currentMonth.month, index + 1),
    );

    return GridView.builder(
      shrinkWrap: true,
      itemCount: daysInMonth.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        final day = daysInMonth[index];
        final isSelected = _selectedDate.day == day.day &&
            _selectedDate.month == day.month &&
            _selectedDate.year == day.year;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = day;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Calendar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCalendarHeader(),
          Divider(),
          _buildCalendarBody(),
        ],
      ),
    );
  }
}