import 'package:flutter/material.dart';
import 'package:flutter_application_crypto/ui/market_view_page.dart';
import 'package:flutter_application_crypto/ui/profile_page.dart';
import 'package:flutter_application_crypto/ui/ui_helper/bottom_nav.dart';

import 'home_page.dart';
class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.compare_arrows_outlined)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNav(pageController: _pageController),
      body: PageView(
        controller:_pageController,
        children:const[
          HomePage(),
          MarketViewPage(),
          ProfilePage()
        ],
      ),
    );
  }
}
