import 'package:flutter/material.dart';
import 'package:login/theme/providertheme.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  bool value = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(leading: GestureDetector(child: Icon(Icons.arrow_back),onTap: () {
         Navigator.pushReplacementNamed(context, '/settingspage');
       },),
        title: const Text("Theme"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body:
       Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Switch to Dark/Light modes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: value,
                  onChanged: (newValue) {
                    setState(() {
                      value = newValue;
                      Provider.of<Themeprovider>(
                        context,
                        listen: false,
                      ).toggeletheme();
                    });
                  },
                ),
              ],
            ),
          ),
        ]
    ));
  }
}