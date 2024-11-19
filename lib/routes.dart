import 'package:go_router/go_router.dart';
import 'package:invoice_generator_app/screens/invoice_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(routes: [
    GoRoute(
      path: "/",
      name: "/",
      builder: (context, state) => const InvoiceScreen(),
    )
  ]);
}
