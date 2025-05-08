import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 🔧 MUHIM!
import 'package:map/features/map/presentation/bloc/map_bloc.dart';
import 'package:map/features/map/presentation/widget/custom_button.dart';
import 'package:map/features/map/presentation/widget/navigation_button.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapScreen extends StatefulWidget {
  const YandexMapScreen({super.key});

  @override
  State<YandexMapScreen> createState() => _YandexMapScreenState();
}

class _YandexMapScreenState extends State<YandexMapScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _navController;
  late Animation<Offset> _offsetAnimationButton;

  void checkConnectionToMyPC() async {
    const ip = "192.168.137.1"; // kompyuteringizning IP manzili
    final isReachable = await pingMyComputer(
      ip,
      port: 8000,
    ); // port mos bo'lishi kerak
    if (isReachable) {
      print("Kompyuterga ulanish mavjud");
    } else {
      print("Kompyuterga ulanish yo'q");
    }
  }

  Future<bool> pingMyComputer(
    String ipAddress, {
    int port = 80,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    try {
      final socket = await Socket.connect(ipAddress, port, timeout: timeout);
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    checkConnectionToMyPC();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _offsetAnimationButton = Tween<Offset>(
      begin: const Offset(1.5, 0), // o‘ngdan chiqadi
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapBloc>().add(InitPermissionAndFetchEvent());
    });
    _navController.forward(); // animatsiyani boshlash
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("=======================================================================================================");
    print("Build UI");
    print("=======================================================================================================");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoadedState) {
            if (state.mapObject.isNotEmpty) {
              _controller.forward(); // animatsiyani boshlash
            }
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                YandexMap(
                  onMapCreated: (YandexMapController controller) async {
                    state.mapController.complete(controller);
                  },
                  mapObjects: state.mapObject,
                ),
                NavigationButton(),
   


                Positioned(
                  right: 20,
                  bottom: 200,
                  child: SlideTransition(
                    position: _offsetAnimationButton,
                    child: CustomButton(
                      height: 50,
                      width: 50,
                      onPressed: () {
                        context.read<MapBloc>().add(DeleteMarkerEvent());
                        _controller.reverse();
                      },
                      child: Icon(Icons.delete),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 60,
                  child: SlideTransition(
                    position: _offsetAnimationButton,
                    child: CustomButton(
                      height: 50,
                      width: 50,
                      onPressed: () {
                        context.read<MapBloc>().add(DeleteMarkerEvent());
                        _controller.reverse();
                      },
                      child: Icon(Icons.wifi, size: 30),
                    ),
                  ),
                ),
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
            return Center(child: Text(state.failure.toString()));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
