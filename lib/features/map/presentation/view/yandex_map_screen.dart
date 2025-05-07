import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.wifi];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });

    print('Connectivity changed: $_connectionStatus');

    if (result.contains(ConnectivityResult.wifi)) {
      _showNoConnectionDialog();
    }
  }
  void _showNoConnectionDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Internet yo‘q'),
        content: const Text('Internet ulanmagan. Davom etish uchun Wi-Fi yoki mobil internetga ulaning.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
    _connectivitySubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
