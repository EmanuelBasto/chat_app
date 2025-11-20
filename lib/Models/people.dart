class PeopleModel {
  final String first_name;
  final String last_name;
  final String msg;
  final String date;
  final int count;
  final bool story;
  final String image;
  final String avatar;
  final String status;
  final List<String> stories;

  PeopleModel({
    required this.first_name,
    required this.last_name,
    required this.msg,
    required this.date,
    required this.count,
    required this.story,
    required this.image,
    required this.avatar,
    required this.status,
    required this.stories,
  });

  factory PeopleModel.fromJson(Map<String, dynamic> data) => PeopleModel(
        first_name: data['first_name'],
        last_name: data['last_name'],
        msg: data['msg'],
        date: data['date'],
        count: data['count'],
        story: data['story'],
        image: data['image'],
        avatar: data['avatar'],
        status: data['status'],
        stories: List.from(data['stories']),
      );
}