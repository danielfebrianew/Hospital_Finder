import 'package:flutter/material.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

const _mainColor = Color(0xff26264D);
const _secondaryColor = Color(0xffDBDBE5);

class MapBottomSheet extends StatelessWidget {
  final Place place;

  const MapBottomSheet({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final address = place.displayName
        .substring(place.displayName.indexOf(",") + 1, place.displayName.length)
        .trim();

    final placesName =
        place.displayName.substring(0, place.displayName.indexOf(",")).trim();

    var size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _secondaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 100,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: _mainColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SafeArea(
                    child: Text(
                      placesName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
