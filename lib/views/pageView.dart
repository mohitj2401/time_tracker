import 'package:flutter/material.dart';

class PageViewSc extends StatefulWidget {
  const PageViewSc({super.key});

  @override
  State<PageViewSc> createState() => _PageViewScState();
}

class _PageViewScState extends State<PageViewSc> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nav Bar")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          children: <Widget>[
            Container(
              color: Colors.blueGrey,
            ),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            backgroundColor: Colors.lightBlue,
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //
      //
      //using this page controller you can make beautiful animation effects
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }
}
