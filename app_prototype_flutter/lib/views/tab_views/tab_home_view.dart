import 'package:app_prototype_flutter/widgets/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_prototype_flutter/services/auth_service.dart';

class HomeView extends StatelessWidget {

/*
  final List<Event> eventList= [
    Event("Homecoming", DateTime.now(), 200.00, "This is a test party", "Club", {"52.2165157": 6.9437819}),
    Event("Prom", DateTime.now(), 167.00, "This is a test party", "Club", {"52.2165157": 6.9437819}),
    Event("Theta Tau Tailgate", DateTime.now(), 0.00, "This is a test party", "Club", {"52.2165157": 6.9437819}),
    Event("NSBE Bonefire", DateTime.now(), 369.00, "This is a test party", "Club", {"52.2165157": 6.9437819}),
    Event("Project X", DateTime.now(), 24489.00, "This is a test party", "Club", {"52.2165157": 6.9437819}),
  ];
 */
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: getAllEventsStreamSnapshot(context),
        builder: (context, snapshot){
          if(!snapshot.hasData) return const Text("Loading...");
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildEventCard(context, snapshot.data.documents[index]));
        }
      )
    );
  }

  Stream<QuerySnapshot> getUsersEventsStreamSnapshot(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('userData').document(uid).collection('events').snapshots();
  }

  Stream<QuerySnapshot> getAllEventsStreamSnapshot(BuildContext context) async* {
    //final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('events').snapshots();
  }

  //Widget for the Cards
  Widget buildEventCard(BuildContext context, DocumentSnapshot event){
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(children: <Widget>[
                  Text((event['title'] == null )? "N/A" : event['title'], style: new TextStyle(fontSize: 30.0)),
                  Spacer(),
                ],),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(children: <Widget>[
                  Text("${(event['date'] == null )? "N/A" : DateFormat('MM/dd/yyyy').format(event['date'].toDate()).toString()} at ${DateFormat('jm').format(event['date'].toDate()).toString()}"),
                  Spacer(),
                ],),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(children: <Widget>[
                  Text((event['description'] == null )? "N/A" : event['description']),
                  Spacer(),
                  //Text("\$${event.price.toStringAsFixed(2)}", style: new TextStyle(fontSize: 20.0)),
                ],),
              ),

              /*
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(children: <Widget>[
                  Text(event['eventType']),
                  Spacer(),
                  Icon(Icons.location_on),
                  //Text(event.location.toString()),
                ],),
              ),
               */
            ],
          ),
        ),
      ),
    );
  }

}
