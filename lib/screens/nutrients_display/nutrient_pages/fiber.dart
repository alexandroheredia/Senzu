import 'package:flutter/material.dart';
import 'package:senzu_app/shared/constants.dart';


class Fiber extends StatelessWidget {
  const Fiber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fiber',
          style: titleTextStyle
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
                            'Chia Seeds',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '34 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '90.53%',
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
                            'Popcorn',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '14 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '37.89%',
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
                              '13 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '35.00%',
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
                            'Dark chocolate',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '11 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '28.68%',
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
                            '26.58%',
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
                            'Textured Soy',
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
                            '24.74%',
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
                            'Lentils',
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
                            '19.21%',
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
                            '18.42%',
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
                            'Kidney Beans',
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
                            '17.89%',
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
                            'Avocado',
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
                            '17.63%',
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
                            'Raspberries',
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
                            '17.11%',
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
                            'Green Peas',
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
                            '15.00%',
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
                            'Artichoke',
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
                            '14.21%',
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
                            'Brussels Sprouts',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '4 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '10.00%',
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
                            'Pears',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '3 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '8.16%',
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
                            'Quinoa',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '3 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '7.37%',
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
                            'Carrots',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '3 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '7.37%',
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
                            'Beets',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '3 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '7.37%',
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
                            'Bananas',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '3 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '6.84%',
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
                            'Broccoli',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '3 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '6.84%',
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
                            'Sweet Potatoes',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '3 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '6.58%',
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
                            'Apples',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '2 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '6.32%',
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
                            'Strawberries',
                            style: TextStyle(
                              fontSize: 20.0,
                              )
                            )
                          ),
                        DataCell(
                          Center(
                            child: Text(
                              '2 g',
                              style: TextStyle(
                                fontSize: 20.0,
                                )
                              ),
                            )
                          ),
                        DataCell(
                          Text(
                            '5.26%',
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