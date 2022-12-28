import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_finder/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

const _mainColor = Color(0xff26264D);
const _secondaryColor = Color(0xffDBDBE5);

class MainPageState extends State<MainPage> {
  List<Place>? searchPlaces;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: const SearchLocation(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: _mainColor,
      title: const Text('Health Services'),
      titleTextStyle: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      centerTitle: true,
      leading: const Icon(
        Icons.search,
        color: _secondaryColor,
      ),
      actions: const [
        Icon(
          Icons.map,
          color: _secondaryColor,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const color = _secondaryColor;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: _secondaryColor,
        ),
      ),
      hoverColor: _secondaryColor,
      onTap: onClicked,
    );
  }
}
