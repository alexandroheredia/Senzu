import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/services/auth_service.dart';
import 'package:senzu_app/screens/profile/goals.dart';
import 'package:senzu_app/shared/theme.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 20.0,
      child: Column(
        children: <Widget>[
          Row(
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
                SizedBox(height: 150),
                ListTile(
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  leading: MaterialButton(
                    color: Color(0xFF503859),
                    minWidth: 40.0,
                    onPressed: () async {},
                    elevation: 2.0,
                    padding: EdgeInsets.all(8.0),
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 3.5, 0),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NutritionGoals()),
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
                  showDialog<String>(
                    barrierColor: Colors.black54,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: primaryBackgroundColor,
                      title: Text('Do you want to sign out?', style: textColor),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.redAccent[400], // background
                            foregroundColor: Colors.white, // foreground
                          ),
                          child: Text('Sign out'),
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
                          child: Text(
                            'Go back',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                elevation: 2.0,
                padding: EdgeInsets.all(5.0),
                shape: CircleBorder(),
                // fillColor: Colors.red,
                child: Icon(
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
