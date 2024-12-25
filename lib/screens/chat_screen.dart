import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_prueba/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String? messageText;
  TextEditingController messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    loggedInUser = _auth.currentUser;

    if (loggedInUser != null) {
      print('Usuario Actual: ${loggedInUser!.email}');
    } else {
      print('Error');
    }
  }

  void addMessage() {
    _firestore.collection('message').add({
      'text': messageText,
      'sender': loggedInUser!.email,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void getMessages() async {
    await for (var snapshot in _firestore.collection('message').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  showSpinner = true;
                });

                Future.delayed(Duration(seconds: 2), () {
                  _auth.signOut();
                  setState(() {
                    showSpinner = false;
                  });
                  Navigator.pushNamed(context, WelcomeScreen.id);
                });
              }),
        ],
        title: Text(
          '⚡️ Chat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: MessageStream()),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        addMessage();
                        messageTextController.clear();
                      },
                      child: Text(
                        'Enviar',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('message')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }

          final messages = snapshot.data!.docs;
          List<Widget> messageWidgets = [];
          for (var message in messages) {
            final messageData = message.data() as Map<String, dynamic>;
            final messageText = messageData['text'];
            final messageSender = messageData['sender'];

            final isMe = messageSender == loggedInUser!.email;

            final messageWidget = Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    child: Text(
                      messageSender,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 121, 120, 120),
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: isMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            )
                          : BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            )
                    ),
                  color: isMe ? Colors.lightBlueAccent : Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messageText,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            );

            messageWidgets.add(messageWidget);
          }

          return ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,
          );
        });
  }
}
