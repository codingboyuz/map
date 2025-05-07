# map

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:map/features/map/presentation/bloc/map_bloc.dart';
import 'package:map/features/map/presentation/widget/navigation_button.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 🔧 MUHIM!

class YandexMapScreen extends StatefulWidget {
const YandexMapScreen({super.key});

@override
State<YandexMapScreen> createState() => _YandexMapScreenState();
}

class _YandexMapScreenState extends State<YandexMapScreen> {
final Completer<YandexMapController> _mapController =
Completer<YandexMapController>();


@override
void initState() {
super.initState();
WidgetsBinding.instance.addPostFrameCallback((_) {
context.read<MapBloc>().add(InitPermissionAndFetchEvent());
});
}

@override
Widget build(BuildContext context) {
print("object");
return Scaffold(
body: BlocBuilder<MapBloc, MapState>(

        builder: (context, state) {
          if (state is MapLoadedState) {
            print("MapLoadedState========================================");
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                YandexMap(
                  onMapCreated: (YandexMapController controller) async {
                    _mapController.complete(controller);
                  },

                  mapObjects:state.mapObject,
                ),
                NavigationButton(),

                const Center(
                  child: Icon(Icons.location_on, size: 35, color: Colors.red),
                ),
              ],
            );
          }

          if (state is MapLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is MapErrorState) {
            return Center(child: Text(state.message.toString()));
          }
          return SizedBox.shrink();
        },
      ),
    );
}
}


Yandex MapKit’da ikkita nuqta orasidagi **masofani hisoblash** uchun siz `distanceBetween` funksiyasidan foydalanolmaysiz, chunki u mavjud emas. Buning o‘rniga siz **Haversine formula** yoki Flutterdagi `geolocator` paketini ishlatishingiz mumkin.

Quyida ikkita yechimni ko‘rsataman:

---

### ✅ 1. **`geolocator` paketi yordamida (tavsiya qilinadi)**

#### 🔹 `pubspec.yaml` faylingizga qo‘shing:

```yaml
dependencies:
  geolocator: ^11.0.0
```

#### 🔹 Import:

```dart
import 'package:geolocator/geolocator.dart';
```

#### 🔹 Masofa hisoblash:

```dart
double _calculateDistance(Point p1, Point p2) {
  return Geolocator.distanceBetween(
    p1.latitude, p1.longitude,
    p2.latitude, p2.longitude,
  ); // metrda qaytaradi
}
```

---

### ✅ 2. **Haversine formulasi (kutubxonasiz)**

Agar siz hech qanday paket ishlatmoqchi bo‘lmasangiz:

```dart
import 'dart:math';

double _haversineDistance(Point p1, Point p2) {
  const R = 6371000; // Yer radiusi metrda
  final dLat = _degToRad(p2.latitude - p1.latitude);
  final dLon = _degToRad(p2.longitude - p1.longitude);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(p1.latitude)) *
          cos(_degToRad(p2.latitude)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _degToRad(double degree) => degree * pi / 180;
```

---

### 🧪 Foydalanish:

```dart
final distance = _calculateDistance(point1, point2);
print("Masofa: ${distance.toStringAsFixed(2)} metr");
```

---

Agar siz nuqtalar ro‘yxatidagi **barcha nuqtalarni zanjir bilan hisoblamoqchi** bo‘lsangiz:

```dart
double totalDistance = 0;
for (int i = 0; i < _polylinePoints.length - 1; i++) {
  totalDistance += _calculateDistance(_polylinePoints[i], _polylinePoints[i + 1]);
}
print("Umumiy masofa: ${totalDistance.toStringAsFixed(2)} m");
```

---

Aytingchi, sizga bu masofani UI'da (ekranda) ko‘rsatish kerakmi yoki faqat hisoblash kifoyami?
