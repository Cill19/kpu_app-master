import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk Firestore, digunakan untuk mengambil data dari koleksi.
import 'package:cached_network_image/cached_network_image.dart'; // Import untuk menampilkan gambar dengan caching dari URL.
import 'package:flutter/material.dart'; // Import untuk widget dan tema Material Design.
import 'package:kpu_app/model/data_model.dart'; // Import model data yang digunakan untuk mengonversi dokumen menjadi objek DataModel.

class ViewDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF407BFF),
        title: Text('Data Pemilihan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
      ),
      body: StreamBuilder<QuerySnapshot>(
        // StreamBuilder digunakan untuk menangani stream dari Firestore secara real-time.
        stream: FirebaseFirestore.instance.collection('pemilihan').snapshots(), // Mengambil snapshot data secara real-time dari koleksi 'pemilihan'.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Jika koneksi masih menunggu data
            return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat menunggu data.
          }

          if (snapshot.hasError) {
            // Jika ada error saat mengambil data
            return Center(child: Text('Something went wrong', style: TextStyle(color: Colors.red))); // Menampilkan pesan error.
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Jika tidak ada data atau data kosong
            return Center(child: Text('No data available', style: TextStyle(color: Colors.grey))); // Menampilkan pesan bahwa tidak ada data yang tersedia.
          }

          final data = snapshot.data!.docs
              .map((doc) => DataModel.fromDocument(doc)) // Mengonversi setiap dokumen menjadi objek DataModel.
              .toList(); // Mengonversi hasil map menjadi daftar (list).

          return ListView.builder(
            itemCount: data.length, // Menentukan jumlah item dalam daftar.
            itemBuilder: (context, index) {
              final item = data[index]; // Mengambil item DataModel untuk indeks saat ini.
              return Card(
                elevation: 4.0, // Bayangan card untuk efek mengangkat
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Margin untuk jarak antara card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Sudut melengkung untuk card
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0), // Padding di dalam ListTile
                  leading: CachedNetworkImage(
                    imageUrl: item.fotoUrl, // URL gambar yang akan ditampilkan.
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0), // Membuat sudut gambar sedikit melengkung
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover, // Memastikan gambar mengisi area dengan baik
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(), // Menampilkan indikator loading saat gambar diambil.
                    errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red), // Menampilkan ikon error jika gagal mengambil gambar.
                  ),
                  title: Text(
                    item.nama,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NIK: ${item.nik}',
                        style: TextStyle(color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tanggal: ${item.tanggal.toDate()}',
                        style: TextStyle(color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No HP: ${item.noHp}',
                        style: TextStyle(color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Jenis Kelamin: ${item.jenisKelamin}',
                        style: TextStyle(color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Alamat: ${item.alamat}',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  isThreeLine: true, // Mengatur ListTile agar dapat menampilkan tiga baris teks.
                ),
              );
            },
          );
        },
      ),
    );
  }
}
