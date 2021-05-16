import 'package:calendar/event_provider.dart';
import 'package:calendar/event_view_page.dart';
import 'package:calendar/events_data_source.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class TasksWidget extends StatefulWidget {
  const TasksWidget({Key key}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventOfSelectedDate;

    if(selectedEvents.isEmpty){
      return Center(
        child: Text("No Events found!",
        style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }

    return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appointmentBuilder,
      headerHeight: 0,
      todayHighlightColor: Colors.black,
      selectionDecoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1)
      ),
      onTap: (details){
        if (details.appointments == null) return;
        final event = details.appointments.first;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewingPage(event: event),));
      },
    );
  }

  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details
      )
  {
    final event =details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(36)
      ),
      child: Center(
        child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

  }
}

