import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prueba_crud/database/Helper.dart';
import 'package:prueba_crud/models/User.dart';
import 'package:prueba_crud/utils/Utils.dart';

class MyPages extends StatefulWidget {
  MyPages({Key key}) : super(key: key);

  String title = 'Hola';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyPages> {
  bool flag = false;
  bool insertItem = false;

  final teNombreController = TextEditingController();
  final teTelefonoController = TextEditingController();
  final teEmailController = TextEditingController();

  List<User> items = new List();
  List<User> values;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: getAllUser(),
      floatingActionButton: _buildFab(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    print("INIT");
    _scrollController = new ScrollController();
    _scrollController.addListener(() => setState(() {}));
  }

  Widget _buildFab() {
    bool visibilityFlag = true;
    double max;
    double currentScroll;

    if (_scrollController.hasClients) {
      //visibilityFlag = true;

      max = _scrollController.position.maxScrollExtent;
      double min = _scrollController.position.minScrollExtent;
      currentScroll = _scrollController.position.pixels;

      if ((min == currentScroll) &&
          (_scrollController.position.userScrollDirection ==
              ScrollDirection.idle)) {
        visibilityFlag = true;
      } else if (max == currentScroll) {
        visibilityFlag = false;
      }
    }

    return new Visibility(
      visible: visibilityFlag,
      child: new FloatingActionButton(
        onPressed: () => openAlertBox(null),
        tooltip: 'Increment',
        backgroundColor: Color(0xff00bfa5),
        child: Icon(Icons.add),
      ),
    );
  }

  ///edit User
  editUser(int id) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var user = User();
      user.id = id;
      user.nombre = teNombreController.text;
      user.telefono = teTelefonoController.text;
      user.email = teEmailController.text;
      var dbHelper = Helper();
      dbHelper.update(user).then((update) {
        teNombreController.text = "";
        teTelefonoController.text = "";
        teEmailController.text = "";
        Navigator.of(context).pop();
        showtoast("Data Saved successfully");
        setState(() {
          flag = false;
        });
      });
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  ///add User Method
  addUser() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var user = User();
      user.nombre = teNombreController.text;
      user.telefono = teTelefonoController.text;
      user.email = teEmailController.text;
      var dbHelper = Helper();
      dbHelper.insert(user).then((value) {
        teNombreController.text = "";
        teTelefonoController.text = "";
        teEmailController.text = "";
        Navigator.of(context).pop();
        showtoast("Successfully Added Data");
        setState(() {
          insertItem = true;
        });
      });
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  /// Alert que se muestra
  openAlertBox(User user) {
    if (user != null) {
      teNombreController.text = user.nombre;
      teTelefonoController.text = user.telefono;
      teEmailController.text = user.email;
      flag = true;
    } else {
      flag = false;
      teNombreController.text = "";
      teTelefonoController.text = "";
      teEmailController.text = "";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      flag ? "Edit User" : "Add User",
                      style: TextStyle(fontSize: 28.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: teNombreController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Add Name",
                            fillColor: Colors.grey[300],
                            border: InputBorder.none,
                          ),
                          validator: validateName,
                          onSaved: (String val) {
                            teNombreController.text = val;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: teTelefonoController,
                          decoration: InputDecoration(
                            hintText: "Add Phone",
                            fillColor: Colors.grey[300],
                            border: InputBorder.none,
                          ),
                          maxLines: 1,
                          validator: validateMobile,
                          onSaved: (String val) {
                            teTelefonoController.text = val;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: teEmailController,
                          decoration: InputDecoration(
                            hintText: "Add Email",
                            fillColor: Colors.grey[300],
                            border: InputBorder.none,
                          ),
                          maxLines: 1,
                          validator: validateEmail,
                          onSaved: (String val) {
                            teEmailController.text = val;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => flag ? editUser(user.id) : addUser(),
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Color(0xff00bfa5),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0)),
                    ),
                    child: Text(
                      flag ? "Edit User" : "Add User",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else if (value.length > 30) {
      return 'Name must be less than 30 charater';
    } else
      return null;
  }

  String validateMobile(String value) {
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = new RegExp(pattern);
    if (value.trim().length != 10)
      return 'Mobile Number must be of 10 digit';
    else if (value.startsWith('+', 0)) {
      return 'Mobile Number should not contain +91';
    } else if (value.trim().contains(" ")) {
      return 'Blank space is not allowed';
    } else if (!regex.hasMatch(value)) {
      return 'Characters are not allowed';
    } else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else if (value.length > 30) {
      return 'Email length exceeds';
    } else
      return null;
  }

  getAllUser() {
    return FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return createListView(context, snapshot);
      },
    );
  }

  ///Fetch data from database
  Future<List<User>> _getData() async {
    var dbHelper = Helper();
    await dbHelper.getAllUsers().then((value) {
      items = value;
      if (insertItem) {
        _listKey.currentState.insertItem(values.length);
        insertItem = false;
      }
    });

    return items;
  }

  ///create List View with Animation
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    values = snapshot.data;
    if (values != null) {
      showProgress();
      return new AnimatedList(
          key: _listKey,
          controller: _scrollController,
          shrinkWrap: true,
          initialItemCount: values.length,
          itemBuilder: (BuildContext context, int index, animation) {
            return _buildItem(values[index], animation, index);
          });
    } else
      return Container();
  }

  //Construct cell for List View
  Widget _buildItem(User values, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          onTap: () => onItemClick(values),
          title: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.brown.shade800,
                      child: Text(
                        values.nombre.substring(0, 1).toUpperCase(),
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 5.0)),
                  new Row(
                    children: <Widget>[
                      Icon(Icons.account_circle),
                      Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)),
                      new InkWell(
                        child: Container(
                          constraints: new BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 200),
                          child: Text(
                            values.nombre,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.normal,
                                color: Colors.black),
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0)),
                  new Row(
                    children: <Widget>[
                      Icon(Icons.phone),
                      Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)),
                      new InkWell(
                        child: new Text(
                          values.telefono.toString(),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0)),
                  new Row(
                    children: <Widget>[
                      Icon(Icons.email),
                      Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)),
                      new InkWell(
                        child: Container(
                          constraints: new BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 200),
                          child: new Text(
                            values.email.toString(),
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 10.0)),
                ],
              ),
            ],
          ),
          trailing: Column(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: IconButton(
                    color: Colors.black,
                    icon: new Icon(Icons.edit),
                    onPressed: () => onEdit(values, index)),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: IconButton(
                    color: Colors.black,
                    icon: new Icon(Icons.delete),
                    onPressed: () => onDelete(values, index)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///On Item Click
  onItemClick(User values) {
    print("Clicked position is ${values.nombre}");
  }

  /// Delete Click and delete item
  onDelete(User values, int index) {
    var id = values.id;
    var dbHelper = Helper();
    dbHelper.delete(id).then(
      (value) {
        User removedItem = items.removeAt(index);

        AnimatedListRemovedItemBuilder builder = (context, animation) {
          return _buildItem(removedItem, animation, index);
        };
        _listKey.currentState.removeItem(index, builder);
      },
    );
  }

  /// Edit Click
  onEdit(User user, int index) {
    openAlertBox(user);
  }
}
