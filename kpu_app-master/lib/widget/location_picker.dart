import 'package:flutter/material.dart'; // Import untuk widget dan tema Material Design.
import 'package:flutter/widgets.dart'; // Import untuk widget dasar.
import 'package:flutter_map/flutter_map.dart'; // Import untuk widget peta Flutter.
import 'package:geolocator/geolocator.dart'; // Import untuk mendapatkan lokasi saat ini.
import 'package:latlong2/latlong.dart'; // Import untuk menggunakan tipe data LatLng.
import 'package:permission_handler/permission_handler.dart'; // Import untuk memeriksa dan meminta izin.
import 'package:geocoding/geocoding.dart' as geocoding; // Import untuk geocoding, mengubah koordinat menjadi alamat.

class LocationPicker extends StatefulWidget {
  final Function(LatLng) onLocationPicked; // Callback untuk mengirimkan lokasi yang dipilih.

  // Konstruktor untuk menerima callback onLocationPicked.
  LocationPicker({required this.onLocationPicked});

  @override
  _LocationPickerState createState() => _LocationPickerState(); // Membuat instance state untuk LocationPicker.
}

class _LocationPickerState extends State<LocationPicker> {
  final MapController _mapController = MapController(); // Kontroler untuk peta.
  LatLng? _currentLocation; // Menyimpan lokasi saat ini.
  bool _isLoading = true; // Menyimpan status loading.

  @override
  void initState() {
    super.initState();
    _checkPermissions(); // Memeriksa izin lokasi saat inisialisasi.
  }

  // Memeriksa izin lokasi dan meminta jika belum diberikan.
  Future<void> _checkPermissions() async {
    final locationStatus = await Permission.location.status; // Mengecek status izin lokasi saat ini.
    if (locationStatus.isDenied) {
      final status = await Permission.location.request(); // Meminta izin lokasi jika belum diberikan.
      if (status.isGranted) {
        _getCurrentLocation(); // Mengambil lokasi saat ini jika izin diberikan.
      } else {
        setState(() {
          _isLoading = false; // Menyembunyikan indikator loading jika izin tidak diberikan.
        });
      }
    } else if (locationStatus.isGranted) {
      _getCurrentLocation(); // Mengambil lokasi saat ini jika izin sudah diberikan.
    } else {
      setState(() {
        _isLoading = false; // Menyembunyikan indikator loading jika izin tidak dapat ditentukan.
      });
    }
  }

  // Mengambil lokasi saat ini menggunakan Geolocator.
  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Mengatur akurasi lokasi tinggi.
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude); // Menyimpan lokasi saat ini.
        _isLoading = false; // Menyembunyikan indikator loading setelah lokasi didapat.
        // Opsional: Pusatkan peta pada lokasi saat ini.
        _mapController.move(_currentLocation!, 13.0);
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Menyembunyikan indikator loading jika terjadi error.
      });
    }
  }

  // Menangani klik pada peta dan memperbarui lokasi.
  Future<void> _handleTap(LatLng latLng) async {
    setState(() {
      _currentLocation = latLng; // Memperbarui lokasi saat ini dengan lokasi yang diklik.
    });

    final placemarks = await geocoding.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    ); // Mengambil alamat berdasarkan koordinat.
    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final address = '${placemark.street}, ${placemark.locality}, ${placemark.country}';
      widget.onLocationPicked(latLng); // Mengirimkan lokasi yang dipilih melalui callback.
      Navigator.pop(context); // Menutup layar pemilih lokasi setelah memilih.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Lokasi'), // Judul untuk AppBar.
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController, // Mengatur kontroler peta.
            options: MapOptions(
              initialCenter: _currentLocation ?? LatLng(-6.200000, 106.816666), // Menetapkan pusat awal peta, default ke Jakarta jika lokasi belum tersedia.
              initialZoom: 13.0, // Menetapkan zoom awal peta.
              onTap: (tapPosition, point) => _handleTap(point), // Menangani klik pada peta untuk memperbarui lokasi.
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', // Template URL untuk layer tile peta.
                subdomains: ['a', 'b', 'c'], // Subdomain untuk tiles.
              ),
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!, // Menetapkan lokasi marker.
                      child: Container(
                        child: Icon(Icons.pin_drop, color: Colors.red, size: 40), // Menampilkan ikon marker.
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator()), // Menampilkan indikator loading jika sedang memuat.
        ],
      ),
    );
  }
}
