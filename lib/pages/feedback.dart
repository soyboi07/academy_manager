import 'dart:convert';
import 'dart:math';

import 'package:academy_manager/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:academy_manager/pages/splash.dart';

class FeedBack extends StatefulWidget {
  FeedBack({
    Key key,
    this.userId,
  }) : super(key: key);
  final String userId;
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  Widget teacherFeedback() {
    return StreamBuilder(
        stream: Firestore.instance.collection('Feedback').snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) return Splash();
          List feedback = [];
          String subjectName = '';
          String teacherName = '';

          snapshot.data.documents.forEach((element) {
            if (element.data[widget.userId] != null) {
              subjectName = element.data[widget.userId]['subject'];
              teacherName = element.data[widget.userId]['name'];

              String temp = 'Was good at explaining';
              List listi = [];
              listi = json.decode(element.data[widget.userId][temp]);
              print("1" + listi.toString());
              double avg = listi.length != 0
                  ? ((listi.fold(
                          0, (previous, current) => previous + current)) /
                      listi.length)
                  : 0.0;

              feedback.add([temp, avg.toStringAsFixed(2)]);

              temp = 'Taught at appropriate pace';
              listi = json.decode(element.data[widget.userId][temp]);
              avg = listi.length != 0
                  ? ((listi.fold(
                          0, (previous, current) => previous + current)) /
                      listi.length)
                  : 0.0;
              print("2" + listi.toString());
              feedback.add([temp, avg.toStringAsFixed(2)]);
              temp = 'Was able to complete syllabus within time';

              listi = json.decode(element.data[widget.userId][temp]);
              avg = listi.length != 0
                  ? ((listi.fold(
                          0, (previous, current) => previous + current)) /
                      listi.length)
                  : 0.0;
              print("3" + listi.toString());
              feedback.add([temp, avg.toStringAsFixed(2)]);
              temp = 'Was available to answer questions during office hours';
              listi = json.decode(element.data[widget.userId][temp]);
              avg = listi.length != 0
                  ? ((listi.fold(
                          0, (previous, current) => previous + current)) /
                      listi.length)
                  : 0.0;
              print("4" + listi.toString());
              feedback.add([temp, avg.toStringAsFixed(2)]);
              temp = "Overall rating";
              listi = json.decode(element.data[widget.userId][temp]);
              avg = listi.length != 0
                  ? ((listi.fold(
                          0, (previous, current) => previous + current)) /
                      listi.length)
                  : 0.0;
              print("5" + listi.toString());
              feedback.add([temp, avg.toStringAsFixed(2)]);
            }
          });
          return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    subjectName,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Text(
                  teacherName,
                  style: TextStyle(fontSize: 15),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: feedback.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Text(
                          '\u2022',
                        ),
                        title: Text(feedback[index][0].toString()),
                        trailing: Text(feedback[index][1].toString()),
                      );
                    }),
              ],
            ),
          );
        });
  }

  Widget studentFeedback() {
    int chooseSub = 1;
    int page = 1;
    List teachers = [];
    String subjectName = 'CC';
    String teacherName = '';
    String teacherId = '';
    int chooseTeacher = -1;
    List questions = [];
    List teacherValue = [3, 3, 3, 3, 3];
    Map<String, dynamic> finalSubmit = Map();
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Scaffold(
        body: page == 1
            ? Column(children: [
                ListTile(
                    title: Text('CC'),
                    leading: Radio(
                      value: 1,
                      activeColor: Constants.greenColor,
                      groupValue: chooseSub,
                      onChanged: (value) {
                        setState(() {
                          chooseSub = value;
                          subjectName = 'CC';
                        });
                      },
                    )),
                ListTile(
                    title: Text('CD'),
                    leading: Radio(
                      value: 2,
                      groupValue: chooseSub,
                      activeColor: Constants.greenColor,
                      onChanged: (value) {
                        setState(() {
                          chooseSub = value;
                          subjectName = 'CD';
                        });
                      },
                    )),
                ListTile(
                    title: Text('SE'),
                    leading: Radio(
                      value: 3,
                      groupValue: chooseSub,
                      activeColor: Constants.greenColor,
                      onChanged: (value) {
                        setState(() {
                          chooseSub = value;
                          subjectName = 'SE';
                        });
                      },
                    )),
                GestureDetector(
                  onTap: () {
                    DocumentReference _ref = Firestore.instance
                        .collection('Feedback')
                        .document(subjectName);

                    _ref.get().then((value) {
                      value.data.forEach((key, value) {
                        setState(() {
                          teachers.add([key, value['name'], value]);
                        });
                      });
                    });
                    setState(() {
                      page = 2;
                    });
                  },
                  child: // Rectangle
                      Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xffd0d0d0),
                                      offset: Offset(1, 2),
                                      blurRadius: 5,
                                      spreadRadius: 0),
                                  BoxShadow(
                                      color: const Color(0xffffffff),
                                      offset: Offset(-1, -2),
                                      blurRadius: 5,
                                      spreadRadius: 0)
                                ],
                                color: Constants.greenColor),
                            child: Center(
                                child: // I’ll do it later
                                    Text("Submit",
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Nunito",
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white,
                                            fontSize: 20),
                                        textAlign: TextAlign.center))),
                      ],
                    ),
                  ),
                )
              ])
            : page == 2
                ? Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: teachers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Radio(
                                activeColor: Constants.greenColor,
                                value: index,
                                groupValue: chooseTeacher,
                                onChanged: (value) {
                                  setState(() {
                                    chooseTeacher = value;
                                    questions = [];
                                    teacherName = teachers[value][1];
                                    teacherId = teachers[value][0];

                                    teachers[value][2].forEach((key1, value1) {
                                      if (key1 != 'name' && key1 != 'subject') {
                                        questions.add([
                                          key1,
                                          json.decode(value1.toString())
                                        ]);
                                      }
                                    });
                                  });
                                },
                              ),
                              title: Text(teachers[index][1]),
                            );
                          }),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            page = 3;
                          });
                        },
                        child: // Rectangle
                            Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: const Color(0xffd0d0d0),
                                            offset: Offset(1, 2),
                                            blurRadius: 5,
                                            spreadRadius: 0),
                                        BoxShadow(
                                            color: const Color(0xffffffff),
                                            offset: Offset(-1, -2),
                                            blurRadius: 5,
                                            spreadRadius: 0)
                                      ],
                                      color: Constants.greenColor),
                                  child: Center(
                                      child: // I’ll do it later
                                          Text("Submit",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Nunito",
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white,
                                                  fontSize: 20),
                                              textAlign: TextAlign.center))),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : page == 3
                    ? Column(
                        children: [
                          new ListView.builder(
                              shrinkWrap: true,
                              itemCount: questions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(questions[index][0].toString()),
                                      Slider(
                                        min: 0,
                                        max: 5,
                                        activeColor: Constants.greenColor,
                                        inactiveColor:
                                            Color.fromARGB(255, 167, 189, 168),
                                        divisions: 5,
                                        label: teacherValue[index].toString(),
                                        value: teacherValue[index].toDouble(),
                                        onChanged: (value) {
                                          setState(() {
                                            teacherValue[index] = value;
                                          });
                                        },
                                      ),
                                    ]);
                              }),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                for (int i = 0; i <= 4; i++) {
                                  questions[i][1].add(teacherValue[i]);
                                }
                                finalSubmit = {};
                                finalSubmit[teacherId] = {
                                  "name": teacherName,
                                  "subject": subjectName
                                };
                                questions.forEach((element) {
                                  finalSubmit[teacherId]
                                          [element[0].toString()] =
                                      element[1].toString();
                                });
                              });
                              DocumentReference _ref = Firestore.instance
                                  .collection('Feedback')
                                  .document(subjectName);
                              _ref.updateData(finalSubmit);
                              setState(() {
                                page = 4;
                              });
                            },
                            child: // Rectangle
                                Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 120,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: const Color(0xffd0d0d0),
                                                offset: Offset(1, 2),
                                                blurRadius: 5,
                                                spreadRadius: 0),
                                            BoxShadow(
                                                color: const Color(0xffffffff),
                                                offset: Offset(-1, -2),
                                                blurRadius: 5,
                                                spreadRadius: 0)
                                          ],
                                          color: Constants.greenColor),
                                      child: Center(
                                          child: // I’ll do it later
                                              Text("Submit",
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: "Nunito",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                  textAlign:
                                                      TextAlign.center))),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : Column(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                          child: Text(
                            'Thank you for your feedback, press continue to return',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Constants.greenColor, fontSize: 20),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chooseSub = 1;
                              page = 1;
                              teachers = [];
                              subjectName = 'CC';
                              teacherName = '';
                              teacherId = '';
                              chooseTeacher = -1;
                              questions = [];
                              teacherValue = [3, 3, 3, 3, 3];
                              finalSubmit = {};
                            });
                          },
                          child: // Rectangle
                              Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 140,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: const Color(0xffd0d0d0),
                                              offset: Offset(1, 2),
                                              blurRadius: 5,
                                              spreadRadius: 0),
                                          BoxShadow(
                                              color: const Color(0xffffffff),
                                              offset: Offset(-1, -2),
                                              blurRadius: 5,
                                              spreadRadius: 0)
                                        ],
                                        color: Constants.greenColor),
                                    child: Center(
                                        child: // I’ll do it later
                                            Text("Continue",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Nunito",
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white,
                                                    fontSize: 20),
                                                textAlign: TextAlign.center))),
                              ],
                            ),
                          ),
                        )
                      ]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(widget.userId)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return new Splash();
          }
          var userData = snapshot.data;

          bool isTeacher = userData['isTeacher'];

          return isTeacher ? teacherFeedback() : studentFeedback();
        });
  }
}
