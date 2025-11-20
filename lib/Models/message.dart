class MessageModel {
  final String image;
  final String msg;
  final bool sender;
  final String type;
  final bool opened;


  MessageModel({
    required this.image,
    required this.msg,
    required this.sender,
    required this.type,
    required this.opened,
  });

  factory MessageModel.fromJson(Map<String, dynamic> data) => MessageModel(
      image: data['image'],
      msg: data['msg'],
      sender: data['sender'],
      type: data['type'],
      opened: (data['opened']),
    );
}