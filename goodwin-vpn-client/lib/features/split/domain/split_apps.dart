class InstalledApp {
  const InstalledApp({required this.packageName, required this.label});

  final String packageName;
  final String label;
}

/// Packages that skip the Android TUN when Protect banking is on.
/// `addDisallowedApplication` is a no-op (caught) if the app is not installed.
const kBankingPackages = <String>[
  'ru.sberbankmobile',
  'ru.sber.nova',
  'com.idamobile.android',
  'ru.alfabank.mobile.android',
  'ru.vtb24.mobilebanking.android',
  'com.vtb.mobilebanking',
  'ru.raiffeisennews',
  'ru.gazprombank.android',
  'ru.sovcombank.mobile',
  'ru.rshb.dbo',
  'ru.mts.money',
  'com.yandex.bank',
  'com.revolut.revolut',
  'com.wise.androidclient',
  'com.paypal.android.p2pmobile',
  'com.google.android.apps.walletnfcrel',
];

List<String> mergeDisallowedPackages({
  required Iterable<String> userSelected,
  required bool protectBanking,
}) {
  final seen = <String>{};
  final out = <String>[];
  void add(String raw) {
    final value = raw.trim();
    if (value.isEmpty || !seen.add(value)) return;
    out.add(value);
  }

  for (final package in userSelected) {
    add(package);
  }
  if (protectBanking) {
    for (final package in kBankingPackages) {
      add(package);
    }
  }
  return out;
}
