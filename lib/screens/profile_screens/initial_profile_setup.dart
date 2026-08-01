import 'package:flutter/material.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/services/user_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/theme.dart';
import 'package:senzu_app/shared/widgets/custom_form_field.dart';
import 'package:senzu_app/shared/widgets/custom_progress_indicator.dart';

class InitialProfileSetup extends StatefulWidget {
  const InitialProfileSetup({super.key});

  @override
  State<InitialProfileSetup> createState() => _InitialProfileSetupState();
}

class _InitialProfileSetupState extends State<InitialProfileSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Profile Setup'),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 270),
                    child: const Text(
                      'With this info, we are going to tweak the numbers to give you the best recommendations',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const InitialProfileSetupForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class InitialProfileSetupForm extends StatefulWidget {
  const InitialProfileSetupForm({super.key});

  @override
  State<InitialProfileSetupForm> createState() =>
      _InitialProfileSetupFormState();
}

class _InitialProfileSetupFormState extends State<InitialProfileSetupForm> {
  final bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Profile data
  String? _sex;
  // DateTime _birthday = DateTime(1969,4,20);
  // double _weight;
  String? _activityLevel;
  int? _dailyCaloriesGoal;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser>(
      stream: UserRepository(uid: myUID(context)).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!;
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 47,
                      child: CustomFormField(
                        label: 'Sex',
                        child: DropdownButtonFormField<String>(
                          initialValue: _sex ?? userData.sex,
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                              value: 'male',
                              child: Text(
                                'Male',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text(
                                'Female',
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (sex) {
                            setState(() {
                              _sex = sex;
                            });
                          },
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 6,
                      child: SizedBox(
                        width: 20,
                      ),
                    ),
                    // Expanded(
                    //   flex: 47,
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       DateTime date = await showDatePicker(
                    //         context: context,
                    //         initialDate: userData.birthday,
                    //         firstDate: DateTime(1903,1,2),
                    //         lastDate: DateTime(DateTime.now().year-12,12,31),
                    //         );
                    //         if (date!=null){
                    //           setState(() {
                    //             _birthday = date;
                    //           });
                    //         // setWater();
                    //         }
                    //     },
                    //     child: CustomFormField(
                    //       label: 'Birthday',
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             DateFormat.yMMMd().format(_birthday),
                    //           ),
                    //           Icon(Icons.arrow_drop_down)
                    //         ],
                    //       ),
                    //     ),
                    //   )
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    // Expanded(
                    //   flex: 47,
                    //   child: CustomFormField(
                    //     label: 'Weight',
                    //     child: TextFormField(
                    //       decoration: InputDecoration(
                    //         border: InputBorder.none,
                    //         hintText: '60 kg',
                    //         suffixText: 'kg',
                    //       ),
                    //       keyboardType: TextInputType.number,
                    //       textInputAction: TextInputAction.done,
                    //       validator: (String value){
                    //         if(value.isEmpty){
                    //           return 'Please Enter Weight';
                    //         }
                    //         if(double.parse(value)<40){
                    //           return 'You are underweight';
                    //         }
                    //         return null;
                    //       },
                    //       onChanged: (String value){
                    //         setState(() => _weight = value as double);
                    //       },
                    //       //validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                    //       // onChanged: (val) => setState(() => _currentName = val),
                    //     ),
                    //   ),
                    // ),
                    const Expanded(
                      flex: 6,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    Expanded(
                      flex: 47,
                      child: CustomFormField(
                        label: 'Activity Level',
                        child: DropdownButtonFormField<String>(
                          initialValue:
                              _activityLevel ?? userData.activityLevel,
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                              value: 'sedentary',
                              child: Text(
                                'Sedentary',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'slightly_active',
                              child: Text(
                                'Slightly Active',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'active',
                              child: Text(
                                'Active',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'very_active',
                              child: Text(
                                'Very Active',
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (activityLevel) {
                            setState(() {
                              _activityLevel = activityLevel;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: SizedBox(
                        width: 0,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // background
                        foregroundColor: Colors.white, // foreground
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CustomProgressIndicator(),
                            )
                          : const Text(
                              'Update',
                            ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final navigator = Navigator.of(context);
                          await UserRepository(
                            uid: myUID(context),
                          ).updateUserData(
                            _sex ?? userData.sex,
                            // _birthday ?? snapshot.data.birthday,
                            _activityLevel ?? userData.activityLevel,
                            _dailyCaloriesGoal ?? userData.dailyCaloriesGoal,
                          );
                          if (!mounted) return;
                          navigator.pop();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return loadingWidget;
        }
      },
    );
  }
}
