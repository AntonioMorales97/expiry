import 'package:dolores/locator.dart';
import 'package:dolores/services/auth_service.dart';
import 'package:dolores/ui/screens/account/account_view.dart';
import 'package:dolores/ui/screens/products/products_view.dart';
import 'package:dolores/ui/widgets/filter/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDrawer extends StatelessWidget {
  final active;
  final onFilterUpdate;

  AppDrawer({this.active, this.onFilterUpdate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const _DrawerHeader(),
          _DrawerLinkItem(
            active: active == '/',
            icon: Icons.home,
            title: 'Hem',
            nav: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsView(),
                ),
              );
            },
          ),
          Filter(
            icon: Icons.filter_list,
            title: 'Filter',
            onUpdate: onFilterUpdate,
            nav: () => {},
          ),
          _DrawerLinkItem(
            active: active == 'accounts',
            icon: Icons.account_circle_sharp,
            title: 'Konto',
            nav: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccountView()),
              );
            },
          ),
          _DrawerLinkItem(
            icon: Icons.logout,
            title: 'Logga ut',
            nav: () async {
              await locator<AuthService>().logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (Route<dynamic> route) => false);
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

class _DrawerLinkItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function nav;
  final bool active;

  const _DrawerLinkItem({this.icon, this.title, this.nav, this.active = false});

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
