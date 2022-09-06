import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recipe_ventures/controllers/loginController.dart';
import 'package:recipe_ventures/pages/homepage.dart';
import 'package:open_mail_app/open_mail_app.dart';

class settingsPage extends StatefulWidget {
  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  double rating = 0;

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App",
              style: Theme.of(context).textTheme.headline6),
          content: Text("No mail apps installed",
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK", style: Theme.of(context).textTheme.bodyText1),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title:
                Text('Settings', style: Theme.of(context).textTheme.headline6),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.settings),
            //     onPressed: (){},
            ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Row(
                  //Send Feedback
                  children: [
                    SizedBox(height: 40),
                    Icon(
                      Icons.feedback,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(width: 10),
                    OutlinedButton(
                      child: Text("Send Feedback",
                          style: Theme.of(context).textTheme.headline6),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: BorderSide(width: 3.0, color: Colors.white),
                      ),
                      onPressed: () async {
                        EmailContent email = EmailContent(
                          to: [
                            'recipe_ventures@gmail.com',
                          ],
                          subject: 'Feedback for Recipe Ventures',
                        );

                        OpenMailAppResult result =
                            await OpenMailApp.composeNewEmailInMailApp(
                                nativePickerTitle:
                                    'Select email app to compose',
                                emailContent: email);
                        if (!result.didOpen && !result.canOpen) {
                          showNoMailAppsDialog(context);
                        } else if (!result.didOpen && result.canOpen) {
                          showDialog(
                            context: context,
                            builder: (_) => MailAppPickerDialog(
                              mailApps: result.options,
                              emailContent: email,
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
                //Divider(height: 20, thickness: 1),
                SizedBox(height: 10),
                giveFeedback(context, "Enjoying Recipe Ventures?"),
                Divider(height: 20, thickness: 1),
                buildOptions(context, "How-to"),
                SizedBox(height: 50),
                Row(children: [
                  SizedBox(height: 40),
                  Icon(
                    Icons.person,
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(width: 10),
                  Text("Account", style: Theme.of(context).textTheme.headline6)
                ]),
                Divider(height: 20, thickness: 1),
                buildOptions(context, "Edit Profile"),
                Divider(height: 20, thickness: 1),
                buildOptions(context, "Login Settings"),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 200, 0),
                  child: SizedBox(
                    width: 100.0,
                    height: 32.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        await LoginController().signOut();
                        Phoenix.rebirth(context);
                      },
                      child: Text("Logout"),
                    ),
                  ),
                )
              ],
            )));
  }
}

//Give Feedback Gesture
GestureDetector giveFeedback(BuildContext context, String title) {
  return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: RatingBar.builder(
                            minRating: 1,
                            itemBuilder: (context, _) =>
                                Icon(Icons.star, color: Colors.amber),
                            updateOnDrag: true,
                            onRatingUpdate: (rating) {})),
                  ],
                ),
                actions: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Submit")), //To close popup dialog
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"))
                  ])
                ],
              );
            });
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              SizedBox(width: 20),
              Text("Rate Us",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.lightBlueAccent))
            ],
          )));
}

//How-to, Edit Profile, Login Settings, Logout gestures
GestureDetector buildOptions(BuildContext context, String title) {
  return GestureDetector(
      onTap: () {},
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              Icon(Icons.arrow_forward_ios, color: Colors.grey)
            ],
          )));
}
