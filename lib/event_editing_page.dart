import 'package:calendar/event.dart';
import 'package:calendar/event_provider.dart';
import 'package:calendar/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event event;

  const EventEditingPage({Key key, this.event}) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  DateTime fromDate;
  DateTime toDate;

  final titleController = TextEditingController();
  // final _formkey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
    else{
      final event = widget.event;
      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
    }
  }


  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event's Page"),
        centerTitle: true,
        leading: CloseButton(),
        actions: [ buildEditingActions()
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextFormField(),
              Column(
                children: [
                  buildHeader(
                    header: "FROM",
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: buildDropdownField(
                            text: Utils.toDate(fromDate),
                            onClicked: () => pickFromDateTime(pickDate: true),
                          ),
                        ),
                        Expanded(
                          child: buildDropdownField(
                            text: Utils.toTime(fromDate),
                            onClicked: () => pickFromDateTime(pickDate: false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildHeader(
                    header: "TO",
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: buildDropdownField(
                            text: Utils.toDate(toDate),
                            onClicked: () => pickToDateTime(pickDate: true),
                          ),
                        ),
                        Expanded(
                          child: buildDropdownField(
                            text: Utils.toTime(toDate),
                            onClicked: () => pickToDateTime(pickDate: false),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField({
    String text,
    Function onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );


  TextFormField buildTextFormField() {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Add Title'
      ),
      onFieldSubmitted: (_) => saveForm(),
      validator: (title) =>
      title != null && title.isEmpty ? "Title cannot be empty" : null,
      controller: titleController,
    );
  }

  ElevatedButton buildEditingActions() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent
      ),
      onPressed: saveForm,
      icon: Icon(Icons.done),
      label: Text('SAVE'),);
  }

  Widget buildHeader({
    String header,
    Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: TextStyle(fontWeight: FontWeight.bold),),
          child,
        ],
      );

  Future pickFromDateTime({bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({bool pickDate}) async {
    final date = await pickDateTime(
        toDate, pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;

    // if (date.isAfter(toDate)){
    //   toDate = DateTime(date.year,date.month,date.day,toDate.hour,toDate.minute);
    // }
    setState(() {
      toDate = date;
    });
  }

  Future<DateTime> pickDateTime(DateTime initialDate,
      {bool pickDate, DateTime firstDate,
      }) async {
    if (pickDate) {
      final date = await showDatePicker(context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;

      final time = Duration(
          hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    }
    else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;

      final date = DateTime(
          initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      // Duration time;
      return date.add(time);
    }
  }

  Future saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: 'Description',
        from: fromDate,
        to: toDate,
        isAllDay: false,
        backgroundColor: Colors.blue,
      );
      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if(isEditing){
        provider.editEvent(event, widget.event);
        Navigator.of(context).pop();
      } else{
        provider.addEvent(event);
      }


      Navigator.of(context).pop();
    }
  }
}

