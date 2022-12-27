import 'package:hospital_finder/pages/map_page.dart';
import 'package:hospital_finder/provider/map_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:provider/provider.dart';
import '../widgets/map_bottom_sheet.dart';

const _mainColor = Color(0xff26264D);
const _secondaryColor = Color(0xffDBDBE5);

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final _cityController = TextEditingController();

  List<Place>? searchPlaces;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _savePlace() {
    if (_cityController.text.isEmpty) {
      return;
    }

    Provider.of<MapProvider>(context, listen: false)
        .addLocation('Rumah Sakit', _cityController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff4A4A71),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _cityField(),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _mainColor,
            ),
            onPressed: (() {
              _savePlace();
              setState(() {});
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapPage(),
                ),
              );
            }),
            child: const Text(
              "Search",
              style: TextStyle(color: _secondaryColor),
            ),
          ),
          _cityController.text.isNotEmpty
              ? Flexible(
                  child: FutureBuilder(
                    future: Provider.of<MapProvider>(context, listen: false)
                        .searchLocation(),
                    builder: (context, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : Consumer<MapProvider>(
                            builder: (context, location, child) => location
                                        .mapItem.place ==
                                    null
                                ? child!
                                : ListView.builder(
                                    itemCount: location.mapPlaces.length,
                                    itemBuilder: (context, index) => Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: _mainColor,
                                      ),
                                    ),
                                  ),
                          ),
                  ),
                )
              : const Flexible(
                  child: Center(
                    child: Text(
                      'Kota tidak ditemukan!',
                      style: TextStyle(color: _secondaryColor),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _cityField() {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: 300,
      child: TextFormField(
        enabled: true,
        controller: _cityController,
        style: const TextStyle(
          color: _secondaryColor,
        ),
        cursorColor: const Color.fromRGBO(255, 163, 26, 1),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 3,
              color: _mainColor,
            ),
          ),
          filled: true,
          fillColor: _mainColor,
          labelText: 'Kota',
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Future<void> searchLocation(String st, String city) async {
    await Nominatim.searchByName(
      street: st,
      city: city,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    ).then(
      (value) => setState(
        () => {searchPlaces = value},
      ),
    );
  }
}
