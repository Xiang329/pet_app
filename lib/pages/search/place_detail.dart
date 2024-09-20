import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/place.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/utils/launcher_utils.dart';

class PlaceDetailPage extends StatefulWidget {
  final Place place;
  final int tabIndex;
  const PlaceDetailPage({
    super.key,
    required this.place,
    required this.tabIndex,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  late GoogleMapController mapController;
  late LatLng _center;

  @override
  void initState() {
    super.initState();
    _center = LatLng(
      widget.place.location.latitude,
      widget.place.location.longitude,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: widget.tabIndex == 0 ? const Text('找醫院') : const Text('找商店'),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
          color: UiColor.theme1Color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectionArea(
                child: Card(
                  color: UiColor.textinputColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.place.displayName.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text1Color,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '地址　${widget.place.formattedAddress}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2Color,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '電話　${widget.place.nationalPhoneNumber}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2Color,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '評價　${widget.place.rating} (${widget.place.userRatingCount})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2Color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                // height: 260,
                child: Card(
                  color: UiColor.textinputColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '營業時間',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text1Color,
                                ),
                              ),
                              const SizedBox(height: 10),
                              widget.place.regularOpeningHours == null
                                  ? const Text(
                                      '店家未提供營業時間',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: UiColor.text2Color,
                                      ),
                                    )
                                  : ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: widget
                                          .place
                                          .regularOpeningHours!
                                          .weekdayDescriptions
                                          .length,
                                      itemBuilder: (context, index) {
                                        return Text(
                                          widget.place.regularOpeningHours!
                                              .weekdayDescriptions[index]
                                              .replaceFirst(':', '　')
                                              .replaceAll(',', '\n${'　' * 4}'),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: UiColor.text2Color,
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const SizedBox(height: 5),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: UiColor.textinputColor,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: GoogleMap(
                    // Web版 我的位置暫時不支援
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onCameraMove: null,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('location'),
                        position: _center,
                      ),
                    },
                    onTap: (argument) {
                      LauncherUtils.openUrl(widget.place.googleMapsUri);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
