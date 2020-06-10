import 'dart:async';
import 'dart:io' as io;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:VegNSnap/loginPage.dart';
import 'package:VegNSnap/ProfilePage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart' show DeviceOrientation, rootBundle;

final databaseReferenceLatest = FirebaseDatabase(databaseURL: "https://veggie-buddie-latestdate.firebaseio.com/").reference();
final databaseReference = FirebaseDatabase.instance.reference();
final databaseReferenceUnknown = FirebaseDatabase(databaseURL: "https://veggie-buddie-unknown.firebaseio.com/").reference();
final databaseReferenceVeg = FirebaseDatabase(databaseURL: "https://veggie-buddie-veg.firebaseio.com/").reference();
final databaseReferenceVegan = FirebaseDatabase(databaseURL: "https://veggie-buddie-vegan.firebaseio.com/").reference();
final databaseReferencenonVeg = FirebaseDatabase(databaseURL: "https://veggie-buddie-nonveg.firebaseio.com/").reference();
final databaseReferencedelimiters = FirebaseDatabase(databaseURL: "https://veggie-buddie-delimiters.firebaseio.com/").reference();

String ing  = "";
int day =0;
int month = 0;
int year = 0;
int userday =0;
int usermonth = 0;
int useryear = 0;
io.File fileveg;
io.File filenonveg;
io.File filevegan;
io.File filedelimiters;
String veg1 = "";
String nonveg1 = "";
String vegan1 = "";
String delimiter1 = "";
var nonVeg;
var vegetarian;
var vegan;
var delimiterFinal;

var now = new DateTime.now();
Map<String,String> updatedate = {
  'Year': now.year.toString(),
  'Month': now.month.toString(),
  'Day': now.day.toString()
};


void veg()
{
  databaseReferenceVeg.once().then((DataSnapshot snapshot) {
    List<dynamic> vegIng3 = snapshot.value;
    veg1 = vegIng3.join("\n");
    fileveg.writeAsString(veg1);
  });
}

void getvegan()
{
  databaseReferenceVegan.once().then((DataSnapshot snapshot) {
    List<dynamic> veganIng = snapshot.value;
    vegan1 = veganIng.join("\n");
    filevegan.writeAsString(vegan1);
  });
}

void getdelimiters()
{
  databaseReferencedelimiters.once().then((DataSnapshot snapshot) {
    List<dynamic> delimiter = snapshot.value;
    delimiter1 = delimiter.join("\n");
    print("delim1: "+delimiter1);
    filedelimiters.writeAsString(delimiter1);
  });
}

void nonveg()
{
  databaseReferencenonVeg.once().then((DataSnapshot snapshot) {
    List<dynamic> nonvegIng = snapshot.value;
    nonveg1 = nonvegIng.join("\n");
    filenonveg.writeAsString(nonveg1);
  });
}

Future test() async{

  final directory = await getApplicationDocumentsDirectory();
  final path1 = directory.path;

  if(name!="Guest") {
    String em1 = email.substring(0,email.indexOf("@"));
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.once().then((DataSnapshot snapshot) {
      values = Map<String, bool>.from(snapshot.value[em1]['food']);

    });
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
    fileveg = io.File('$path1/veg.txt');
    filenonveg = io.File('$path1/nonveg.txt');
    filevegan = io.File('$path1/vegan.txt');
    filedelimiters = io.File('$path1/delimiters.txt');


    databaseReferenceLatest.child("date").once().then((DataSnapshot snapshot) {
      day = snapshot.value['day'];
      month = snapshot.value['month'];
      year = snapshot.value['year'];
    });
    databaseReference.child(index).child("date").once().then((
        DataSnapshot snapshot) {
      userday = snapshot.value['day'];
      usermonth = snapshot.value['month'];
      useryear = snapshot.value['year'];
    });

    if (year >= useryear) {
      if(year == useryear)
      {
        if(month>usermonth)
        {
          updated = false;
        }
        else if(month == usermonth)
        {
          if(day>userday)
            updated = false;
        }
      }
      else
      {
        updated = false;
      }
    }

    if(updated == false) {
      veg();
      nonveg();
      getvegan();
      getdelimiters();
      updated = true;
      databaseReference.child(index).update({
        'date': updatedate
      });
      print("Updated!");
    }
  }
  else
  {
    bool there = await io.File('$path1/veg.txt').exists();
    if(there)
    {
      fileveg = io.File('$path1/veg.txt');
      filenonveg = io.File('$path1/nonveg.txt');
      filevegan = io.File('$path1/vegan.txt');
      filedelimiters = io.File('$path1/delimiters.txt');
    }
    else
    {
      nonVeg=await getFileData("lists/non-veg.txt");
      vegan = await getFileData("lists/vegan.txt");
      vegetarian = await getFileData("lists/vegetarian.txt");
      delimiterFinal = await getFileData("lists/delimiters.txt");
    }

  }
}

