class Rate {
  final String source;
  final String destination;
  final String rate;

  Rate({required this.source, required this.destination, required this.rate});

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      source: json['source'],
      destination: json['destination'],
      rate: json['rate'],
    );
  }
}