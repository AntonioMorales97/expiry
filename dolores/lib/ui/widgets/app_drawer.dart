import 'package:dolores/models/preference.dart';
import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/ui/screens/account_screen.dart';
import 'package:dolores/ui/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
            title: 'Hem',
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
            title: 'Filter',
            nav: () => {},
          ),
          _DrawerListItem(
            active: active == 'accounts',
            icon: Icons.account_circle_sharp,
            title: 'Konto',
            nav: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
          ),
          _DrawerListItem(
            icon: Icons.logout,
            title: 'Logga ut',
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
      child: Container(
        child: SvgPicture.asset(
          'assets/svg/expiry.svg',
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      //child: Container(),
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
  ProductProvider prod;

  List<bool> isSelected = [true, false];
  ValueNotifier<int> _currentIcon = ValueNotifier<int>(0);
  bool isExpanded = false;

  bool _isLoading = true;

  @override
  initState() {
    super.initState();
    prod = Provider.of<ProductProvider>(context, listen: false);
    getPreference();
  }

  getPreference() async {
    await Future.delayed(Duration(seconds: 3));
    final Preference preference = await prod.fetchPreference();

    if (!mounted) return;

    setState(() {
      _currentIcon = ValueNotifier<int>(preference.sort.index);
      for (int buttonIndex = 0;
          buttonIndex < isSelected.length;
          buttonIndex++) {
        isSelected[buttonIndex] = buttonIndex == _currentIcon.value;
      }
      _isLoading = false;
    });
  }

  setHighlight(index) {
    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
      setState(() {
        isSelected[buttonIndex] = buttonIndex == index;
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
      ),
    ];

    return icons[index];
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Column(
            children: [
              Divider(
                height: 0,
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Center(child: Container() //CircularProgressIndicator(),
                          ),
                ),
              ),
              Divider(
                height: 0,
              ),
            ],
          )
        : Column(
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
                      color: isExpanded
                          ? Theme.of(context).colorScheme.secondary
                          : null,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                            ProductSort sort = ProductSort.NAME;
                            if (index == 0) {
                              sort = ProductSort.DATE;
                            }

                            await prod.updateSorting(sort);
                            setHighlight(index);
                          },
                          isSelected: isSelected,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: IconButton(
                          icon: Icon(Icons.swap_vert),
                          onPressed: () {
                            prod.reverseProducts();
                          },
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
