import 'package:flutter/material.dart';
import 'http_service.dart';
import 'model_surat.dart';

String cleanHtmlTags(String htmlString) {
  return htmlString.replaceAll(RegExp(r'<.*?>'), '');
}

class Detail extends StatelessWidget {
  final Surat surat;
  final HttpService httpService = HttpService();

  Detail({required this.surat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surat.namaLatin),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Surat>(
        future: httpService.getAyatBySurat(surat.nomor),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data"));
          } else if (!snapshot.hasData || snapshot.data!.ayat.isEmpty) {
            return const Center(child: Text("Ayat tidak ditemukan"));
          }

          final suratData = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      suratData.namaLatin,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        suratData.nomor.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      "Nama: ${suratData.nama}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Latin: ${suratData.namaLatin}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.translate, color: Colors.blue),
                    title: Text(
                      "Arti: ${suratData.arti}",
                      style: const TextStyle(
                          fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  Text(
                    "Ayat dalam Surat ${suratData.namaLatin}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: suratData.ayat.length,
                    itemBuilder: (context, index) {
                      final ayat = suratData.ayat[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      ayat.nomor.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      ayat.ar,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                cleanHtmlTags(ayat.tr), // Bersihkan tag HTML
                                style: TextStyle(
                                    fontSize: 17, 
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700]),
                              ),
                              Text(
                                "Terjemahan: ${cleanHtmlTags(ayat.idn)}", // Bersihkan tag HTML
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
