enum AqiCategory {
  good,
  moderate,
  poor,
  veryPoor,
  severe,
}

class AqiStation {
  final String id;
  final String name;
  final String ward;
  final int aqi;
  final double pm25;
  final double pm10;
  final double no2;
  final String dominantPollutant;
  final DateTime lastUpdated;

  const AqiStation({
    required this.id,
    required this.name,
    required this.ward,
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.dominantPollutant,
    required this.lastUpdated,
  });

  AqiCategory get category {
    if (aqi <= 50) return AqiCategory.good;
    if (aqi <= 100) return AqiCategory.moderate;
    if (aqi <= 200) return AqiCategory.poor;
    if (aqi <= 300) return AqiCategory.veryPoor;
    return AqiCategory.severe;
  }

  String get advisoryEn {
    switch (category) {
      case AqiCategory.good:
        return 'Air quality is satisfactory. Enjoy outdoor activities.';
      case AqiCategory.moderate:
        return 'Acceptable air quality. Unusually sensitive individuals should limit prolonged exertion.';
      case AqiCategory.poor:
        return 'Breathing discomfort possible for children, elderly, and people with lung/heart disease.';
      case AqiCategory.veryPoor:
        return 'Respiratory illness on prolonged exposure. Wear N95 masks outdoors.';
      case AqiCategory.severe:
        return 'Emergency alert! Healthy individuals impacted. Avoid outdoor activities completely.';
    }
  }

  String get advisoryHi {
    switch (category) {
      case AqiCategory.good:
        return 'वायु गुणवत्ता संतोषजनक है। बाहरी गतिविधियों का आनंद लें।';
      case AqiCategory.moderate:
        return 'वायु गुणवत्ता सामान्य है। संवेदनशील लोग बाहरी श्रम सीमित करें।';
      case AqiCategory.poor:
        return 'सांस लेने में असुविधा हो सकती है। बच्चे और बुजुर्ग सावधानी बरतें।';
      case AqiCategory.veryPoor:
        return 'गंभीर श्वसन संबंधी खतरा। बाहर निकलते समय N95 मास्क अवश्य पहनें।';
      case AqiCategory.severe:
        return 'आपातकालीन चेतावनी! बाहर निकलना टालें और वायु शोधक का उपयोग करें।';
    }
  }
}
