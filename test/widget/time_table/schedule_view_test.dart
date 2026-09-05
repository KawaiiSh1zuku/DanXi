import 'package:dan_xi/model/time_table.dart';
import 'package:dan_xi/widget/time_table/day_events.dart';
import 'package:dan_xi/widget/time_table/schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('expanded schedule fills its bounded desktop area',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final course = Course()
      ..courseName = 'Test course'
      ..roomName = 'Room 101';
    final days = List.generate(
      6,
      (day) => DayEvents(
        weekday: day,
        day: 'Day $day',
        events: day == 0 ? [Event(course, CourseTime(day, 9))] : [],
      ),
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 1000,
            height: 600,
            child: ScheduleView(
              days,
              const TimetableStyle(),
              TimeNow(1, 0, 0),
              1,
              fillAvailableSpace: true,
            ),
          ),
        ),
      ),
    ));

    expect(tester.getSize(find.byType(LayoutGrid)), const Size(1000, 600));
    expect(find.text('Test course'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
