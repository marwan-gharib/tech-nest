import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/routing/deep_link_router.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter mockGoRouter;
  late GoRouterDeepLinkStrategy strategy;

  setUp(() {
    mockGoRouter = MockGoRouter();
    strategy = GoRouterDeepLinkStrategy(router: mockGoRouter);
  });

  group('GoRouterDeepLinkStrategy', () {
    test('navigates when route is valid', () {
      final validRoute = '/product/42';
      strategy.navigate(validRoute);
      verify(() => mockGoRouter.push(validRoute)).called(1);
    });

    test('falls back to home on empty route', () {
      strategy.navigate('');
      verify(() => mockGoRouter.push('/')).called(1);
    });

    test('falls back to home on route not starting with slash', () {
      strategy.navigate('product/42');
      verify(() => mockGoRouter.push('/')).called(1);
    });
  });
}
