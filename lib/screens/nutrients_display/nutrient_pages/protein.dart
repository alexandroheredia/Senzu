import 'package:flutter/material.dart';
import 'package:senzu_app/shared/constants.dart';


class Protein extends StatelessWidget {
  const Protein({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Protein',
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
                              '(in grams)',
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
                            'Textured Soy',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '108 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '174.16%',
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
                            'Grated Parmesan',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '36 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '57.74%',
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
                            'Chicken Breast',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '32 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '51.77%',
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
                            'Pork Chops',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '31 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '50.00%',
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
                            'Tuna',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '30 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '48.23%',
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
                            'Pumpkin Seeds',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '30 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '48.13%',
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
                            'Beef',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '29 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '46.29%',
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
                            'Peanuts',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '25 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '40.32%',
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
                            'Cheddar',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '25 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '40.32%',
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
                            'Almonds',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '21 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '33.87%',
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
                            'Sardines',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '21 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '33.87%',
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
                            'Cod',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '20 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '32.26%',
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
                            'Mozzarella',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '18 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '29.03%',
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
                            'Firm Tofu',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '17 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '27.90%',
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
                            'Chia seeds',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '17 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '27.42%',
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
                              '16',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Eggs',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '13 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '20.32%',
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
                              '17',
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
                              '10 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '16.13%',
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
                              '18',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Lentils',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '9 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '14.52%',
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
                              '19',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Kidney beans',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '8 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '12.90%',
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
                              '20',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Chickpeas',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '7 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '11.29%',
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
                              '21',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Peas',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '6 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '9.68%',
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
                              '22',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            'Low-Fat Yogurt',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '6 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '9.19%',
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
                              '23',
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
                              '5 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '8.06%',
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