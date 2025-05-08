import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'custom_button.dart' show CustomButton;

class PointItmList extends StatelessWidget {
  final List<Point> polylinePoints;
  const PointItmList({super.key,required this.polylinePoints});

  @override
  Widget build(BuildContext context) {
    return
    Positioned(
        left: 20,
        top: 60,
        child: SizedBox(
          height: 600, // Yoki boshqa mos bo'lgan balandlik
          width: 300,
          child: ListView.builder(
            itemCount: polylinePoints.length,
            shrinkWrap: true, // ✅ muhim!
            itemBuilder: (context, index) {
              Point point = polylinePoints[index];
              print("===============================${point.toString()}");
              return CustomButton(
                margin: EdgeInsets.only(top: 6),
                height: 50,
                padding: EdgeInsets.all(5),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Long:${point.longitude.toString()}"),
                        Text("Lat:${point.latitude.toString()} "),],
                    ),
                    Row(children: [Text("ID:${index + 1}"),
                      Icon(Icons.delete_outline),],)
                  ],
                ),
              );
            },
          ),
        ));
  }
}
