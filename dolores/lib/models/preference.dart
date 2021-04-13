import 'package:dolores/providers/product_provider.dart';

class Preference {
  final ProductSort sort;
  final bool reverse;
  //final String storeId;

  Preference({this.sort, this.reverse = false});

  Preference copyWith({ProductSort sort, String storeId, bool reverse}) {
    return Preference(
      sort: sort ?? this.sort,
      reverse: reverse ?? this.reverse,
    );
  }

  Preference.fromJson(Map<String, dynamic> json)
      : sort = ProductSort.values[json['sort']],
        reverse = json['reverse'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sort': sort.index,
      'reverse': reverse,
    };
  }
}
