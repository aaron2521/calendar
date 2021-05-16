import 'package:calendar/calendar_widget.dart';
import 'package:calendar/event_editing_page.dart';
import 'package:calendar/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          accentColor: Colors.white,
          scaffoldBackgroundColor: Colors.black
        ),
        // routes: <String, WidgetBuilder>{
        //   '/event': (BuildContext context) => EventEditingPage(),
        // },
        debugShowCheckedModeBanner: false,
        home: MainPage()
      ),
    );
  }
}





class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        centerTitle: true,
      ),
      body: CalendarWidget(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed:  () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => (EventEditingPage())));
          }
      ),
    );
  }
}
