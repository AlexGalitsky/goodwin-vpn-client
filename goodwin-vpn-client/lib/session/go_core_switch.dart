/// Two Go `c-shared` libraries (libxray + libhysteria) cannot safely live in one
/// process — a second `dlopen` / Start typically SIGSEGV/SIGABRT.
class GoCoreSwitchRequired implements Exception {
  GoCoreSwitchRequired({required this.from, required this.to});

  final String from;
  final String to;

  @override
  String toString() =>
      'GoCoreSwitchRequired($from → $to): process restart required';
}
