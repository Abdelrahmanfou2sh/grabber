import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../../features/search/cubit/search_cubit.dart';
import '../../features/search/repository/search_repository.dart';
import '../../features/product/cubit/cart_cubit.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/categories/repository/category_repository.dart';
import '../../features/categories/cubit/category_cubit.dart';
import '../../features/product/repo/product_repository.dart';
import '../../features/product/cubit/products_cubit.dart';
import '../../features/payment/repositories/payment_repository.dart';
import '../../features/payment/cubit/payment_cubit.dart';
import '../../features/order/repository/order_repository.dart';
import '../../features/order/cubit/order_cubit.dart';
import '../../core/theme/cubit/theme_cubit.dart';

final getIt = GetIt.instance;

bool _isServiceLocatorInitialized = false;

void setupServiceLocator() {
  if (_isServiceLocatorInitialized) return;
  _isServiceLocatorInitialized = true;

  // Repositories
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepository(FirebaseFirestore.instance),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );

  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepository(FirebaseFirestore.instance),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(FirebaseFirestore.instance),
  );

  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepository(firestore: FirebaseFirestore.instance),
  );

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepository(FirebaseFirestore.instance),
  );

  // Cubits
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(getIt<SearchRepository>()),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<CategoryCubit>(
    () => CategoryCubit(getIt<CategoryRepository>()),
  );

  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(getIt<ProductRepository>()),
  );

  getIt.registerLazySingleton<CartCubit>(() => CartCubit());

  getIt.registerFactory<PaymentCubit>(
    () => PaymentCubit(repository: getIt<PaymentRepository>()),
  );

  getIt.registerFactory<OrderCubit>(() => OrderCubit(getIt<OrderRepository>()));

  getIt.registerFactory<ThemeCubit>(() => ThemeCubit());
}
