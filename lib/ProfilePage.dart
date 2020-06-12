import 'package:flutter/material.dart';
import 'package:VegNSnap/loginPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';


final databaseReference = FirebaseDatabase.instance.reference();
var rating1 = 0.0;
String feedback = "";
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Map<String, bool> values = {
  'Soybeans': false,
  'Crustacean shellfish': false,
  'Peanuts': false,
  'Tree nuts': false,
  'Fish': false,
  'Wheat': false,
  'Eggs': false,
  'Milk': false,
  'Gluten' : false,
};

Future test() async
{
  if(email!="guest@vegn'snap.com")
  {
    databaseReference.once().then((DataSnapshot snapshot)
    {
      print(email);
      var em1 = email.substring(0,email.indexOf('@'));
      values=Map<String,bool>.from(snapshot.value[em1]['food']);
    });
  }
  else
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    values.forEach((key, value) {
      values[key] = prefs.getBool(key) ?? false;
    });
  }
}

class Profile extends StatefulWidget {
  Profile({Key key, this.title}) : super(key: key);
  final String title;
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<Profile> {
  var _result;
  @override
  void initState() {
    /* WidgetsBinding.instance.addPostFrameCallback((_) async {
            await test();
          }); */
    test().then((result){
      setState(() {
        _result = result;
      });
      print("Data retrived");
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(_result==null)
    {
      print("Fetching");
    }
    TextEditingController _textFieldController = TextEditingController();
    return Stack(children: <Widget>[
      Scaffold(
          key: _scaffoldKey,
          body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.4, 0.7, 0.9],
                  colors: [
                    Color(0xFF3594DD),
                    Color(0xFF4563DB),
                    Color(0xFF5036D5),
                    Color(0xFF5B16D0),
                  ],
                ),
              ),

              child: Container(
                  child: Column(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        SizedBox(height: 20),
                        Row(
                            children: [
                              SizedBox(width: 10),
                              Column(
                                  children: [

                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        imageUrl,
                                      ),
                                      radius: 45,
                                      backgroundColor: Colors.white,

                                    )
                                  ] ),
                              SizedBox(width: 10),
                              Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      'NAME: ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'EMAIL: ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      email,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),

                                    RaisedButton(
                                      onPressed: () {
                                        signOutGoogle();
                                        runApp(LoginPage());
                                      },
                                      color: Colors.deepPurple,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          'Sign Out',
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                      ),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40)),
                                    ),
                                    SizedBox(height: 5),
                                    RaisedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Please give us your feedback:'),
                                                content: TextField(
                                                  controller: _textFieldController,
                                                  decoration: InputDecoration(hintText: "Type here"),
                                                ),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                    child: new Text('SUBMIT', style: TextStyle(fontSize: 18.0,color: Colors.white)),
                                                    color: Colors.deepPurple,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(40)
                                                    ),
                                                    onPressed: () {
                                                      feedback = _textFieldController.text;
                                                      Navigator.of(context).pop();
                                                      giveFeedback(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      color: Colors.deepPurple,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          'Your Feedback',
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                      ),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40)),
                                    )
                                  ])
                            ]),
                        SizedBox(height: 15),
                        Text(
                          '  Scroll down and select the ingredients ',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white),
                        ),
                        Text(
                          'you are allergic to.',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white),
                        ),

                        Expanded(
                            child: Stack(children: <Widget>[
                              ListView(
                                children: values.keys.map(
                                      (String key) {
                                    return new CheckboxListTile(
                                      activeColor: Colors.white,
                                      checkColor: Colors.deepPurple,
                                      title: new Text(key, style: TextStyle(
                                          color: Colors.white),),
                                      value: values[key],
                                      onChanged: (bool value) {
                                        setState(() {
                                          values[key] = value;
                                        });
                                      },
                                    );
                                  },
                                ).toList(),

                              ),
                            ])),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                                width: 35.0,
                                height: 35.0,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  onPressed: () async {
                                    await createRecord();
                                  },
                                  child: Icon(Icons.check, color: Colors.deepPurple),
                                )
                            ))])))),
    ]);
  }

  Future createRecord() async {
    if(email!="guest@vegn'snap.com") {
      databaseReference.child(index).update({'food': values});
    }
    else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      values.forEach((key, value) {
        prefs.setBool(key, value);
      });
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Changes saved!")));
  }
}

Future giveFeedback(BuildContext context) async {
  if(email!="guest@vegn'snap.com") {
    final databaseReferenceFeedback = FirebaseDatabase(databaseURL: "https://veggie-buddie-feedback.firebaseio.com/").reference();
    databaseReferenceFeedback.push().set({
     'feedback': feedback
    });
  }

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thank you for your feedback'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Close', style: TextStyle(fontSize: 18.0,color: Colors.white) ),
              color: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
