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
  late Animation<Offset> _offsetAnimationButton;



  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
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
  }






  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MapBloc, MapState>(
        listenWhen: (previous, current) =>
        current is SuccessSendState || current is MapErrorState,
        listener: (context, state) {
          if (state is SuccessSendState) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text(state.message.message),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
          if (state is MapErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.toString()),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },

        // 👇 BlocBuilder faqat karta uchun
        child: BlocBuilder<MapBloc, MapState>(
          buildWhen: (previous, current) => current is MapLoadedState || current is MapLoadingState,
          builder: (context, state) {
            if (state is MapLoadedState && state.mapObject.isNotEmpty){
              _controller.forward(); // animatsiyani boshlash
            }

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                YandexMap(
                  onMapCreated: (YandexMapController controller) async {
                    if (state is MapLoadedState) {
                      state.mapController.complete(controller);
                    }
                  },
                  mapObjects: state is MapLoadedState ? state.mapObject : const [],
                ),

                // Navigatsiya va tugmalar doimiy ko‘rinadi
                const NavigationButton(),


                  Positioned(
                    right: 20,
                    bottom: 200,
                    child: SlideTransition(
                      position: _offsetAnimationButton,
                      child: CustomButton(
                        height: 50,
                        width: 50,
                        color: Colors.white,
                        onPressed: () {
                          context.read<MapBloc>().add(DeleteMarkerEvent());
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ),
                  ),

                Positioned(
                  right: 20,
                  top: 60,
                  child: CustomButton(
                    height: 50,
                    width: 50,
                    color: (state is MapLoadedState && state.check == true)
                        ? Colors.green
                        : Colors.white,
                    onPressed: () {
                      context.read<MapBloc>().add(ConnectionWifiCheckEvent());
                    },
                    child: Icon(Icons.wifi,
                        size: 30,
                        color: (state is MapLoadedState && state.check == true)
                            ? Colors.white
                            : Colors.red),
                  ),
                ),

                const Center(
                  child: Icon(Icons.location_on, size: 35, color: Colors.red),
                ),

                if (state is MapLoadingState)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }

}
