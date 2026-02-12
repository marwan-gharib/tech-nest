import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/router/routers.dart';
import 'package:tech_nest/demo_screen.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registeration_cubit/registeration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/screens/login_screen.dart';
import 'package:tech_nest/features/auth/presentation/screens/sign_up_screen.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter routes = GoRouter(
    initialLocation: Routers.signUpScreenPath,
    routes: [
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
      GoRoute(
        path: Routers.demoPath,
        builder: (context, state) => const DemoScreen(),
      ),
    ],
  );
}
