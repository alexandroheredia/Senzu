import 'package:flutter/material.dart';
import 'package:senzu_app/shared/constants.dart';


class VitaminA extends StatelessWidget {
  const VitaminA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vitamin A',
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
                              '(in micrograms)',
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
                            'Chicken Liver',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '3,296 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '366.22%',
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
                            'Carrots',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '835 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '92.78%',
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
                            'Sweet Potatoes',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '764 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '84.89%',
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
                            'Butter',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '684 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '76.00%',
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
                            'Pumpkin',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '426 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '47.33%',
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
                            'Lettuce',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '198 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '22.00%',
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
                            'Sweet Red Pepper',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '157 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '17.44%',
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
                            'Hard-Boiled Eggs',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '149 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '16.56%',
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
                            'Passion Fruit',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '64 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '7.11%',
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
                            'Mangoes',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '54 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '6.00%',
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
                            'Papayas',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '47 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '5.22%',
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
                            'Tangerines',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '34 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '3.78%',
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
                            'Watermelon',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '28 µg',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '3.11%',
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