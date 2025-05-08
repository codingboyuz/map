import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/features/map/presentation/bloc/map_bloc.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) {
        // TODO: implement listener}
      },
      child: Container(
        width: double.infinity,
        height: 60,
        margin: EdgeInsets.only(bottom: 60, right: 20, left: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: Offset(-4, 4),
              blurRadius: 10,
              color: Colors.grey.shade400,
              spreadRadius: .5,
            ),
            BoxShadow(
              offset: Offset(4, -4),
              blurRadius: 10,
              color: Colors.grey.shade400,
              spreadRadius: .5,
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                context.read<MapBloc>().add(SendLocationEvent());
              },
              icon: Icon(Icons.send,size: 30,),
            ),
            IconButton(
              onPressed: () {
                context.read<MapBloc>().add(FetchCurrentLocationEvent());
              },
              icon: Icon(Icons.gps_fixed,size: 30,),
            ),
            IconButton(
              onPressed: () {
                context.read<MapBloc>().add(OnTabMapEvent());
              },
              icon: Icon(Icons.add,size: 30,),
            ),
          ],
        ),
      ),
    );
  }
}
