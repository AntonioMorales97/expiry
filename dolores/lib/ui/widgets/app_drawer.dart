import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/ui/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  void _changeScreenTo(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

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
            nav: () => {},
          ),
          _DrawerListItemExpand(
            icon: Icons.filter_list,
            title: 'Filters',
            nav: () => {},
          ),
          _DrawerListItem(
            icon: Icons.account_circle_sharp,
            title: 'Account',
            nav: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              ),
            },
          ),
          _DrawerListItem(
            icon: Icons.logout,
            title: 'Logout',
            nav: () => {auth.logout()},
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

class _DrawerListItemExpand extends StatefulWidget {
  final IconData icon;
  final String title;
  final Function nav;

  _DrawerListItemExpand({this.icon, this.title, this.nav});

  @override
  __DrawerListItemExpandState createState() => __DrawerListItemExpandState();
}

class __DrawerListItemExpandState extends State<_DrawerListItemExpand> {
  List<Icon> icons = [Icon(Icons.date_range_sharp), Icon(Icons.text_fields)];

  List<bool> isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> _currentIcon = ValueNotifier<int>(0);
    final prod = Provider.of<ProductProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Row(
            children: <Widget>[
              Icon(widget.icon),
              const SizedBox(
                width: 10,
              ),
              Text(widget.title + ": "),
              const SizedBox(
                width: 10,
              ),
              ValueListenableBuilder(
                valueListenable: _currentIcon,
                builder: (BuildContext context, int value, Widget child) {
                  print(value);
                  return icons[value];
                },
              ),
            ],
          ),
          children: [
            ToggleButtons(
              children: <Widget>[
                Icon(Icons.date_range_sharp),
                Icon(Icons.text_fields),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    _currentIcon.value = index;

                    prod.setSorting(index);
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelected,
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
