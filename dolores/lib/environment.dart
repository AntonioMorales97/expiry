import 'package:meta/meta.dart';

enum BuildFlavor { production, development, staging, mock }

Environment get env => _env;
Environment _env;

class Environment {
  final String dumbledoreBaseUrl;
  final String filtchBaseUrl;
  final BuildFlavor flavor;

  Environment._init({
    this.flavor,
    this.dumbledoreBaseUrl,
    this.filtchBaseUrl,
  });

  /// Sets up the top-level [env] getter on the first call only.
  static void init(
          {@required flavor,
          @required dumbledoreBaseUrl,
          @required filtchBaseUrl}) =>
      _env ??= Environment._init(
        flavor: flavor,
        dumbledoreBaseUrl: dumbledoreBaseUrl,
        filtchBaseUrl: filtchBaseUrl,
      );
}
