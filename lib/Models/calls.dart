class CallsModel {
  final String name;
  final String time;
  final String callType;
  final String profilePic;

  CallsModel({
    required this.name,
    required this.time,
    required this.callType,
    required this.profilePic,
  });

  factory CallsModel.fromJson(Map<String, dynamic> data) => CallsModel(
      name: data['name'],
      time: data['time'],
      callType: data['callType'],
      profilePic: data['profilePic'],
    );
  
}
