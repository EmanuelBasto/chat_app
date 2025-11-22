import 'package:flutter/cupertino.dart';

class SearchBar extends StatelessWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const SearchBar({Key? key, this.onChanged, this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: CupertinoSearchTextField(
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}