List<CameraDescription> cameras;
Future<List<String>> getFileData(String path) async {
  var readLines = await rootBundle.loadString(path);
  return readLines.split("\n");
}

class FlutterVisionHome extends StatefulWidget {
  @override
  _FlutterVisionHomeState createState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return _FlutterVisionHomeState();
  }
}
void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _FlutterVisionHomeState extends State<FlutterVisionHome> {
  CameraController controller;
  String imagePath;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    test();
    print(values);
    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Container(
        child: Container(
          child: Center(
            child: _cameraPreviewWidget(),
          ),
        ),
      ),
    );
  }
  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Container(
        /* height: MediaQuery.of(context).size.height,  */
        /* width: MediaQuery.of(context).size.width/controller.value.aspectRatio, */
          child:AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Container(
                  child: Stack(
                      children: <Widget>[
                        CameraPreview(controller),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child:Column(children: <Widget>[
                              SizedBox(height: MediaQuery.of(context).size.height-172),
                              FloatingActionButton(
                                child: Icon(Icons.camera_alt,color: Colors.black,),
                                backgroundColor: Colors.white,
                                onPressed: controller != null &&
                                    controller.value.isInitialized
                                    ? onTakePictureButtonPressed
                                    : null,
                              ),
                            ]
                            )
                        ),
                      ]
                  )
              )
          )
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          showInSnackBar('Picture saved to $filePath');
          detectLabels().then((_) {
          });
        }
      }
    });
  }



  Future<void> detectLabels() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(
        imagePath);
    final TextRecognizer textRecognizer = FirebaseVision.instance
        .textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(
        visionImage);
    String nvIng = "Non-Vegetarian: ";
    String vegIng = "Vegetarian: ";
    String veganIng = "Vegan: ";
    String allerIng = "Allergens: ";
    String text = "";
    String text1 = "";
    String notFound = "Not Found: ";
    int check = 0;
    int nvFlag = 0;
    int veganFlag = 0;
    int vegFlag = 0;
    int alleFlag = 0;
    String newStr;
    String t = "";

    bool end = false;
    var lines;
    if(name!="Guest"){
      String nonVeg2;
      String veg2;
      String vegan2;
      String delim2;
      try {
        nonVeg2 = await filenonveg.readAsString();
        veg2 = await fileveg.readAsString();
        vegan2 = await filevegan.readAsString();
        delim2 = await filedelimiters.readAsString();
      } catch (e) {
        print(e.toString());
      }
      nonVeg = nonVeg2.split("\n");
      vegetarian = veg2.split("\n");
      vegan = vegan2.split("\n");
      delimiterFinal = delim2.split("\n");
    }
    var allergies=["test"];
    if(values["Soybeans"]==true)
      allergies=(await getFileData("lists/allergens/soy.txt"));
    if(values["Crustacean shellfish"]==true)
      allergies=[...allergies, ...(await getFileData("lists/allergens/shellfish.txt"))];
    if(values["Peanuts"]==true)
      allergies=[...allergies, ...(await getFileData("lists/allergens/peanuts.txt"))];
    if(values["Tree nuts"]==true)
      allergies=[...allergies, ...(await getFileData("lists/allergens/treenuts.txt"))];
    if(values["Fish"]==true)
      allergies=[...allergies, ...(await getFileData("lists/allergens/fish.txt"))];
    if(values["Wheat"]==true)
      allergies=[...allergies, ...(await getFileData("lists/allergens/wheat.txt"))];
    if(values["Eggs"]==true)
      allergies=[...allergies, ...(await getFileData("lists/allergens/eggs.txt"))];
    if(values["Milk"]==true)
      allergies=[...allergies, ...(await getFileData("lists/allergens/milk.txt"))];
    if(values["Gluten"]==true)
      allergies=[...allergies, ...(await getFileData("lists/allergens/gluten.txt"))];

    for (TextBlock block in visionText.blocks) {
      if(end)
        break;
      else
        for (TextLine line in block.lines) {
          for(String del in delimiterFinal) {
            if (line.text.toLowerCase()!="" && line.text.toLowerCase().contains(del)) {
              end = true;
              break;
            }
          }
          if(end)
            break;
          lines = line.text.split(",");
          //for (TextElement element in line.elements) {
          for(String element in lines) {
            var lines2 = element.split("(");
            for (String element2 in lines2) {
              var lines3 = element2.split(")");
              for (String element3 in lines3) {
                var lines4 = element3.split("[");
                for (String element4 in lines4) {
                  var lines5 = element4.split("]");
                  for (String element5 in lines5) {
                    newStr = element5.toLowerCase();
                    if ((text.contains("ingredient") ||
                        newStr.contains("ingredient")) && newStr!="") {
                      text = text + newStr + ",";
                    }
                  }
                }
              }
            }
          }
          if(line.text.toLowerCase().contains("contains:"))
          {
            end = true;
            break;
          }
        }
    }
    var finals = text.split(",");
    for(String element in finals) {
      if(element!="") {
        for (String nonv in nonVeg) {
          if (element.contains(nonv) && nonv != "") {
            print("nonv: " + nonv);
            if (!nvIng.contains(nonv))
              nvIng = nvIng + nonv + ", ";
            check += 1;
            nvFlag = 1;
          }
        }
        for (String veg1 in vegetarian) {
          if (element.contains(veg1) && veg1 != "") {
            if (!vegIng.contains(veg1))
              vegIng = vegIng + element + ", ";
            check += 1;
            vegFlag = 1;
          }
        }
        for (String vega in vegan) {
          if (element.contains(vega) && vega != "") {
            if (!veganIng.contains(vega))
              veganIng = veganIng + vega + ", ";
            check += 1;
            veganFlag = 1;
          }
        }
        for (String alle in allergies) {
          if (element.contains(alle)) {
            if(!allerIng.contains(alle))
             allerIng = allerIng + alle + ", ";
            alleFlag = 1;
          }
        }
        if (check == 0) {
          if (element != " " || element != "")
            notFound = notFound + element + ", ";
          if (name != "Guest" && element != "") {
            databaseReferenceUnknown.push().set({
              'item': element
            });
          }
        }
        check = 0;
      }
    }
    if(allerIng!="Allergens: ")
    {
      text1 += "\n"+allerIng;
    }
    if(nvIng!="Non-Vegetarian: ")
    {
      text1 += "\n\n"+nvIng;
    }
    if(vegIng!="Vegetarian: ")
    {
      text1 += "\n\n"+vegIng;
    }
    if(veganIng!="Vegan: ")
    {
      text1 += "\n\n"+veganIng;
    }
    String status = "The ingredients could not be detected!";
    int x=1;
    String filegif = "gifs/notfound.gif";
    if(notFound!="Not Found: ")
    {
      if(text!="")
        text1+="\n\n" +notFound;
      status = "\nSorry, one or more ingredients were not found";
      x =1;
    }
    else if (nvFlag==1) {
      status="The product is Non-Vegetarian!";
      filegif = "gifs/nonveg.gif";
      x=0;
    }
    else if(vegFlag == 1){
      status = "The product is Vegetarian!";
      filegif = "gifs/vegetarians.gif";
      x=0;
    }
    else if(veganFlag == 1){
      status = "The product is Vegan!";
      filegif = "gifs/veganPower.gif";
      x=0;
    }


    if(x==0)
      t="You are not allergic to this!";
    if(x==1)
      t = "";
    else if(alleFlag==1)
      t="You are allergic to this!";

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: new Column(
              children: <Widget>[
                Image.asset(filegif, height: 200, width: 250),
                Text(status+"\n"+t,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )
                ),
                SizedBox(height: 12),
                Expanded(
                    child: new SingleChildScrollView(
                        child: new Text(text1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15
                            ))
                    )),
              ]
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok', style: TextStyle(fontSize: 18.0,color: Colors.white)),
              color: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ));
    textRecognizer.close();
  }
  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final io.Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/Foodie';
    await io.Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';
    if (controller.value.isTakingPicture) {
      return null;
    }
    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }
  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
class FlutterVisionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterVisionHome(),
    );
  }
}