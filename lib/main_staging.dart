import 'package:flutter/widgets.dart';
import 'package:vgv/app/app.dart';
import 'package:vgv/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bootstrap(() => const App());
}
