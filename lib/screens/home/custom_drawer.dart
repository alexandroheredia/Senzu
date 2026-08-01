import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/screens/profile/goals.dart';
import 'package:senzu_app/services/auth_service.dart';
import 'package:senzu_app/shared/theme.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 20.0,
      child: Column(
        children: <Widget>[
          const Row(
            children: [
              Expanded(
                child: DrawerHeader(
                  decoration: BoxDecoration(color: primaryBackgroundColor),
                  child: Text('', style: textColor),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 150),
                ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  leading: MaterialButton(
                    color: const Color(0xFF503859),
                    minWidth: 40.0,
                    onPressed: () async {},
                    elevation: 2.0,
                    padding: const EdgeInsets.all(8.0),
                    shape: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 3.5, 0),
                      child: FaIcon(
                        FontAwesomeIcons.trophy,
                        color: Color(0XFFfeba8e),
                        size: 30.0,
                      ),
                    ),
                  ),
                  title: Text(
                    'Goals',
                    style: textColor.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    await Navigator.push<Object>(
                      context,
                      MaterialPageRoute<Object>(
                        builder: (context) => const NutritionGoals(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  'Sign out',
                  style: textColor.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              RawMaterialButton(
                onPressed: () async {
                  await showDialog<String>(
                    barrierColor: Colors.black54,
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: primaryBackgroundColor,
                      title: const Text(
                        'Do you want to sign out?',
                        style: textColor,
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.redAccent[400], // background
                            foregroundColor: Colors.white, // foreground
                          ),
                          child: const Text('Sign out'),
                          onPressed: () async {
                            Navigator.pop(context, 'Cancel');
                            await context
                                .read<AuthenticationService>()
                                .signOut();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text(
                            'Go back',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                padding: const EdgeInsets.all(5.0),
                shape: const CircleBorder(),
                // fillColor: Colors.red,
                child: const Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
