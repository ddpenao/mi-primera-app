# Pillbox

Pillbox ayuda a organizar tratamientos farmacológicos con dosis
periódicas, generando automáticamente horarios de administración que
respetan el descanso nocturno del usuario. Envía recordatorios y alarmas
para cada dosis, y lleva un historial de cumplimiento del tratamiento.

## El dominio

- `Usuario`          — entidad principal. Identidad: `id`.
- `PreferenciaHoraria` — objeto de valor.
- `EstadoUsuario`    — sellada: Activo · Configurando · Inactivo.

Decisión: modelo generado con freezed para `==`, `copyWith` y `toString`,
pero con `fromJson`/`toJson` escritos a mano (`@Freezed(fromJson: false, toJson: false)`),
porque el mensaje de error de `CampoInvalido` es más útil en producción que el
genérico de `json_serializable`.

Se perdió el `assert` de validación en `Inactivo.motivo` (freezed no soporta
asserts en el constructor generado) y la protección de `copyWith` sobre `id`
y `creadoEn`, que en la versión a mano eran inmutables por diseño.

Los archivos `*.freezed.dart` no se versionan (ver `.gitignore`); el CI los
regenera antes de correr los tests.

## Cómo correrlo

    flutter pub get
    dart run build_runner build --delete-conflicting-outputs
    flutter test
    flutter run