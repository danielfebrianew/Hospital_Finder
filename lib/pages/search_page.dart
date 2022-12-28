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
  String selectedValue = "Rumah Sakit";

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _savePlace() {
    if (selectedValue.isEmpty && _cityController.text.isEmpty) {
      return;
    }
    if (kDebugMode) {
      print('value $selectedValue');
      print('value $_cityController');
    }
    Provider.of<MapProvider>(context, listen: false)
        .addLocation(selectedValue, _cityController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xff4A4A71),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.center,
            height: 60,
            width: 300,
            child: DropdownButtonFormField(
              hint: const Text('Pilih Rumah Sakit'),
              value: selectedValue,
              items: dropdownItems,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                  _cityController.text.isNotEmpty ? _savePlace() : null;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _mainColor, width: 3),
                ),
                filled: true,
                fillColor: _mainColor,
                focusColor: _mainColor,
              ),
              dropdownColor: _mainColor,
              style: const TextStyle(
                  color: _secondaryColor, fontWeight: FontWeight.bold),
              iconEnabledColor: _secondaryColor,
            ),
          ),
          const SizedBox(height: 15),
          _cityField(),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _mainColor,
            ),
            onPressed: (() {
              _savePlace();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapPage(),
                ),
              );
              setState(() {});
            }),
            child: const Text(
              "Search",
              style: TextStyle(color: _secondaryColor),
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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "Rumah Sakit",
        child: Text("Rumah Sakit"),
      ),
      const DropdownMenuItem(
        value: "Puskesmas",
        child: Text("Puskesmas"),
      )
    ];
    return menuItems;
  }
}
