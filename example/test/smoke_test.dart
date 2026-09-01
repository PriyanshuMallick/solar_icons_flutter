import 'package:flutter_test/flutter_test.dart';
import 'package:solar_icons_flutter_example/main.dart';

void main() {
  testWidgets('gallery builds', (tester) async {
    await tester.pumpWidget(const SolarGalleryApp());
    await tester.pump();
  });
}
