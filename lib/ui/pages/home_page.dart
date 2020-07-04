import 'package:flutter/material.dart';
import 'package:lubiju/ui/tabs/categories_tab.dart';
import 'package:lubiju/ui/tabs/home_tab.dart';
import 'package:lubiju/ui/tabs/orders_tab.dart';
import 'package:lubiju/ui/tabs/settings_tab.dart';
import 'package:lubiju/ui/widgets/cart_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 0;

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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Color.fromARGB(255, 114, 23, 37),
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: BottomNavigationBar(
                currentIndex: _page,
                onTap: (p) {
                  _pageController.animateToPage(p,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.style),
                      title: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text("Novidades"),
                      )),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.category),
                      title: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text("Categorias"),
                      )),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.folder),
                      title: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text("Pedidos"),
                      )),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      title: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "Perfil",
                        ),
                      ))
                ]),
          ),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (p) {
            setState(() {
              _page = p;
            });
          },
          children: <Widget>[
            HomeTab('Novidades - Lú Biju'),
            CategoriesTab(),
            OrdersTab(),
            SettingsTab()
          ],
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return CartButton();
      case 1:
        return CartButton();
      case 2:
      case 3:
        return Container();
      default:
        return Container();
    }
  }
}
