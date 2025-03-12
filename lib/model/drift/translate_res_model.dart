class TranslateResModel {
  final String time;
  final List<List<String>> data;

  TranslateResModel({required this.time, required this.data});

  factory TranslateResModel.fromJson(Map<String, dynamic> json) {
    return TranslateResModel(
      time: json['time'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'data': data,
    };
  }
}
