import 'package:flutter/material.dart';
import 'package:mi_papp/features/usuarios/data/usuarios_locales.dart';
import 'package:mi_papp/features/usuarios/domain/usuario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usuarios',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const PantallaUsuarios(),
    );
  }
}

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  late final Future<List<Usuario>> _usuarios = UsuariosLocales().obtenerTodos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: FutureBuilder<List<Usuario>>(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('No se pudo leer:\n${snapshot.error}'));
          }

          final usuarios = snapshot.data ?? const <Usuario>[];

          return ListView.separated(
            itemCount: usuarios.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final usuario = usuarios[i];

              return ListTile(
                title: Text(usuario.nombre),
                subtitle: Text(
                  '${usuario.correo ?? 'Sin correo'} · '
                  '${usuario.estado.etiqueta}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
