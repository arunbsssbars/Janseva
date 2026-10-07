import '../models/aqi_station.dart';

class AqiService {
  static List<AqiStation> getLiveStations() {
    return [
      AqiStation(
        id: 'AQI-01',
        name: 'Civil Lines Central Monitoring Tower',
        ward: 'Ward 1 - Civil Lines',
        aqi: 142,
        pm25: 58.4,
        pm10: 112.0,
        no2: 32.5,
        dominantPollutant: 'PM2.5',
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      AqiStation(
        id: 'AQI-02',
        name: 'Gandhi Nagar Green Belt Sensor',
        ward: 'Ward 2 - Gandhi Nagar',
        aqi: 78,
        pm25: 28.0,
        pm10: 64.5,
        no2: 18.2,
        dominantPollutant: 'PM10',
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      AqiStation(
        id: 'AQI-03',
        name: 'Industrial Zone Smog Sensor #4',
        ward: 'Ward 3 - Industrial Area',
        aqi: 312,
        pm25: 185.0,
        pm10: 290.4,
        no2: 68.1,
        dominantPollutant: 'PM2.5',
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      AqiStation(
        id: 'AQI-04',
        name: 'Model Town Eco-Park Grid',
        ward: 'Ward 4 - Model Town',
        aqi: 45,
        pm25: 14.2,
        pm10: 38.0,
        no2: 12.0,
        dominantPollutant: 'O3',
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
    ];
  }
}
