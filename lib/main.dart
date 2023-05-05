import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:demo_flutter_project/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(
    // set the icon to show in the notification bar
    'resource://mipmap/ic_launcher',
    [
      NotificationChannel(
        channelKey: '1',
        channelName: 'Location Notification',
        channelDescription: 'Notification channel for location',
        defaultColor: Color(0xFF151515),
        ledColor: Colors.white,
      ),
    ],
    debug: true
  );
  runApp(GetMaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Exit!"),
            content: const Text("Do tou want to exit the app?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(14),
                  child: const Text("Yes"),
                ),
              ),
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  border: Border.all(
                    color: Color(0xFF3d4359),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      FontAwesomeIcons.idBadge,
                      color: Color(0xFF3d4359).withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        cursorColor: Color(0xFF3d4359),
                        keyboardType: TextInputType.text,
                        maxLength: 10,
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            hintText: "Username",
                            border: InputBorder.none,
                            counterText: ''),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 10,),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  border: Border.all(
                    color: Color(0xFF3d4359),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      FontAwesomeIcons.lock,
                      color: Color(0xFF3d4359).withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        cursorColor: Color(0xFF3d4359),
                        keyboardType: TextInputType.text,
                        maxLength: 10,
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            hintText: "Password",
                            border: InputBorder.none,
                            counterText: ''),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                if(_usernameController.text == "tester" && _passwordController.text == "Abc@9999"){
                  Get.to(() => const Home());
                }else{
                  Fluttertoast.showToast(
                      msg: "Invalid username or password",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              },
              child: Container(
                margin:
                const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color:Color(0xFF3d4359),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15),
                    child: Text("Sign in",
                        style: TextStyle(
                            fontFamily:
                            'Roboto-Regular',
                            //fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
