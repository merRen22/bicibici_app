import 'package:bicibici/src/UI/tabs/mainTab/mapScreen.dart';
import 'package:bicibici/src/UI/tabs/myProfileTab/myProfileScreen.dart';
import 'package:bicibici/src/UI/tabs/myTripsTab/myTripsScreen.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> _children = [
    MapScreen(),
    MyTripsScreen(),
    MyProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext maincontext) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: _children[_currentIndex],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                primaryColor: Colors.purple,
              ),
              child: 
            BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              elevation: 100,
              unselectedItemColor: Colors.orangeAccent[200],
              selectedItemColor: Colors.orange[700],
              type: BottomNavigationBarType.shifting,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.directions_bike,color: Colors.purple,
                    ),
                    title: Text("Home",style: TextStyles.extraSmallPurpleFatText())),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.list,color: Colors.purple,
                    ),
                    title: Text("Mis viajes",style: TextStyles.extraSmallPurpleFatText())),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,color: Colors.purple,
                    ),
                    title: Text("Mi perfil", style: TextStyles.extraSmallPurpleFatText(),)),
              ],
            ),
            )));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
