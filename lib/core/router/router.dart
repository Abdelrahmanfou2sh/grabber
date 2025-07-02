import 'package:go_router/go_router.dart';
import 'package:grabber/features/categories/screens/all_categories_screen.dart';
import 'package:grabber/features/checkout/checkout_screen.dart';
import 'package:grabber/features/product/widgets/screens/cart_screen.dart';
import 'package:grabber/features/product/widgets/screens/home_screen.dart';
import 'package:grabber/features/product/widgets/screens/product_details_screen.dart';
import 'package:grabber/features/search/screens/search_screen.dart';
import 'package:grabber/features/profile/screens/profile_screen.dart';
import '../../features/product/model/product_model.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const AllCategoriesScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailsScreen(product: product);
      },
    ),
  ],
);
