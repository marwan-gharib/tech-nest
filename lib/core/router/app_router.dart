import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/entities/product_entity.dart';
import 'package:tech_nest/core/router/routers.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';
import 'package:tech_nest/core/utils/auth/auth_notifire.dart';
import 'package:tech_nest/features/app_shell/presentation/app_shell_entry.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registeration_cubit/registeration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/screens/login_screen.dart';
import 'package:tech_nest/features/auth/presentation/screens/sign_up_screen.dart';
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
    initialLocation: sl<CacheService>().containsKey(ApiKeys.token)
        ? Routers.homeScreenPath
        : Routers.loginScreenPath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellEntry(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routers.homeScreenPath,
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<FetchProductsCubit>(),
                  child: const HomeScreen(),
                ),
                routes: [
                  GoRoute(
                    path: Routers.productDetailsScreen,
                    name: Routers.productDetailsScreen,
                    builder: (context, state) => ProductDetailsScreen(
                      product: state.extra as ProductEntity,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/cart",
                builder: (context, state) =>
                    const DemoScreen(label: "Cart Screen"),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/categories",
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          sl<FetchCategoriesCubit>()..fetchCategories(),
                    ),
                    BlocProvider(
                      create: (context) => sl<CategoryProductsCubit>(),
                    ),
                  ],
                  child: const CategoriesScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/settings",
                builder: (context, state) =>
                    const DemoScreen(label: "Settings Screen"),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/profile",
                builder: (context, state) =>
                    const DemoScreen(label: "Profile Screen"),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routers.signUpScreenPath,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<RegisterationCubit>(),
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: Routers.loginScreenPath,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<LoginCubit>()),
            BlocProvider(create: (context) => sl<ForgetPasswordCubit>()),
          ],
          child: const LoginScreen(),
        ),
      ),
    ],
    redirect: (context, state) {
      final bool isAuth = _authNotifire.isAuth;
      final bool isOnLoginPage =
          state.matchedLocation == Routers.loginScreenPath;

      if (!isAuth && !isOnLoginPage) {
        return Routers.loginScreenPath;
      } else if (isAuth && isOnLoginPage) {
        return Routers.homeScreenPath;
      }
      return null;
    },
    refreshListenable: _authNotifire,
  );
}
