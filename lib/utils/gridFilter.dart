
import 'package:flutter/material.dart';

class UserGridView extends StatefulWidget {
  final List<User> users;

  const UserGridView({Key? key, required this.users}) : super(key: key);

  @override
  _UserGridViewState createState() => _UserGridViewState();
}

class _UserGridViewState extends State<UserGridView> {
  late List<User> filteredUsers;

  @override
  void initState() {
    filteredUsers = widget.users;
    super.initState();
  }

  void filterByName(String query) {
    setState(() {
      filteredUsers = widget.users
          .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: filterByName,
            decoration: InputDecoration(
              labelText: 'Search by Name',
              hintText: 'Enter a name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(filteredUsers[index].name),
                  subtitle: Text('Amount: ${filteredUsers[index].amount}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
final List<User> users = [
  User(name: "Sam", amount: 2000),
  User(name: "Kings", amount: 3000),
  User(name: "Ade", amount: 1000),
  User(name: "John", amount: 2500),
  User(name: "Alice", amount: 1500),
  User(name: "Bob", amount: 1800),
  User(name: "Emily", amount: 2200),
  User(name: "Michael", amount: 2800),
  User(name: "Linda", amount: 3200),
];
class User {
  String name;
  int amount;

  User({required this.name, required this.amount});
}
