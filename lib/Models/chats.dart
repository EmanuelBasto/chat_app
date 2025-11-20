class ChatsModel {
  final String name;
  final String avatar;
  final String msg;
  final String date;
  final String count;
  final bool story;
  final bool opened;
  final String type;

  ChatsModel({
    required this.name,
    required this.avatar,
    required this.msg,
    required this.date,
    required this.count,
    required this.story,
    required this.opened,
    required this.type,
  });

  factory ChatsModel.fromJson(Map<String, dynamic> data) => ChatsModel(
        name: data['name'],
        avatar: data['avatar'],
        msg: data['msg'],
        date: data['date'],
        count: data['count'],
        story: data['story'],
        opened: data['opened'],
        type: data['type'],
      );
}