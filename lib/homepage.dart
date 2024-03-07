import 'package:flutter/material.dart';

class HomeP extends StatefulWidget {
  final userInfom;
  const HomeP({super.key, this.userInfom});

  @override
  State<HomeP> createState() => _HomePState();
}

class _HomePState extends State<HomeP> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home Page"),
      ),
      body:Center(
        child: Column(
          children: [
            Text(
              'You have successfully logged in',
            ),
            Text(
              'Full Name: ${widget.userInfom.fullname}',
            ),
            Text(
              'Username: ${widget.userInfom.username}',
            ),
          ],
        ),
      ),
    );
  }
}