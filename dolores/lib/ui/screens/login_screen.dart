import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/dolores_checkbox.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EXPIRY',
                  style: TextStyle(
                    height: 1,
                    fontSize: 48,
                    fontFamily: 'Redressed',
                    color: Color.fromRGBO(203, 178, 106, 1),
                  ),
                ),
                Text(
                  'Never leave wand',
                  style: TextStyle(
                    height: 2,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                ),
                TextFormField(
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54, width: 1.0),
                    ),
                    hintText: 'Email',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: new InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        print("Hide");
                      },
                      icon: Icon(Icons.visibility),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black54, width: 1.0),
                    ),
                    hintText: 'Password',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: DoloresCheckbox(
                    value: false,
                    title: 'Kom ihåg mig',
                  ),
                ),
                DoloresButton(
                    text: "Login",
                    onPressed: () {
                      print("klickat");
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
