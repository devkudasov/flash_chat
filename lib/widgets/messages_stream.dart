import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class MessagesStream extends StatelessWidget {
  final Stream<QuerySnapshot> _messagesStream =
      FirebaseFirestore.instance.collection('messages').snapshots();
  final User? currentUser;

  MessagesStream({Key? key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _messagesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            reverse: true,
            children: snapshot.data?.docs.reversed
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      final text = data['text'];
                      final sender = data['sender'];

                      return MessageBubble(
                        text: text,
                        sender: sender,
                        isMe: currentUser?.email == sender,
                      );
                    })
                    .toList()
                    .cast() ??
                [],
          );
        },
      ),
    );
  }
}
