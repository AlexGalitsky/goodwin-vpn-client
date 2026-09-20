/// Standard vs Advanced UI depth (tabs / power-user tools).
enum UiMode {
  standard,
  advanced;

  String get storageValue => name;

  static UiMode parse(String? raw) =>
      raw == 'advanced' ? UiMode.advanced : UiMode.standard;
}
