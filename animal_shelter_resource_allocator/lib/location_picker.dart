import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_geocoding/google_geocoding.dart';

import 'models/globals.dart';

class LocationInputWidget extends StatefulWidget {
  const LocationInputWidget({Key? key}) : super(key: key);

  @override
  _LocationInputWidgetState createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedAddress;
  double? _latitude;
  double? _longitude;

  Future<void> _searchLocation(String address) async {
    try {
      String apiKey = dotenv.env['API_KEY']!;
      GoogleGeocoding googleGeocoding = GoogleGeocoding(apiKey);
      final geocodingResponse =
          await googleGeocoding.geocoding.get(address, []);
      final locations = geocodingResponse?.results;
      if (locations != null) {
        final location = locations.first;
        setState(() {
          _selectedAddress = location.formattedAddress;
          _latitude = location.geometry?.location?.lat;
          _longitude = location.geometry?.location?.lng;
        });
        Globals.userInformation['latitude'] = _latitude;
        Globals.userInformation['longitude'] = _longitude;
        Globals.userInformation['address'] = _selectedAddress;
      } else {
        setState(() {
          _selectedAddress = 'No results found for "$address"';
          _latitude = null;
          _longitude = null;
        });
      }
    } on Exception catch (e) {
      setState(() {
        _selectedAddress = 'Error: $e';
        _latitude = null;
        _longitude = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search location',
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            await _searchLocation(_searchController.text);
          },
          child: Text('Search'),
        ),
        const SizedBox(height: 16),
        if (_selectedAddress != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected location:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(_selectedAddress!),
              const SizedBox(height: 8),
              Text(
                'Latitude: ${_latitude?.toStringAsFixed(5) ?? '-'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'Longitude: ${_longitude?.toStringAsFixed(5) ?? '-'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
      ],
    );
  }
}
