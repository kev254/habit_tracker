// drawer start
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/components/app_global_widgets.dart';
import 'package:provider/provider.dart';

import '../database/shared_preference.dart';
import '../theme/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "HabitTacker",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Habit Tracker for Solutech",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            SizedBox(
              width: 175,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              width: 175,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const About(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
                child: Text(
                  "About",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              width: 175,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Info(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
                child: Text(
                  "How to use",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              width: 175,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  UserPreferences.clearUser();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 100)),
            const Text(
              "copyright ©️ 2025",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Settings"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Dark/Light Mode",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                })
          ],
        ),
      ),
    );
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("About"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: const Text(
          "Version : 1.1.0\n\nContact us : info@okombakevin.co.ke\n\nDeveloper : Kevin OKomba",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("How to use"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: TitleText(text: "Coming soon\n Keep checking"),
        ),
    );
  }
}
// drawer end