import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget{
  const MyListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Row(
        children: [CircleAvatar(radius: 30,backgroundImage: NetworkImage('https://media.licdn.com/dms/image/v2/D5603AQGz-vbeABBbPw/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1704750176467?e=2147483647&v=beta&t=65wTLFeVIJ7PGH9fwuRaEaOzweUm9uZtE5BeLL73RTI'),
        ),
        Column(children: [Text('name'),Text('Preview')],
        )
        ]),
        Row(
          children: [],
          )
          ],
    );
  }
}