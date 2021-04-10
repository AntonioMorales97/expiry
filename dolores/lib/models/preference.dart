import 'package:dolores/providers/product_provider.dart';

class Preference {
  final ProductSort sort;
  final String storeId;

  Preference({this.sort, this.storeId});

  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
      sort: ProductSort.values[json['sort']],
      storeId: json['storeId'],
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sort': sort.index,
      'storeId': storeId,
    };
  }

  Preference copyWith({ProductSort sort, String storeId}) {
    return Preference(
      sort: sort ?? this.sort,
      storeId: storeId ?? this.storeId,
    );
  }
}
