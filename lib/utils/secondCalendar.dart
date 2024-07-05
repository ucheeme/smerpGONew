import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}
class _CustomCalendarState extends State<CustomCalendar> {

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.subtract(Duration(days: daysInMonth(
                      DateTime.now().month,
                      DateTime.now().year)));
               });
              },
            ),
            Text(DateFormat.yMMM().format(_selectedDate)),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.add(Duration(days: daysInMonth(
                     DateTime.now().month,
                      DateTime.now().year)));
                });
              },
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            final date = DateTime(_selectedDate.year, _selectedDate.month, index + 1);
            final weekday = date.weekday;

            if (index < weekday - 1 || index >= daysInMonth(_selectedDate.month,
                _selectedDate.year) + weekday - 1) {
              return Container();
            }

            return InkWell(
              onTap: () {
                // Handle calendar day click
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: date.day == DateTime.now().day &&
                      date.month == DateTime.now().month &&
                      date.year == DateTime.now().year
                      ? Colors.blueAccent
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    "${date.day}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: weekday == 7 || weekday == 6 ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: 35,
        ),
      ],
    );
  }

  int daysInMonth(int month, int year) {
    if (month == 2) {
      if (year % 4 == 0) {
        if (year % 100 == 0) {
          if (year % 400 == 0) {
            return 29;
          }
          return 28;
        }
        return 29;
      }
      return 28;
    }
    if ([4, 6, 9, 11].contains(month)) {
      return 30;
    }
    return 31;
  }
}
