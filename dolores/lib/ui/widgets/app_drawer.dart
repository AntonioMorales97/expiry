import 'package:dolores/models/preference.dart';
import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/preference_provider.dart';
import 'package:dolores/ui/screens/account_screen.dart';
import 'package:dolores/ui/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final active;

  AppDrawer({this.active});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const _DrawerHeader(),
          _DrawerListItem(
            active: active == 'products',
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
          _DrawerListItemExpand(
            icon: Icons.filter_list,
            title: 'Filters',
            nav: () => {},
          ),
          _DrawerListItem(
            active: active == 'accounts',
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
  final bool active;

  const _DrawerListItem({this.icon, this.title, this.nav, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(
                icon,
                color: active ? Theme.of(context).colorScheme.primary : null,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    color:
                        active ? Theme.of(context).colorScheme.primary : null),
              ),
            ],
          ),
          onTap: nav,
        ),
        Divider(height: 0),
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
  PreferenceProvider pref;

  List<bool> isSelected = [true, false];
  ValueNotifier<int> _currentIcon = ValueNotifier<int>(0);
  bool isExpanded = false;

  @override
  initState() {
    super.initState();
    pref = Provider.of<PreferenceProvider>(context, listen: false);
    getPreference();
  }

  getPreference() async {
    final Preference preference = await pref.getPreference();
    setState(() {
      _currentIcon = ValueNotifier<int>(preference.sorting);
      setHighlight(_currentIcon.value);
    });
  }

  setHighlight(index) {
    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
      setState(() {
        if (buttonIndex == index) {
          isSelected[buttonIndex] = true;
        } else {
          isSelected[buttonIndex] = false;
        }
      });
    }
  }

  getIcon(int index) {
    List<Icon> icons = [
      Icon(
        Icons.date_range_sharp,
        color: isExpanded
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
      Icon(
        Icons.text_fields,
        color: isExpanded
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      )
    ];

    return icons[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              isExpanded = expanded;
            });
          },
          title: Row(
            children: <Widget>[
              Icon(
                widget.icon,
                color:
                    isExpanded ? Theme.of(context).colorScheme.secondary : null,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.title + ": ",
                style: TextStyle(
                  color: isExpanded
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ValueListenableBuilder(
                valueListenable: _currentIcon,
                builder: (BuildContext context, int value, Widget child) {
                  return getIcon(value);
                },
              ),
            ],
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: ToggleButtons(
                    children: <Widget>[
                      Icon(Icons.date_range_sharp),
                      Icon(Icons.text_fields),
                    ],
                    onPressed: (int index) async {
                      setState(() {
                        _currentIcon.value = index;
                      });
                      await pref.updateSorting(index);
                      setHighlight(index);
                    },
                    isSelected: isSelected,
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(height: 0),
      ],
    );
  }
}
