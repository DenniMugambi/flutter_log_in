import 'package:flutter/material.dart';

class HomeP extends StatefulWidget {
  final userInfom;
  const HomeP({super.key, this.userInfom});

  @override
  State<HomeP> createState() => _HomePState();
}

class _HomePState extends State<HomeP> {
    int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text('YohPal',style: TextStyle(fontWeight:FontWeight.bold ),),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 30,),
            onPressed: () {
              // Add action here
            },
          ),
          IconButton(
            icon: Icon(Icons.search,size: 30,),
            onPressed: () {
              // Add your action here
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.person,  size: 25),
                        onPressed: () {
                          // Add 
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // SliverAppBar(
          //   floating: true,
          //   flexibleSpace: Placeholder(), // Replace with your scrollable content
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
              childCount: 50,
            ),
          ),
        ],
      ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
            unselectedLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_back),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("(", style: TextStyle(fontSize: 23,fontWeight: FontWeight.w700, color: Color.fromARGB(255, 136, 209, 67) )),
              Icon(Icons.add),
              Text(")", style: TextStyle(fontSize: 23,fontWeight: FontWeight.w700,color: Color.fromARGB(255, 136, 209, 67)),),
              ],),
            label: '',
          ),
       
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Inbox',
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
    
  }
}