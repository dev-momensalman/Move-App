class ShowModel {
  final int id;
  final String name;
  final String type;
  final String language;
  final List<String> genres;
  final String status;
  final int? runtime;
  final int? averageRuntime;
  final String? premiered;
  final String? ended;
  final String? url;
  final double? rating;
  final int weight;
  final String? networkName;
  final String? imageUrl;
  final String? summary;

  ShowModel({
    required this.id,
    required this.name,
    required this.type,
    required this.language,
    required this.genres,
    required this.status,
    this.runtime,
    this.averageRuntime,
    this.premiered,
    this.ended,
    this.url,
    this.rating,
    required this.weight,
    this.networkName,
    this.imageUrl,
    this.summary,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      language: json['language'] ?? 'Unknown',
      genres: List<String>.from(json['genres'] ?? []),
      status: json['status'] ?? 'Unknown',
      runtime: json['runtime'],
      averageRuntime: json['averageRuntime'],
      premiered: json['premiered'],
      ended: json['ended'],
      url: json['url'],
      rating: json['rating']?['average']?.toDouble(),
      weight: json['weight'] ?? 0,
      networkName: json['network']?['name'] ?? json['webChannel']?['name'],
      imageUrl: json['image']?['medium'],
      summary: json['summary'],
    );
  }

  String get displayYear {
    if (premiered == null) return '—';
    return premiered!.split('-').first;
  }

  String get displayRuntime {
    final rt = averageRuntime ?? runtime;
    if (rt == null) return '—';
    return '${rt}m';
  }

  String get strippedSummary {
    if (summary == null) return '';
    return summary!
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }
}
