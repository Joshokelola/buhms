import 'package:buhms/app/view/app.dart';
import 'package:buhms/bootstrap.dart';

Future<void> main() async {
  await bootstrap(builder: App.new);
}
