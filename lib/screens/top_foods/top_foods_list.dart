import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senzu_app/shared/constants.dart';


class TopFoodsList extends StatefulWidget {
  TopFoodsList({Key? key}) : super(key: key);

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
        child: StreamBuilder(
          stream: dbUsersCollection
          .doc(myUID(context))
          .collection('foodShelf')
          .orderBy('timesAdded', descending: true)
          .snapshots(),
          builder: buildUserList,
        ),
    );
  }


Widget buildUserList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (BuildContext context, int index) {

    DocumentSnapshot user = snapshot.data!.docs[index];
    var foodName = user.get('foodName');
    var brandName = user.get('brandName');

    return Padding(
      padding: const EdgeInsets.fromLTRB(12,6,12,0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white70
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
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