class Preference {
  final int sorting;
  final String storeId;

  Preference({this.sorting, this.storeId});
  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
      sorting: json['sorting'],
      storeId: json['storeId'],
    );
  }
  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'sorting': sorting,
      'storeId': storeId,
    };
  }

  Preference copyWith({int sorting, String storeId}) {
    return Preference(
      sorting: sorting ?? this.sorting,
      storeId: storeId ?? this.storeId,
    );
  }
}
