import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/cubits/add_product_to_cart_cubit/add_product_to_cart_cubit.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/entities/product_entity.dart';
import 'package:tech_nest/core/router/routers.dart';
import 'package:tech_nest/core/services/auth/auth_notifire.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/features/app_shell/presentation/app_shell_entry.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registeration_cubit/registeration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/screens/login_screen.dart';
import 'package:tech_nest/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/screens/cart_items_screen.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/screens/categories_screen.dart';
import 'package:tech_nest/features/demo_screen.dart';
import 'package:tech_nest/features/home/presentation/screens/home_screen.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/screens/product_details_screen.dart';

class AppRouter {
  static final AuthNotifire _authNotifire = sl<AuthNotifire>();

  const AppRouter._();

  static final GoRouter routes = GoRouter(
    initialLocation: Routers.homeScreenPath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellEntry(navigationShell: navigationShell),
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
    ],
    refreshListenable: _authNotifire,
    redirect: (context, state) {
      Logger.logg(state.matchedLocation);
      final bool isAuth = _authNotifire.isAuth;
      final authRoutes = [Routers.loginScreenPath, Routers.signUpScreenPath];
      final bool isAuthRoute = authRoutes.contains(state.matchedLocation);

      if (!isAuth && !isAuthRoute) {
        return Routers.loginScreenPath;
      } else if (isAuth && isAuthRoute) {
        return Routers.homeScreenPath;
      }
      return null;
    },
  );

  static final _signUpScreenRouter = GoRoute(
    path: Routers.signUpScreenPath,
    builder: (context, state) => BlocProvider(
      create: (context) => sl<RegisterationCubit>(),
      child: const SignUpScreen(),
    ),
  );

  static final _loginScreenRouter = GoRoute(
    path: Routers.loginScreenPath,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LoginCubit>()),
        BlocProvider(create: (context) => sl<ForgetPasswordCubit>()),
      ],
      child: const LoginScreen(),
    ),
  );

  static final _productdetailsRouter = GoRoute(
    path: Routers.productDetailsScreen,
    name: Routers.productDetailsScreen,
    builder: (context, state) => BlocProvider(
      create: (context) => sl<AddProductToCartCubit>(),
      child: ProductDetailsScreen(product: state.extra as Product),
    ),
  );

  static final _homeScreenRouter = GoRoute(
    path: Routers.homeScreenPath,
    builder: (context, state) => BlocProvider(
      create: (context) => sl<FetchProductsCubit>(),
      child: const HomeScreen(),
    ),
    routes: [_productdetailsRouter],
  );

  static final _cartScreenRouter = GoRoute(
    path: Routers.cartScreenPath,
    builder: (context, state) => BlocProvider(
      create: (context) => sl<CartCubit>()..fetchCart(),
      child: const CartItemsScreen(),
    ),
  );

  static final _categoriesScreenRouter = GoRoute(
    path: Routers.categoriesScreenPath,
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
    path: "/settings",
    builder: (context, state) => const DemoScreen(label: "Settings Screen"),
  );

  static final _profileScreenRouter = GoRoute(
    path: "/profile",
    builder: (context, state) => const DemoScreen(label: "Profile Screen"),
  );
}
