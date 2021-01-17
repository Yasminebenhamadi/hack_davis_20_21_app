class Message implements Comparable<Message> {
  String _messageID;
  String _message;
  String _senderID;
  String _receiverID;
  DateTime _time;
  bool _sent;
  bool _seen;
  bool _delivered;

  Message.old(this._message,this._senderID,this._receiverID,this._time,this._sent,this._seen,this._delivered);
  Message.brandNew(this._messageID,this._message,this._senderID,this._receiverID,this._time,this._sent,this._seen,this._delivered);

  Map<String,dynamic> messageToMap (){
    return {
      'MessageID' : this._messageID,
      'Message' : this._message,
      //TODO 'DateTime' : Timestamp.fromDate(this._dateTime),
      'SenderID' : this._senderID,
      'ReceiverID' : this._receiverID,
      'Delivered' : this._delivered,
      'Seen' : this._seen,
      'Sent': this._sent,
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

}