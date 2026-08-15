import 'package:flutter_test/flutter_test.dart';
import 'package:mi_papp/main.dart';

void main() {
  testWidgets('Muestra la pantalla de usuarios', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Espera a que termine de cargar el JSON.
    await tester.pumpAndSettle();

    // Comprueba el título de la aplicación.
    expect(find.text('Usuarios'), findsOneWidget);

    // Comprueba los usuarios del archivo usuarios.json.
    expect(find.text('Daniel'), findsOneWidget);
    expect(find.text('Laura'), findsOneWidget);
    expect(find.text('Carlos'), findsOneWidget);
  });
}
