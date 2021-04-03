import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: DoloresButton(
          onPressed: auth.logout,
          text: 'Logout',
        ),
      ),
    );
  }
}
