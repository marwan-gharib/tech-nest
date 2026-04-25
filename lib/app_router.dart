import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/features/app_shell/presentation/app_shell_entry.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/features/auth/presentation/screens/login_screen.dart';
import 'package:tech_nest/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/screens/cart_items_screen.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/screens/categories_screen.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_cubit.dart';
import 'package:tech_nest/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:tech_nest/features/checkout/presentation/screens/location_picker_screen.dart';
import 'package:tech_nest/features/home/presentation/screens/home_screen.dart';
import 'package:tech_nest/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';
import 'package:tech_nest/features/orders/presentation/screens/order_details_screen.dart';
import 'package:tech_nest/features/orders/presentation/screens/orders_list_screen.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/screens/product_details_screen.dart';
import 'package:tech_nest/features/settings/presentation/screens/settings_screen.dart';
import 'package:tech_nest/service_locator.dart';

class AppRouter {
  static final AuthNotifier _authNotifier = sl<AuthNotifier>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  const AppRouter._();

  static final GoRouter routes = GoRouter(
    navigatorKey: _shellNavigatorKey,
    initialLocation: Routes.homeScreenPath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: _shellBuilder,
        branches: [
          StatefulShellBranch(routes: [_homeScreenRouter]),
          StatefulShellBranch(routes: [_cartScreenRouter]),
          StatefulShellBranch(routes: [_categoriesScreenRouter]),
          StatefulShellBranch(routes: [_ordersScreenRouter]),
          StatefulShellBranch(routes: [_settingsScreenRouter]),
        ],
      ),
      _signUpScreenRouter,
      _loginScreenRouter,
      _onboardingScreenRouter,
    ],
    refreshListenable: _authNotifier,
    redirect: (context, state) {
      AppLogger.log(state.matchedLocation);

      final bool hasSeenOnboarding =
          sl<CacheService>().get(AppConstants.onboardingKey) as bool? ?? false;

      if (!hasSeenOnboarding &&
          state.matchedLocation != Routes.onboardingScreenPath) {
        return Routes.onboardingScreenPath;
      }

      if (hasSeenOnboarding &&
          state.matchedLocation == Routes.onboardingScreenPath) {
        return Routes.loginScreenPath;
      }

      final bool isAuth = _authNotifier.isAuth;
      final authRoutes = [Routes.loginScreenPath, Routes.signUpScreenPath];
      final bool isAuthRoute = authRoutes.contains(state.matchedLocation);

      if (!isAuth &&
          !isAuthRoute &&
          state.matchedLocation != Routes.onboardingScreenPath) {
        return Routes.loginScreenPath;
      } else if (isAuth && isAuthRoute) {
        return Routes.homeScreenPath;
      }
      return null;
    },
  );

  static Widget _shellBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => sl<CartCubit>()..fetchCart()),
      BlocProvider(create: (context) => sl<OrdersListCubit>()..fetchOrders()),
    ],
    child: AppShellEntry(navigationShell: navigationShell),
  );

  static final _onboardingScreenRouter = GoRoute(
    path: Routes.onboardingScreenPath,
    builder: (context, state) => const OnboardingScreen(),
  );

  static final _signUpScreenRouter = GoRoute(
    path: Routes.signUpScreenPath,
    builder: (context, state) => BlocProvider(
      create: (context) => sl<RegistrationCubit>(),
      child: const SignUpScreen(),
    ),
  );

  static final _loginScreenRouter = GoRoute(
    path: Routes.loginScreenPath,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LoginCubit>()),
        BlocProvider(create: (context) => sl<ForgetPasswordCubit>()),
      ],
      child: const LoginScreen(),
    ),
  );

  static final _productdetailsRouter = GoRoute(
    path: Routes.productDetailsScreen,
    builder: (context, state) =>
        ProductDetailsScreen(product: state.extra as ProductEntity),
  );

  static final _homeScreenRouter = GoRoute(
    path: Routes.homeScreenPath,
    builder: (context, state) => BlocProvider(
      create: (context) => sl<FetchProductsCubit>(),
      child: const HomeScreen(),
    ),
    routes: [_productdetailsRouter],
  );

  static final _cartScreenRouter = GoRoute(
    path: Routes.cartScreenPath,
    builder: (context, state) => const CartItemsScreen(),
    routes: [_checkoutScreenRouter],
  );

  static final _categoriesScreenRouter = GoRoute(
    path: Routes.categoriesScreenPath,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FetchCategoriesCubit>()..fetchCategories(),
        ),
        BlocProvider(create: (context) => sl<CategoryProductsCubit>()),
      ],
      child: const CategoriesScreen(),
    ),
    routes: [_productdetailsRouter],
  );

  static final _settingsScreenRouter = GoRoute(
    path: Routes.settingsScreenPath,
    builder: (context, state) => const SettingsScreen(),
  );

  static final _orderDetailsRouter = GoRoute(
    path: Routes.orderDetailsScreenPath,
    builder: (context, state) {
      final orderId = int.parse(state.extra.toString());
      return BlocProvider(
        create: (context) =>
            sl<OrderDetailsCubit>()..fetchOrderDetails(orderId),
        child: OrderDetailsScreen(orderId: orderId),
      );
    },
  );

  static final _ordersScreenRouter = GoRoute(
    path: Routes.ordersScreenPath,
    builder: (context, state) => const OrdersListScreen(),
    routes: [_orderDetailsRouter],
  );

  static final _checkoutScreenRouter = GoRoute(
    path: Routes.checkoutScreenPath,
    builder: (context, state) => BlocProvider(
      create: (context) => sl<CreateOrderCubit>(),
      child: const CheckoutScreen(),
    ),
    routes: [_locationPickerRouter],
  );

  static final _locationPickerRouter = GoRoute(
    path: Routes.locationPickerScreenPath,
    builder: (context, state) => const LocationPickerScreen(),
  );
}
