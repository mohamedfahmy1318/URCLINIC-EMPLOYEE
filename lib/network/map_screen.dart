import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../main.dart';
import 'location_service.dart';

class MapScreen extends StatefulWidget {
  final String? address;

  const MapScreen({super.key, this.address});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final CameraPosition _initialLocation =
      const CameraPosition(target: LatLng(0.0, 0.0));
  final Completer<GoogleMapController> _mapControllerCompleter =
      Completer<GoogleMapController>();
  LatLng? _pendingCameraTarget;

  String _currentAddress = '';

  final destinationAddressController = TextEditingController();
  final destinationAddressFocusNode = FocusNode();
  RxBool isLoading = false.obs;
  String _destinationAddress = '';

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      destinationAddressController.text = widget.address.validate();
    }
    afterBuildCreated(() {
      _getCurrentLocation();
    });
  }

  // Method for retrieving the current location
  Future<void> _getCurrentLocation() async {
    isLoading(true);
    try {
      final Position position = await getUserLocationPosition();
      await _updateMarkerAndAddress(position.latitude, position.longitude,
          markerId: 'current_location');
      await _animateTo(LatLng(position.latitude, position.longitude));
    } catch (e) {
      toast('$e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _updateMarkerAndAddress(double latitude, double longitude,
      {required String markerId}) async {
    try {
      _currentAddress = await buildFullAddressFromLatLong(latitude, longitude);
      destinationAddressController.text = _currentAddress;
      _destinationAddress = _currentAddress;

      markers
        ..clear()
        ..add(
          Marker(
            markerId: MarkerId(markerId),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
                title: _currentAddress.validate(),
                snippet: _destinationAddress),
          ),
        );

      setState(() {});
    } catch (e) {
      log('_updateMarkerAndAddress $e');
      rethrow;
    }
  }

  Future<void> _handleTap(LatLng point) async {
    isLoading(true);
    try {
      await _updateMarkerAndAddress(point.latitude, point.longitude,
          markerId: point.toString());
    } catch (e) {
      toast('$e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _animateTo(LatLng target) async {
    if (!_mapControllerCompleter.isCompleted) {
      _pendingCameraTarget = target;
      return;
    }

    final GoogleMapController controller = await _mapControllerCompleter.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 18.0),
      ),
    );
  }

  @override
  void dispose() {
    destinationAddressController.dispose();
    destinationAddressFocusNode.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Avoid double pop: custom back handling only when framework did not pop.
        if (!didPop) {
          handleBack();
        }
      },
      child: AppScaffold(
        leadingWidget: BackButton(
          onPressed: () {
            handleBack();
          },
        ),
        appBartitleText: locale.value.chooseYourLocation,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                if (!_mapControllerCompleter.isCompleted) {
                  _mapControllerCompleter.complete(controller);
                }

                final LatLng? pendingTarget = _pendingCameraTarget;
                if (pendingTarget != null) {
                  _pendingCameraTarget = null;
                  _animateTo(pendingTarget);
                }
              },
              onTap: _handleTap,
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100,
                      child: InkWell(
                        splashColor:
                            context.primaryColor.withValues(alpha: 0.8),
                        child: const SizedBox(
                            width: 50, height: 50, child: Icon(Icons.add)),
                        onTap: () {
                          if (_mapControllerCompleter.isCompleted) {
                            _mapControllerCompleter.future.then((controller) {
                              controller.animateCamera(CameraUpdate.zoomIn());
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100,
                      child: InkWell(
                        splashColor:
                            context.primaryColor.withValues(alpha: 0.8),
                        child: const SizedBox(
                            width: 50, height: 50, child: Icon(Icons.remove)),
                        onTap: () {
                          if (_mapControllerCompleter.isCompleted) {
                            _mapControllerCompleter.future.then((controller) {
                              controller.animateCamera(CameraUpdate.zoomOut());
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ).paddingLeft(10),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.orange.shade100, // button color
                      child: const Icon(Icons.my_location, size: 25)
                          .paddingAll(10),
                    ),
                  ).paddingRight(8).onTap(() async {
                    isLoading(true);
                    try {
                      final Position value = await getUserLocationPosition();
                      final LatLng location =
                          LatLng(value.latitude, value.longitude);
                      await _animateTo(location);
                      await _handleTap(location);
                    } catch (e) {
                      toast('$e');
                    } finally {
                      isLoading(false);
                    }
                  }),
                  8.height,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppTextField(
                        title: locale.value.address,
                        controller: destinationAddressController,
                        focus: destinationAddressFocusNode,
                        // Optional
                        textFieldType: TextFieldType.MULTILINE,
                        decoration: inputDecoration(
                          context,
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  AppButton(
                    width: Get.width,
                    height: 16,
                    color: appColorPrimary.withValues(alpha: 0.8),
                    text: locale.value.setAddress,
                    textStyle: boldTextStyle(color: white, size: 12),
                    onTap: () {
                      handleBack(isSetAddress: true);
                    },
                  ),
                  8.height,
                ],
              ).paddingAll(16),
            ),
            Obx(() => const LoaderWidget().center().visible(isLoading.value)),
          ],
        ),
      ),
    );
  }

  void handleBack({bool isSetAddress = false}) {
    if (isSetAddress) {
      Get.back(result: destinationAddressController.text);
    } else {
      Get.back(result: "");
    }
  }
}
