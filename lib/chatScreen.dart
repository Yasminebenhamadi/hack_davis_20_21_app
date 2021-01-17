import 'package:flutter/material.dart';
import 'classes/message.dart';

class ChatScreen extends StatefulWidget {
  final String uid1;
  ChatScreen({this.uid1});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _messageText;
  //Stream<QuerySnapshot> _conversationStream ;
  TextEditingController _messageFieldController = TextEditingController ();

  @override
  Widget build(BuildContext context) {
    setState(() {

    });
    return Container();
  }
  Widget _sendMessageWidget (){
    return Container(
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _messageFieldController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration.collapsed(
                  hintText: 'Envoyer un message...',
                ),
                onChanged: (value) {
                  _messageText = value ;
                },
              ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              //TODO color
              onPressed: () {
                //TODO
              }),
        ],
      ),

    );
  }
  Widget _displayMessageWidget(Message message){
    final bool left  = message.receiverID == widget.uid1;
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(message.message),
              IconButton(
                  icon: Icon(
                    message.seen ? Icons.remove_red_eye
                        :
                    message.delivered? Icons.check_circle:
                    message.sent ? Icons.check_circle_outline:
                    Icons.panorama_fish_eye,
                  ),
                  iconSize: 25.0,
                  //TODO color
                  onPressed: () {
                    //TODO
                  }
                  ),
            ],
          )
        ],
      ),
    );

  }
}
