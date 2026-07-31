import 'package:flutter/material.dart';
import 'package:senzu_app/shared/constants.dart';



class Potassium extends StatelessWidget {
  const Potassium({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Potassium',
          style: titleTextStyle,
          ),
          centerTitle: true,
          backgroundColor: primaryBackgroundColor,
          elevation: 0,
          ),
          body: Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 15.0,
                  dividerThickness: 1.5,

                  columns: [
                    DataColumn(
                      label: Text(
                      'No.',
                      style: TextStyle(
                        fontSize: 20.0,
                        ),
                      )
                    ),

                  DataColumn(
                    label: Text(
                      'Food Name',
                      style: TextStyle(
                        fontSize: 20.0,
                        ),
                      )
                    ),

                  DataColumn(
                    label: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Amount per 100g',
                            style: TextStyle(
                              fontSize: 20.0,
                              ),
                            ),
                            Text(
                              '(in milligrams)',
                              style: TextStyle(
                                fontSize: 20.0,
                                ),
                              ),
                            ],
                          )
                        )
                      ),

                    DataColumn(
                      label: Text(
                        ' %DV',
                        style: TextStyle(
                          fontSize: 20.0,
                          ),
                        )
                      ),
                    ], 

                    rows: [
                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '🥇',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'White Beans',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '561 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '16.50%',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        ]
                      ),

                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '🥈',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Spinach',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '558 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '16.41%',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        ]
                      ),

                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '🥉',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Baked Potatoes',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '535 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '15.74%',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        ]
                      ),

                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '4',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Avocados',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '485 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '14.26%',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        ]
                      ),

                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '5',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Sweet Potato',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '475 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '13.97%',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        ]
                      ),

                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '6',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'White Mushrooms',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '396 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '11.65%',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        ]
                      ),

                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '7',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Bananas',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '358 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '10.53%',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        ]
                      ),

                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '8',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Tomato',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '218 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '6.41%',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        ]
                      ),

                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '9',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Milk',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '150 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '4.41%',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
              ),
            )
          );
        }
      }