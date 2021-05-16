import 'package:calendar/event.dart';
import 'package:calendar/event_editing_page.dart';
import 'package:flutter/material.dart';


class EventViewingPage extends StatelessWidget {

  final Event event;

  const EventViewingPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: CloseButton(),
          actions: [buildEditingActions(context, event),]
      ),
    );
  }

  buildEditingActions(BuildContext context, Event event) {
    return Row(
      children: [
        IconButton(icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EventEditingPage(event: event,)))),
        IconButton(icon: Icon(Icons.delete), onPressed: (){}),
      ],
    );
  }
}