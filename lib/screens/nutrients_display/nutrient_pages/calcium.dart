import 'package:flutter/material.dart';
import 'package:senzu_app/shared/constants.dart';


class Calcium extends StatelessWidget {
  const Calcium({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calcium',
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
                            'Grated Parmesan',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '1,184 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '118.40%',
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
                            'Sesame Seeds',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '975 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '97.50%',
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
                            'Almonds',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '268 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '26.80%',
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
                            'Chia Seeds',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '255 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '25.50%',
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
                            'Yogurt',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '199 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '19.90%',
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
                            'Almond Milk',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '184 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '18.40%',
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
                            'Spinach',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '136 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '13.60%',
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
                            'Soy Milk',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '123 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '12.30%',
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
                            'Whole Milk',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '115 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '11.50%',
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
                              '10',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Red Kidney Beans',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '83 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '8.30%',
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
                              '11',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Oats',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '52 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '5.20%',
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
                              '12',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Broccoli',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '46 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '4.60%',
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
                              '13',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Squash',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '44 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '4.40%',
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
                              '14',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Oranges',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '43 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '4.30%',
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
                              '15',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Quinoa',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '17 mg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '1.70%',
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