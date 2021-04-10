import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/ui/screens/account_screen.dart';
import 'package:dolores/ui/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const _DrawerHeader(),
          _DrawerListItem(
            icon: Icons.home,
            title: 'Home',
            nav: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsScreen(),
                ),
              );
            },
          ),
          _DrawerListItem(
            icon: Icons.filter_list,
            title: 'Filters',
            nav: () => {},
          ),
          _DrawerListItem(
            icon: Icons.account_circle_sharp,
            title: 'Account',
            nav: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
          ),
          _DrawerListItem(
            icon: Icons.logout,
            title: 'Logout',
            nav: () async {
              await auth.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final title = 'Expiry';

  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     fit: BoxFit.fill,
      //     image: backgroundImage,
      //   ),
      // ),
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function nav;

  const _DrawerListItem({this.icon, this.title, this.nav});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(icon),
              const SizedBox(
                width: 10,
              ),
              Text(title),
            ],
          ),
          onTap: nav,
        ),
        Divider(),
      ],
    );
  }
}
