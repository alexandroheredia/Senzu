import 'package:flutter/material.dart';
import 'package:senzu_app/models/food_entry.dart';

/// A tappable card showing one meal (icon, name, logged calories).
class MealCard extends StatelessWidget {
  final MealType mealType;
  final int calories;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.mealType,
    required this.calories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: 180,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: const Color(0xFF1e1f38),
        child: InkWell(
          splashColor: const Color(0xFF2b2c4a),
          borderRadius: BorderRadius.circular(20.0),
          onTap: onTap,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      splashColor: Colors.grey,
                      onTap: onTap,
                      child: const Icon(
                        Icons.add_circle_outline_rounded,
                        size: 35,
                        color: Color(0xFFc5c5c5),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    height: 80,
                    fit: BoxFit.fitHeight,
                    image: AssetImage(mealType.assetPath),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    mealType.label,
                    style: const TextStyle(
                      color: Color(0xFFc5c5c5),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '🔥 $calories kcal',
                    style: const TextStyle(
                      color: Color(0xFFc5c5c5),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
            ],
          ),
        ),
      ),
    );
  }
}
