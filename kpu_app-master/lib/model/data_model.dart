import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  String nik;
  String nama;
  String noHp;
  String jenisKelamin;
  String alamat;
  String fotoUrl;
  Timestamp tanggal;

  DataModel({
    required this.nik,
    required this.nama,
    required this.noHp,
    required this.jenisKelamin,
    required this.alamat,
    required this.fotoUrl,
    required this.tanggal
  });

  factory DataModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DataModel(
      nik: data['nik'],
      nama: data['nama'],
      noHp: data['no_hp'],
      jenisKelamin: data['jenis_kelamin'],
      alamat: data['alamat'],
      fotoUrl: data['foto'],
      tanggal: data['tanggal'],
    );
  }
}
