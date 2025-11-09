import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  // Get user's current location
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Get city name from coordinates
  static Future<String?> getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return place.locality ?? place.administrativeArea ?? 'Unknown';
      }
    } catch (e) {
      print('Error getting city name: $e');
    }
    return null;
  }

  // Get average annual rainfall for Indian cities (sample data)
  static double getRainfallForCity(String city) {
    final Map<String, double> cityRainfall = {
      'Mumbai': 2400,
      'Delhi': 797,
      'Bangalore': 970,
      'Bengaluru': 970,
      'Hyderabad': 812,
      'Chennai': 1400,
      'Kolkata': 1582,
      'Pune': 722,
      'Ahmedabad': 803,
      'Jaipur': 650,
      'Lucknow': 896,
      'Chandigarh': 1110,
      'Bhopal': 1146,
      'Indore': 980,
      'Nagpur': 1205,
      'Patna': 1098,
      'Ranchi': 1430,
      'Thiruvananthapuram': 1827,
      'Kochi': 3014,
      'Guwahati': 1700,
    };

    // Return city rainfall or default 800mm
    return cityRainfall[city] ?? 800;
  }

  // Fetch rainfall using OpenWeatherMap API (optional - requires API key)
  static Future<double?> fetchRainfallFromAPI(
    double latitude,
    double longitude,
    String apiKey,
  ) async {
    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Process and return rainfall data
        // Note: You might need to make multiple API calls for annual data
        return 800.0; // Placeholder
      }
    } catch (e) {
      print('Error fetching rainfall: $e');
    }
    return null;
  }
}

// Extension method to add to your calculator screen
extension LocationExtension on State {
  Future<void> detectLocationAndRainfall({
    required Function(String city, double rainfall) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      // Show loading indicator
      showDialog(
        context: context as BuildContext,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFFFF9B70),
                ),
                SizedBox(height: 16),
                Text(
                  'Detecting your location...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Get location
      Position? position = await LocationService.getCurrentLocation();

      if (position == null) {
        Navigator.pop(context as BuildContext);
        onError('Unable to get location. Please enable location services.');
        return;
      }

      // Get city name
      String? city = await LocationService.getCityName(
        position.latitude,
        position.longitude,
      );

      Navigator.pop(context as BuildContext);

      if (city != null) {
        double rainfall = LocationService.getRainfallForCity(city);
        onSuccess(city, rainfall);
      } else {
        onError('Unable to detect city name');
      }
    } catch (e) {
      Navigator.pop(context as BuildContext);
      onError('Error: ${e.toString()}');
    }
  }
}
