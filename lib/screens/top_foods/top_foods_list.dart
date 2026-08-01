import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/services/shelf_repository.dart';
import 'package:senzu_app/shared/theme.dart';
import 'package:senzu_app/shared/auth_scope.dart';


class TopFoodsList extends StatefulWidget {
  const TopFoodsList({super.key});

  @override
  _TopFoodsListState createState() => _TopFoodsListState();
}

class _TopFoodsListState extends State<TopFoodsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: _topFoodsBody(),
    );
  }


  Widget _topFoodsBody() {
    return Column(
      children: <Widget>[
        _foodList(),

      ],
    );

  }

  Widget _foodList(){
    return Expanded(
        child: StreamBuilder<List<ShelfFood>>(
          stream: context.read<ShelfRepository>()
              .topFoodsStream(myUID(context)),
          builder: buildUserList,
        ),
    );
  }


Widget buildUserList(
  BuildContext context,
  AsyncSnapshot<List<ShelfFood>> snapshot,
) {
  if (snapshot.hasData) {
    final foods = snapshot.data!;
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: foods.length,
        itemBuilder: (BuildContext context, int index) {

    final food = foods[index];
    var foodName = food.foodName;
    var brandName = food.brandName;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12,6,12,0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white70
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          )
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(foodName,
                style: textColor.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(brandName,
              style: textColor.copyWith(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  } 
        
      );
    } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
      // Handle no data
      return Center(
        child: Text("No foods found."),
      );
    } else {
      // Still loading
      return loadingWidget;
    }
  }


}