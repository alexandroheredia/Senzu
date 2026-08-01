import 'package:flutter/material.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/services/user_repository.dart';
import 'package:senzu_app/shared/constants.dart';
import 'package:senzu_app/shared/widgets/custom_form_field.dart';
import 'package:senzu_app/shared/widgets/custom_progress_indicator.dart';


class InitialProfileSetup extends StatefulWidget {

  @override
  _InitialProfileSetupState createState() => _InitialProfileSetupState();
}

class _InitialProfileSetupState extends State<InitialProfileSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  Icon(Icons.person),
                  SizedBox(height: 10,),
                  Text('Profile Setup'),
                  SizedBox(height: 20,),
                  Container(
                    constraints: BoxConstraints(maxWidth: 270),
                    child: Text('With this info, we are going to tweak the numbers to give you the best recommendations',
                    textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50,),
              InitialProfileSetupForm(),
            ],
          ),
        ),
      ),
    );
  }
}



class InitialProfileSetupForm extends StatefulWidget {

  @override
  _InitialProfileSetupFormState createState() => _InitialProfileSetupFormState();
}

class _InitialProfileSetupFormState extends State<InitialProfileSetupForm> {
  
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  
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

          AppUser userData = snapshot.data!;
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
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                              child: Text(
                                'Male',
                                ),
                              value: 'male',
                            ),
                            DropdownMenuItem(
                              child: Text(
                                'Female',
                                ),
                              value: 'female',
                            ),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none
                            ),
                          onChanged: (String? sex){
                            setState(() {
                              _sex = sex;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: SizedBox(width: 20,),
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
                SizedBox(height: 15,),
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
                    Expanded(
                      flex: 6,
                      child: SizedBox(height: 20,)
                    ),
                    Expanded(
                      flex: 47,
                      child: CustomFormField(
                        label: 'Activity Level',
                        child: DropdownButtonFormField<String>(
                          initialValue: _activityLevel ?? userData.activityLevel,
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                              child: Text(
                                'Sedentary',
                                ),
                              value: 'sedentary',
                            ),
                            DropdownMenuItem(
                              child: Text(
                                'Slightly Active',
                                ),
                              value: 'slightly_active',
                            ),
                                                  DropdownMenuItem(
                              child: Text(
                                'Active',
                                ),
                              value: 'active',
                            ),
                            DropdownMenuItem(
                              child: Text(
                                'Very Active',
                                ),
                              value: 'very_active',
                            ),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none
                            ),
                          onChanged: (String? activityLevel){
                            setState(() {
                              _activityLevel = activityLevel;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(width: 0,),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // background
                        foregroundColor: Colors.white, // foreground
                      ),
                      child: _loading ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CustomProgressIndicator()
                      ) : Text(
                        'Update',
                      ),
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            await UserRepository(uid: myUID(context)).updateUserData(
                              _sex ?? userData.sex, 
                              // _birthday ?? snapshot.data.birthday, 
                              _activityLevel ?? userData.activityLevel,
                              _dailyCaloriesGoal ?? userData.dailyCaloriesGoal,
                            );
                            Navigator.pop(context);
                          }
                        }
                    ),
                  ],
                )
              ],
            )
          );
        } else {
          return loadingWidget;
        }



        
      }
    );
  }
}

