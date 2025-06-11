import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(stream: FirebaseFirestore.instance.collection('chats').orderBy('createdAt',
        descending: true, ).snapshots( ), builder: (ctx, chatSnapshots){
      if(chatSnapshots.connectionState == ConnectionState.waiting){
    return Center(
    child: CircularProgressIndicator(),
    );
    }

      if(!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty){
        return Center(
          child: Text('No messages found'),
        );
      }
      if(chatSnapshots.hasError){
        return Center(
          child: Text('Something went wrong'),
        );
      }

      final loadedMessages = chatSnapshots.data!.docs;
      return ListView.builder(
          padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount:loadedMessages.length ,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 <loadedMessages.length ? loadedMessages[index +1].data() : null;

            final currentMessageUserId = chatMessage['UserId'];
            final nextMessageUserId = nextChatMessage != null ? nextChatMessage['UserId'] : null;

            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame){
              return MessageBubble.next(message: chatMessage['text'],
                isMe: authenticatedUser.uid==currentMessageUserId,);
            } else {
              return MessageBubble.first(username: chatMessage['username'],
                message: chatMessage['text'], isMe: authenticatedUser.uid==currentMessageUserId,);
            }



          },
      );
      },
    );

  }
}
