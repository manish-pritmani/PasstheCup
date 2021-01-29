import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _status = true;
  var name;
  var email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.grey[100],
      child: Column(
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:32.0),
                    child: ClipOval(
                      child: CircleAvatar(
                          radius: 50,
                          child: Image.network(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")),
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Screen Name',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              initialValue: "Ayush",
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.only(bottom: 8),
                                hintText: "Enter Your Name",
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (text) {
                                setState(() {
                                  name = text;
                                });
                              },
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Email ID',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              initialValue: "ayushmehre@gmail.com",
                              decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                  hintText: "Enter Email ID"),
                              enabled: !_status,
                              onChanged: (text) {
                                setState(() {
                                  email = text;
                                });
                              },
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: OutlineButton(
                      onPressed: () {},
                      child: Text("Change Password"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
