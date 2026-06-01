import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'flows/authenticated_shell_flow.dart';
import 'flows/first_launch_checkout_flow.dart';
import 'flows/settings_logout_flow.dart';
import 'support/e2e_test_context.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final e2e = E2ETestContext();

  setUpAll(e2e.setUpAll);
  setUp(e2e.reset);

  firstLaunchCheckoutFlow(e2e);
  authenticatedShellFlow(e2e);
  settingsLogoutFlow(e2e);
}
