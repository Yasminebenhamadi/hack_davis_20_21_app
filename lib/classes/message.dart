import 'package:cloud_firestore/cloud_firestore.dart';

class Message implements Comparable<Message> {
  String _messageID;
  String _message;
  String _senderID;
  String _receiverID;
  DateTime _time;
  bool _sent;
  bool _seen;
  bool _delivered;
  final String _messageKey = 'Message';
  final String _timeKey = 'DateTime';
  final String _senderIDKey = 'SenderID';
  final String _receiverIDKey = 'ReceiverID';
  final String _deliveredKey = 'Delivered';
  final String _seenKey = 'Seen';
  final String _sentKey = 'Sent';

  Message(this._message,this._senderID,this._receiverID,this._time,this._sent,this._seen,this._delivered);
  Message.old(this._messageID,Map<String,dynamic> data){
    _message = data[_messageKey];
    _senderID = data[_senderIDKey];
    _receiverID = data[_receiverIDKey];
    Timestamp timestamp = data[_timeKey];
    _time = timestamp.toDate();
    _sent = data[_sentKey];
    _seen = data[_seenKey];
    _delivered = data[_deliveredKey];
  }

  Map<String,dynamic> messageToMap (){
    return {
      _messageKey : this._message,
      _timeKey : Timestamp.fromDate(this._time),
      _senderIDKey : this._senderID,
      _receiverIDKey : this._receiverID,
      _deliveredKey : this._delivered,
      _seenKey : this._seen,
      _sentKey: this._sent,
    };
  }

  @override
  int compareTo(Message other) {
    return - this._time.compareTo(other._time);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Message &&
              runtimeType == other.runtimeType &&
              _messageID == other._messageID;

  @override
  int get hashCode => _messageID.hashCode;
  //Getters & setters
  bool get delivered => _delivered;

  set delivered(bool value) {
    _delivered = value;
  }

  bool get sent => _sent;

  set sent(bool value) {
    _sent = value;
  }

  bool get seen => _seen;

  String get message => _message;

  String get messageID => _messageID;

  String get receiverID => _receiverID;

  String get senderID => _senderID;

  DateTime get time => _time;

  String get deliveredKey => _deliveredKey;

  String get sentKey => _sentKey;

  String get seenKey => _seenKey;


}