import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/navigation.dart';
import 'core/routes/routes.dart';
import 'features/map/domain/usecase/map_use_case.dart';
import 'features/map/presentation/bloc/map_bloc.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => MapBloc(mapUseCase: getIt<MapUseCase>()))],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppPages.generateRouteSettings,
    );
  }
}
