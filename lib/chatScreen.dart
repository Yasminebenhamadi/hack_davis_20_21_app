import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'classes/message.dart';
import 'classes/user.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "ChatScreen";
  final String connectionID;
  final User sender,receiver;//The id of the collection that stores the messages of the chat
  ChatScreen({this.connectionID,this.sender,this.receiver});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _messageText;
  User _sender,_receiver;
  CollectionReference _conversationCollection;
  Stream<QuerySnapshot> _conversationStream;
  TextEditingController _messageFieldController = TextEditingController ();
  final ScrollController _scrollController = ScrollController () ;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    setState(() {
      _sender = widget.sender; _receiver = widget.receiver;
      _conversationCollection = _firestore.collection('Connections').doc(widget.connectionID).collection('Chat');
      _conversationStream = _conversationCollection.snapshots(includeMetadataChanges: true);
    });
    return Scaffold(
      appBar: AppBar (
        title: Container(
          child: Center(
            child: Text(_receiver.name),
          ),
        ),
        actions: [
          //TODO
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<List<Message>> (
                stream: _conversationStream.map((event) {
                  List<Message> messages = List<Message> () ;
                  event.docs.forEach((document){
                    Message message = (Message.old(document.id,document.data()));
                    if(!message.seen){
                      document.reference.set({
                        message.seenKey : true,
                      });
                    }
                    if ((!event.metadata.isFromCache) || (DateTime.now().compareTo(message.time) >= 0))
                      message.sent = true ;
                    else
                      message.sent = false ;
                    messages.add(message);
                  });
                  return messages;
                }),
                builder: (buildContext,asyncSnapshot){
                  if(asyncSnapshot.hasError){
                    return Text('error');
                  }
                  else if (!asyncSnapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  else {
                    List<Message> messages = asyncSnapshot.data;
                    messages.sort();
                    return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (buildContext,int){
                          return _displayMessageWidget(messages[int]);
                        },
                    );
                  }
                },
              ),
          ),
          _sendMessageWidget(),
        ],
      ),
    );
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
              onPressed: () {
                if(_messageText.isNotEmpty){
                  _addMessage(Message(_messageText,'senderID','receiverID',DateTime.now(),false,false,false));
                }
                _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                _messageFieldController.clear();
              }),
        ],
      ),

    );
  }

  Widget _displayMessageWidget(Message message){
    final bool fromMe  = message.senderID == _sender.userID;
    return Container(
      margin: fromMe ? EdgeInsets.only(
          top: 8.0,
          bottom: 8.0 ,
          left: 90.0
      ) : EdgeInsets.only(
          top: 8.0,
          bottom: 8.0 ,
          right: 80.0
      ),
      decoration: BoxDecoration(
        color: fromMe ? Colors.pinkAccent: Colors.blueGrey ,
      ),
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
                  }
                  ),
            ],
          )
        ],
      ),
    );
  }
  Future<void> _addMessage (Message message) async {
    await _conversationCollection.add(message.messageToMap());
  }
}
