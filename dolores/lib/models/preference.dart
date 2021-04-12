import 'package:dolores/providers/product_provider.dart';

class Preference {
  final ProductSort sort;
  final bool reverse;
  final String storeId;

  Preference({this.sort, this.storeId, this.reverse = false});

  Preference copyWith({ProductSort sort, String storeId, bool reverse}) {
    return Preference(
      sort: sort ?? this.sort,
      storeId: storeId ?? this.storeId,
      reverse: reverse ?? this.reverse,
    );
  }

  Preference.fromJson(Map<String, dynamic> json)
      : sort = ProductSort.values[json['sort']],
        storeId = json['storeId'],
        reverse = json['reverse'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sort': sort.index,
      'storeId': storeId,
      'reverse': reverse,
    };
  }
}
