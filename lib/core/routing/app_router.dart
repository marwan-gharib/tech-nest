import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/services/auth/auth_notifier.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/features/app_shell/presentation/app_shell_entry.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/screens/login_screen.dart';
import 'package:tech_nest/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:tech_nest/features/cart/presentation/screens/cart_items_screen.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/screens/categories_screen.dart';
import 'package:tech_nest/features/demo_screen.dart';
import 'package:tech_nest/features/home/presentation/screens/home_screen.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/screens/product_details_screen.dart';

class AppRouter {
  static final AuthNotifier _authNotifier = sl<AuthNotifier>();

  const AppRouter._();

  static final GoRouter routes = GoRouter(
    initialLocation: Routes.cartScreenPath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: _shellBuilder,
        branches: [
          StatefulShellBranch(routes: [_homeScreenRouter]),
          StatefulShellBranch(routes: [_cartScreenRouter]),
          StatefulShellBranch(routes: [_categoriesScreenRouter]),
          StatefulShellBranch(routes: [_settingsScreenRouter]),
          StatefulShellBranch(routes: [_profileScreenRouter]),
        ],
      ),
      _signUpScreenRouter,
      _loginScreenRouter,
      _forgetPasswordRouter,
      _verifyEmailRouter,
    ],
    refreshListenable: _authNotifier,
    redirect: (context, state) {
      Logger.logg(state.matchedLocation);
      final bool isAuth = _authNotifier.isAuth;
      final authRoutes = [Routes.loginScreenPath, Routes.signUpScreenPath];
      final bool isAuthRoute = authRoutes.contains(state.matchedLocation);

      if (!isAuth && !isAuthRoute) {
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
  ) => BlocProvider(
    create: (context) => sl<CartCubit>()..fetchCart(),
    child: AppShellEntry(navigationShell: navigationShell),
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
    path: '${Routes.productDetailsScreen}/:id',
    builder: (context, state) => ProductDetailsScreen(
      productId: int.parse(state.pathParameters['id']!),
    ),
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
    builder: (context, state) => const DemoScreen(label: "Settings Screen"),
  );

  static final _profileScreenRouter = GoRoute(
    path: Routes.profileScreenPath,
    builder: (context, state) => const DemoScreen(label: "Profile Screen"),
  );

  static final _forgetPasswordRouter = GoRoute(
    path: Routes.forgetPasswordScreenPath,
    builder: (context, state) => const DemoScreen(label: "Forget Password"),
  );

  static final _verifyEmailRouter = GoRoute(
    path: Routes.verifyEmailScreenPath,
    builder: (context, state) => const DemoScreen(label: "Verify Email"),
  );
}
