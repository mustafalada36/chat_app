import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _messageController = TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async{
final enteredMessage = _messageController.text;

  if(enteredMessage.trim().isEmpty){
    return;
  }

  _messageController.clear();
  FocusScope.of(context).unfocus();

  final user= FirebaseAuth.instance.currentUser!;
  final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  FirebaseFirestore.instance.collection('chats').add({
    'text': enteredMessage,
    'createdAt': Timestamp.now(),
    'UserId': user.uid,
    'username': userData.data()!['username'],

  });


  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 15,right: 1,bottom: 14),
      child: Row(
        children: [
          Expanded(child: TextField(
            controller: _messageController ,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(
              labelText: 'Send a message...'
            ),
          ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
              onPressed: _submitMessage, icon: Icon(
            Icons.send,
          ))
        ],
      ),
    )
    ;
  }
}
