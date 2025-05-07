import 'package:get_it/get_it.dart';
import 'package:map/features/map/domain/usecase/map_use_case.dart';
import 'package:map/features/map/presentation/bloc/map_bloc.dart';

import 'features/map/data/repository/map_repository_impl.dart';
import 'features/map/domain/repository/map_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  initDataSource();
  initRepositories();
  initUseCases();
  initBlocs();
}

void initDataSource() {
  // Agar kerak bo‘lsa, ma'lumot manbalarini ro‘yxatdan o‘tkazing
}

void initRepositories() {
  getIt.registerLazySingleton<MapRepository>(
        () => MapRepositoryImpl(),
  );
}

void initUseCases() {
  getIt.registerLazySingleton(
        () => MapUseCase(getIt<
            MapRepository>()),
  );
}

void initBlocs() {
  getIt.registerFactory(() => MapBloc(mapUseCase: getIt<MapUseCase>()));

  // getIt.registerFactory(
  //         () => TicketBloc(ticketIdListUseCase: getIt<TicketIdListUseCase>()));
}
