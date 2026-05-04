import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/animations/page_transitions.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/routing/routes.dart';
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
import 'package:tech_nest/features/notifications/presentation/notification_cubit/notification_cubit.dart';
import 'package:tech_nest/features/notifications/presentation/screens/notification_screen.dart';
import 'package:tech_nest/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';
import 'package:tech_nest/features/orders/presentation/screens/order_details_screen.dart';
import 'package:tech_nest/features/orders/presentation/screens/orders_list_screen.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/screens/product_details_screen.dart';
import 'package:tech_nest/features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static final AuthNotifier _authNotifier = sl<AuthNotifier>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  const AppRouter._();

  static final GoRouter routes = GoRouter(
    navigatorKey: _shellNavigatorKey,
    initialLocation: RoutePaths.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: _shellBuilder,
        branches: [
          StatefulShellBranch(routes: [_homeScreenRouter]),
          StatefulShellBranch(routes: [_cartScreenRouter]),
          StatefulShellBranch(routes: [_categoriesScreenRouter]),
          StatefulShellBranch(routes: [_ordersScreenRouter]),
          StatefulShellBranch(routes: [_notificationScreenRouter]),
          StatefulShellBranch(routes: [_settingsScreenRouter]),
        ],
      ),
      _signUpScreenRouter,
      _loginScreenRouter,
      _onboardingScreenRouter,
    ],
    refreshListenable: _authNotifier,
    redirect: (context, state) {
      final bool hasSeenOnboarding =
          sl<CacheService>().get(AppConstants.onboardingKey) as bool? ?? false;

      final bool isAuth = _authNotifier.isAuth;

      final authRoutes = [RoutePaths.login, RoutePaths.signUp];
      final bool isAuthRoute = authRoutes.contains(state.matchedLocation);

      if (!hasSeenOnboarding) {
        return state.matchedLocation == RoutePaths.onboarding
            ? null
            : RoutePaths.onboarding;
      }

      if (!isAuth) {
        return isAuthRoute ? null : RoutePaths.login;
      }

      if (isAuth && isAuthRoute) {
        return RoutePaths.home;
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
      BlocProvider(
        create: (context) => sl<NotificationCubit>()..initialFetching(),
      ),
    ],
    child: AppShellEntry(navigationShell: navigationShell),
  );

  static final _onboardingScreenRouter = GoRoute(
    name: RouteNames.onboarding,
    path: RoutePaths.onboarding,
    pageBuilder: (context, state) => PageTransitions.fadeTransition(
      context: context,
      state: state,
      child: const OnboardingScreen(),
    ),
  );

  static final _signUpScreenRouter = GoRoute(
    name: RouteNames.signUp,
    path: RoutePaths.signUp,
    pageBuilder: (context, state) => PageTransitions.slideTransition(
      context: context,
      state: state,
      child: BlocProvider(
        create: (context) => sl<RegistrationCubit>(),
        child: const SignUpScreen(),
      ),
    ),
  );

  static final _loginScreenRouter = GoRoute(
    name: RouteNames.login,
    path: RoutePaths.login,
    pageBuilder: (context, state) => PageTransitions.fadeTransition(
      context: context,
      state: state,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<LoginCubit>()),
          BlocProvider(create: (context) => sl<ForgetPasswordCubit>()),
        ],
        child: const LoginScreen(),
      ),
    ),
  );

  static final _homeScreenRouter = GoRoute(
    name: RouteNames.home,
    path: RoutePaths.home,
    builder: (context, state) => BlocProvider(
      create: (context) => sl<FetchProductsCubit>(),
      child: const HomeScreen(),
    ),
    routes: [
      GoRoute(
        name: RouteNames.homeProductDetails,
        path: RoutePaths.productDetails,
        pageBuilder: (context, state) => PageTransitions.slideTransition(
          context: context,
          state: state,
          child: ProductDetailsScreen(product: state.extra as ProductEntity),
        ),
      ),
    ],
  );

  static final _cartScreenRouter = GoRoute(
    name: RouteNames.cart,
    path: RoutePaths.cart,
    builder: (context, state) => const CartItemsScreen(),
    routes: [_checkoutScreenRouter],
  );

  static final _categoriesScreenRouter = GoRoute(
    name: RouteNames.categories,
    path: RoutePaths.categories,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FetchCategoriesCubit>()..fetchCategories(),
        ),
        BlocProvider(create: (context) => sl<CategoryProductsCubit>()),
      ],
      child: const CategoriesScreen(),
    ),
    routes: [
      GoRoute(
        name: RouteNames.categoryProductDetails,
        path: RoutePaths.productDetails,
        pageBuilder: (context, state) => PageTransitions.slideTransition(
          context: context,
          state: state,
          child: ProductDetailsScreen(product: state.extra as ProductEntity),
        ),
      ),
    ],
  );

  static final _settingsScreenRouter = GoRoute(
    name: RouteNames.settings,
    path: RoutePaths.settings,
    builder: (context, state) => const SettingsScreen(),
  );

  static final _orderDetailsRouter = GoRoute(
    name: RouteNames.orderDetails,
    path: RoutePaths.orderDetails,
    pageBuilder: (context, state) {
      final orderId = int.parse(state.extra.toString());
      return PageTransitions.slideTransition(
        context: context,
        state: state,
        child: BlocProvider(
          create: (context) =>
              sl<OrderDetailsCubit>()..fetchOrderDetails(orderId),
          child: OrderDetailsScreen(orderId: orderId),
        ),
      );
    },
  );

  static final _ordersScreenRouter = GoRoute(
    name: RouteNames.orders,
    path: RoutePaths.orders,
    builder: (context, state) => const OrdersListScreen(),
    routes: [_orderDetailsRouter],
  );

  static final _checkoutScreenRouter = GoRoute(
    name: RouteNames.checkout,
    path: RoutePaths.checkout,
    pageBuilder: (context, state) => PageTransitions.slideTransition(
      context: context,
      state: state,
      child: BlocProvider(
        create: (context) => sl<CreateOrderCubit>(),
        child: const CheckoutScreen(),
      ),
    ),
    routes: [_locationPickerRouter],
  );

  static final _locationPickerRouter = GoRoute(
    name: RouteNames.locationPicker,
    path: RoutePaths.locationPicker,
    pageBuilder: (context, state) => PageTransitions.slideUpTransition(
      context: context,
      state: state,
      child: const LocationPickerScreen(),
    ),
  );

  static final _notificationScreenRouter = GoRoute(
    name: RouteNames.notifications,
    path: RoutePaths.notifications,
    pageBuilder: (context, state) => PageTransitions.slideTransition(
      context: context,
      state: state,
      child: const NotificationScreen(),
    ),
  );
}
