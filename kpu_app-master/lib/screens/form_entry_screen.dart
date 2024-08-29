import 'dart:io'; // Import untuk kelas File, digunakan untuk menangani file.
import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk Firestore, digunakan untuk penyimpanan data.
import 'package:firebase_storage/firebase_storage.dart'; // Import untuk Firebase Storage, digunakan untuk penyimpanan foto.
import 'package:flutter/material.dart'; // Import untuk widget dan tema Material Design.
import 'package:geolocator/geolocator.dart'; // Import untuk mengambil informasi lokasi dari perangkat.
import 'package:image_picker/image_picker.dart'; // Import untuk mengambil gambar dari kamera atau galeri.
import 'package:intl/intl.dart'; // Import untuk format tanggal.
import 'package:kpu_app/screens/existing_data_screen.dart'; // Import untuk layar yang menunjukkan data yang sudah ada.
import 'package:kpu_app/screens/view_data_screen.dart'; // Import untuk layar yang menunjukkan data yang telah disubmit.
import 'package:kpu_app/widget/location_picker.dart'; // Import untuk widget pemilih lokasi.
import 'package:latlong2/latlong.dart'; // Import untuk manipulasi koordinat lokasi.
import 'package:geocoding/geocoding.dart' as geocoding; // Import untuk mengubah koordinat menjadi alamat.

class FormEntryScreen extends StatefulWidget {
  @override
  _FormEntryScreenState createState() => _FormEntryScreenState(); // Mengembalikan instance dari state yang terkait dengan widget ini.
}

class _FormEntryScreenState extends State<FormEntryScreen> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk mengidentifikasi form dan validasinya.
  final TextEditingController _nikController = TextEditingController(); // Kontroler untuk field NIK.
  final TextEditingController _namaController = TextEditingController(); // Kontroler untuk field Nama.
  final TextEditingController _noHpController = TextEditingController(); // Kontroler untuk field No HP.
  final TextEditingController _alamatController = TextEditingController(); // Kontroler untuk field Alamat.
  String? _jenisKelamin; // Variabel untuk menyimpan jenis kelamin.
  DateTime? _tanggalLahir; // Variabel untuk menyimpan tanggal lahir.
  File? _imageFile; // Variabel untuk menyimpan file gambar.
  final ImagePicker _picker = ImagePicker(); // Instance ImagePicker untuk mengambil gambar.
  LatLng? _location; // Variabel untuk menyimpan lokasi yang dipilih.
  bool _isLoading = false; // Variabel untuk menunjukkan status loading.

  @override
  void dispose() {
    _nikController.dispose(); // Melepaskan kontroler NIK.
    _namaController.dispose(); // Melepaskan kontroler Nama.
    _noHpController.dispose(); // Melepaskan kontroler No HP.
    _alamatController.dispose(); // Melepaskan kontroler Alamat.
    super.dispose(); // Memanggil metode dispose dari superclass.
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_jenisKelamin == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Jenis Kelamin harus dipilih')), // Menampilkan pesan jika jenis kelamin tidak dipilih
        );
        return;
      }
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foto harus diunggah')), // Menampilkan pesan jika foto tidak diunggah
        );
        return;
      }
      if (_tanggalLahir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tanggal lahir harus dipilih')), // Menampilkan pesan jika tanggal lahir tidak dipilih
        );
        return;
      }

      setState(() {
        _isLoading = true; // Mengatur status loading menjadi true saat form sedang diproses
      });

      final String nik = _nikController.text;

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('pemilihan')
          .where('nik', isEqualTo: nik)
          .get();

      if (result.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ExistingDataScreen(nik: nik)),
        );
      } else {
        String? imageUrl;
        if (_imageFile != null) {
          final storageRef = FirebaseStorage.instance.ref();
          final imageRef = storageRef.child('photos/${DateTime.now().millisecondsSinceEpoch}.jpg');
          await imageRef.putFile(_imageFile!);
          imageUrl = await imageRef.getDownloadURL();
        }

        String? address;
        if (_location != null) {
          final placemarks = await geocoding.placemarkFromCoordinates(
            _location!.latitude,
            _location!.longitude,
          );
          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;
            address = '${placemark.street}, ${placemark.locality}, ${placemark.country}';
          }
        }

        await FirebaseFirestore.instance.collection('pemilihan').add({
          'nik': nik,
          'nama': _namaController.text,
          'no_hp': _noHpController.text,
          'jenis_kelamin': _jenisKelamin,
          'tanggal': _tanggalLahir,
          'alamat': address ?? 'Alamat tidak tersedia',
          'foto': imageUrl,
        });

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan')),
        );

        _formKey.currentState?.reset();
        setState(() {
          _jenisKelamin = null;
          _tanggalLahir = null;
          _imageFile = null;
          _location = null;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewDataScreen()),
        );
      }
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await showModalBottomSheet<XFile>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera, color: Colors.blue),
            title: Text('Ambil Foto'),
            onTap: () async {
              Navigator.pop(context, await _picker.pickImage(source: ImageSource.camera));
            },
          ),
          ListTile(
            leading: Icon(Icons.image, color: Colors.blue),
            title: Text('Pilih dari Galeri'),
            onTap: () async {
              Navigator.pop(context, await _picker.pickImage(source: ImageSource.gallery));
            },
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  void _pickLocation() async {
    final LatLng? pickedLocation = await showModalBottomSheet<LatLng>(
      context: context,
      builder: (context) => LocationPicker(
        onLocationPicked: (LatLng location) {
          setState(() {
            _location = location;
            _alamatController.text = 'Loading...';
          });
          _fetchAddress(location);
        },
      ),
    );

    if (pickedLocation != null) {
      setState(() {
        _location = pickedLocation;
      });
    }
  }

  Future<void> _fetchAddress(LatLng location) async {
    final placemarks = await geocoding.placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );
    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final address = '${placemark.street}, ${placemark.locality}, ${placemark.country}';
      setState(() {
        _alamatController.text = address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF407BFF),
        title: Text('Form Entry', style: TextStyle(color: Colors.white)),
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextField(
                  controller: _nikController,
                  labelText: 'NIK',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIK harus diisi';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _namaController,
                  labelText: 'Nama',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _selectDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff407BFF),
                  ),
                  child: Text(
                    _tanggalLahir == null
                        ? 'Pilih Tanggal Lahir'
                        : 'Tanggal Lahir: ${DateFormat('dd-MM-yyyy').format(_tanggalLahir!)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Text("Jenis Kelamin", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text('Laki-laki'),
                        leading: Radio<String>(
                          value: 'L',
                          groupValue: _jenisKelamin,
                          onChanged: (value) {
                            setState(() {
                              _jenisKelamin = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text('Perempuan'),
                        leading: Radio<String>(
                          value: 'P',
                          groupValue: _jenisKelamin,
                          onChanged: (value) {
                            setState(() {
                              _jenisKelamin = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  controller: _noHpController,
                  labelText: 'No HP',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No HP harus diisi';
                    }
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'No HP harus berupa angka';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildTextField(
                  controller: _alamatController,
                  labelText: 'Alamat',
                  maxLines: 3,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.map),
                    onPressed: _pickLocation,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _imageFile != null
                    ? Card(
                        elevation: 4,
                        child: Image.file(
                          _imageFile!,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Tidak ada foto yang dipilih', style: TextStyle(color: Colors.grey)),
                      ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _selectImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff407BFF),
                  ),
                  child: Text(
                    'Pilih Foto',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff407BFF),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }
}
