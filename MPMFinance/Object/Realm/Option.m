//
//  Option.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "Option.h"

@implementation Option

+ (RLMResults *)getOptionWithCategoryNumber:(NSInteger)category{
    return [Option objectsWhere:@"category = %li", category];
}

+ (void)generateOptions{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    [Option new:realm :0 :0 :@"Investasi"];
    [Option new:realm :0 :1 :@"Modal Kerja"];
    [Option new:realm :0 :2 :@"Multiguna"];
    
    [Option new:realm :1 :0 :@"Indirect"];
    [Option new:realm :1 :1 :@"Call Center"];
    [Option new:realm :1 :2 :@"Direct Rio"];
    
    [Option new:realm :2 :0 :@"New Car"];
    [Option new:realm :2 :1 :@"Used Car"];
    [Option new:realm :2 :2 :@"Dahsyat 4W"];
    [Option new:realm :2 :3 :@"Dahsyat 2W"];
    [Option new:realm :2 :4 :@"New Bike"];
    [Option new:realm :2 :5 :@"Property"];
    
    [Option new:realm :3 :0 :@"> 60 Km"];
    [Option new:realm :3 :1 :@"60 - 120 Km"];
    [Option new:realm :3 :2 :@"> 120 Km"];
    [Option new:realm :3 :3 :@"Property"];
    
    [Option new:realm :4 :0 :@"Additional Order"];
    [Option new:realm :4 :1 :@"Instant Approval"];
    [Option new:realm :4 :2 :@"Regular"];
    [Option new:realm :4 :3 :@"Repeat Order"];
    
    [Option new:realm :5 :0 :@"Additional Order"];
    [Option new:realm :5 :1 :@"Instant Approval"];
    [Option new:realm :5 :2 :@"Regular"];
    [Option new:realm :5 :3 :@"Repeat Order"];
    
    [Option new:realm :6 :0 :@"Laki - Laki"];
    [Option new:realm :6 :1 :@"Perempuan"];
    
    [Option new:realm :7 :0 :@"Islam"];
    [Option new:realm :7 :1 :@"Katolik"];
    [Option new:realm :7 :2 :@"Kristen"];
    [Option new:realm :7 :3 :@"Hindu"];
    [Option new:realm :7 :4 :@"Budha"];
    [Option new:realm :7 :5 :@"Lainnya"];
    
    [Option new:realm :8 :0 :@"Company"];
    [Option new:realm :8 :1 :@"Customer"];
    
    [Option new:realm :9 :0 :@"New"];
    [Option new:realm :9 :1 :@"Used"];
    
    [Option new:realm :10 :0 :@"Commercial"];
    [Option new:realm :10 :1 :@"Non-commercial"];
    [Option new:realm :10 :2 :@"Semi-commercial"];
    
    [Option new:realm :11 :0 :@"Sumatera dan Kepulauan sekitarnya"];
    [Option new:realm :11 :1 :@"DKI Jakarta, Jawa Barat dan Banten"];
    [Option new:realm :11 :2 :@"Selain Wilayah 1 dan 2"];
    
    [Option new:realm :12 :0 :@"Belum Kawin"];
    [Option new:realm :12 :1 :@"Kawin"];
    [Option new:realm :12 :2 :@"Janda / Duda"];
    
    [Option new:realm :13 :0 :@"Sendiri"];
    [Option new:realm :13 :1 :@"Orang Tua"];
    [Option new:realm :13 :2 :@"Keluarga"];
    [Option new:realm :13 :3 :@"Kontrak"];
    [Option new:realm :13 :4 :@"Perusahaan"];
    [Option new:realm :13 :5 :@"Lainnya"];
    
    [Option new:realm :14 :0 :@"Apartemen"];
    [Option new:realm :14 :1 :@"Masuk gang"];
    [Option new:realm :14 :2 :@"Perkampungan"];
    [Option new:realm :14 :3 :@"Perumahan"];
    [Option new:realm :14 :4 :@"Ruko"];
    
    [Option new:realm :15 :0 :@"SD"];
    [Option new:realm :15 :1 :@"SMP"];
    [Option new:realm :15 :2 :@"SMA"];
    [Option new:realm :15 :3 :@"D3"];
    [Option new:realm :15 :4 :@"S1"];
    [Option new:realm :15 :5 :@"S2"];
    [Option new:realm :15 :6 :@"S3"];
    [Option new:realm :15 :7 :@"Tidak Sekolah"];
    
    [Option new:realm :16 :0 :@"Domisili"];
    [Option new:realm :16 :1 :@"Tempat Kerja"];
    
    [Option new:realm :17 :0 :@"Profesional"];
    [Option new:realm :17 :1 :@"Wiraswasta"];
    [Option new:realm :17 :2 :@"PNS"];
    [Option new:realm :17 :3 :@"Karyawan Swasta"];
    
    [Option new:realm :18 :0 :@"Permanen"];
    [Option new:realm :18 :1 :@"Kontrak"];
    
    [Option new:realm :19 :0 :@"KTA"];
    [Option new:realm :19 :1 :@"KPR / KPA"];
    [Option new:realm :19 :2 :@"CC"];
    [Option new:realm :19 :3 :@"KKB"];
    
    [Option new:realm :20 :0 :@"Anak"];
    [Option new:realm :20 :1 :@"Saudara Kandung"];
    [Option new:realm :20 :2 :@"Orang Tua"];
    [Option new:realm :20 :3 :@"Lainnya"];
    
    [Option new:realm :21 :0 :@"Bank Transfer"];
    [Option new:realm :21 :1 :@"Cash"];
    [Option new:realm :21 :2 :@"PDC"];
    
    [Option new:realm :22 :0 :@"Fixed"];
    [Option new:realm :22 :1 :@"Floating"];
    
    [Option new:realm :23 :0 :@"Advance"];
    [Option new:realm :23 :1 :@"Arrear"];
    
    [Option new:realm :24 :0 :@"Gaji"];
    [Option new:realm :24 :1 :@"Hasil Usaha"];
    
    [Option new:realm :25 :0 :@"Annual"];
    [Option new:realm :25 :1 :@"Full Tenor"];
    
    [Option new:realm :26 :0 :@"At Cost"];
    [Option new:realm :26 :1 :@"Customer"];
    
    [Option new:realm :27 :0 :@"Yes"];
    [Option new:realm :27 :1 :@"No"];
    
    [Option new:realm :28 :0 :@"Akunting / Keuangan"];
    [Option new:realm :28 :1 :@"Customer Service"];
    [Option new:realm :28 :2 :@"Engineering"];
    [Option new:realm :28 :3 :@"Eksekutif"];
    [Option new:realm :28 :4 :@"Administrasi Umum"];
    [Option new:realm :28 :5 :@"Teknologi Informasi"];
    [Option new:realm :28 :6 :@"Konsultan / Analis"];
    [Option new:realm :28 :7 :@"Marketing"];
    [Option new:realm :28 :8 :@"Pengajar (Guru, Dosen)"];
    [Option new:realm :28 :9 :@"Pemerintahan dan Lembaga Negara"];
    [Option new:realm :28 :10 :@"Pensiunan"];
    [Option new:realm :28 :11 :@"Pelajar / Mahasiswa"];
    [Option new:realm :28 :12 :@"Wiraswasta"];
    [Option new:realm :28 :13 :@"Polisi"];
    [Option new:realm :28 :14 :@"Petani"];
    [Option new:realm :28 :15 :@"Nelayan"];
    [Option new:realm :28 :16 :@"Peternak"];
    [Option new:realm :28 :17 :@"Dokter"];
    [Option new:realm :28 :18 :@"Tenaga Medis (Perawan, Bidan, dsb)"];
    [Option new:realm :28 :19 :@"Hukum (Notaris)"];
    [Option new:realm :28 :20 :@"Perhotelan dan Restoran (Koki, Bartender, dsb)"];
    [Option new:realm :28 :21 :@"Peneliti"];
    [Option new:realm :28 :22 :@"Desainer"];
    [Option new:realm :28 :23 :@"Arsitek"];
    [Option new:realm :28 :24 :@"Pekerja Seni (Artis, Musisi, Pelukis, dsb)"];
    [Option new:realm :28 :25 :@"Pengamanan"];
    [Option new:realm :28 :26 :@"Pialang / Broker"];
    [Option new:realm :28 :27 :@"Distributor"];
    [Option new:realm :28 :28 :@"Transportasi Udara (Pilot, Pramugari)"];
    [Option new:realm :28 :29 :@"Transportasi Laut (Nahkoda, ABK)"];
    [Option new:realm :28 :30 :@"Transportasi Darat (Masinis, Sopir, Kondektur)"];
    [Option new:realm :28 :31 :@"Buruh (Buruh Pabrik, Buruh Bangunan, Buruh Tani)"];
    [Option new:realm :28 :32 :@"Pertukangan dan Pengrajin (Tukang Kayu, Pengrajin Kulit, dsb)"];
    [Option new:realm :28 :33 :@"Ibu Rumah Tangga"];
    [Option new:realm :28 :34 :@"Pekerja Informal (Asisten Rumah Tangga, Asongan)"];
    [Option new:realm :28 :35 :@"Lain-lain"];
    
    [Option new:realm :29 :0 :@"Tanaman Pangan - Padi"];
    [Option new:realm :29 :1 :@"Tanaman Pangan - Palawija - lainnya"];
    [Option new:realm :29 :2 :@"Perkebunan karet"];
    [Option new:realm :29 :3 :@"Perkebunan Kelapa"];
    [Option new:realm :29 :4 :@"Perkebunan Kopi"];
    [Option new:realm :29 :5 :@"Perkebunan Tembakau"];
    [Option new:realm :29 :6 :@"Perkebunan Kelapa Sawit"];
    [Option new:realm :29 :7 :@"Perkebunan Teh"];
    [Option new:realm :29 :8 :@"Perkebunan Tebu"];
    [Option new:realm :29 :9 :@"Perkebunan Cengkeh"];
    [Option new:realm :29 :10 :@"Perkebunan lainnya"];
    [Option new:realm :29 :11 :@"Perikanan Laut - lainnya"];
    [Option new:realm :29 :12 :@"Perikanan Darat - lainnya"];
    [Option new:realm :29 :13 :@"Peternakan Unggas"];
    [Option new:realm :29 :14 :@"Peternakan Sapi"];
    [Option new:realm :29 :15 :@"Peternakan lainnya"];
    [Option new:realm :29 :16 :@"Kehutanan dan Pemotongan Kayu (logging)"];
    [Option new:realm :29 :17 :@"Sarana Pertanian - Alat penggarapan tanah"];
    [Option new:realm :29 :18 :@"Pertambangan Minyak dan Gas Bumi"];
    [Option new:realm :29 :19 :@"Pertambangan Biji Logam - Timah"];
    [Option new:realm :29 :20 :@"Pertambangan Biji Logam - Nikel"];
    [Option new:realm :29 :21 :@"Pertambangan Biji Logam - Lainnya"];
    [Option new:realm :29 :22 :@"Pertambangan Batubara"];
    [Option new:realm :29 :23 :@"Pertambangan Barang Tambang Lainnya"];
    [Option new:realm :29 :24 :@"Industri - Gula"];
    [Option new:realm :29 :25 :@"Industri - Minyak Kelapa Sawit Merah"];
    [Option new:realm :29 :26 :@"Industri - Minyak tumbuhan lain"];
    [Option new:realm :29 :27 :@"Industri - Garam"];
    [Option new:realm :29 :28 :@"Industri - Minuman"];
    [Option new:realm :29 :29 :@"Industri - Tembakau"];
    [Option new:realm :29 :30 :@"Industri - Rokok"];
    [Option new:realm :29 :31 :@"Industri - Makana Ternak Ikan"];
    [Option new:realm :29 :32 :@"Industri - Tekstil"];
    [Option new:realm :29 :33 :@"Industri - Kulit"];
    [Option new:realm :29 :34 :@"Industri - Bahan Kayu"];
    [Option new:realm :29 :35 :@"Industri - Kertas dan hasil-hasil kertas"];
    [Option new:realm :29 :36 :@"Industri - Percetakan dan penerbitan"];
    [Option new:realm :29 :37 :@"Industri - Pupuk / Obat Hama"];
    [Option new:realm :29 :38 :@"Industri - Farmasi"];
    [Option new:realm :29 :39 :@"Industri - Plastik"];
    [Option new:realm :29 :40 :@"Industri Logam Dasar - Besi baja"];
    [Option new:realm :29 :41 :@"Pembuatan Komponen - Maritim"];
    [Option new:realm :29 :42 :@"Pembuatan Komponen - Otomatif"];
    [Option new:realm :29 :43 :@"Pembuatan Komponen - Elektronika"];
    [Option new:realm :29 :44 :@"Pembuatan Komponen - Alat Pertanian"];
    [Option new:realm :29 :45 :@"Pembuatan Komponen - lainnya"];
    [Option new:realm :29 :46 :@"Konstruksi - Perumhan Sederhana PERUMNAS"];
    [Option new:realm :29 :47 :@"Konstruksi - Jalan Raya dan Jembatan"];
    [Option new:realm :29 :48 :@"Konstruksi - Pelabuhan"];
    [Option new:realm :29 :49 :@"Konstruksi - Irigasi"];
    [Option new:realm :29 :50 :@"Konstruksi - Listrik Lainnya"];
    [Option new:realm :29 :51 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Beras"];
    [Option new:realm :29 :52 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Kayu"];
    [Option new:realm :29 :53 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Karet"];
    [Option new:realm :29 :54 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Kelapa Sawit"];
    [Option new:realm :29 :55 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : kopra"];
    [Option new:realm :29 :56 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Cengkeh"];
    [Option new:realm :29 :57 :@" Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Hewan Hidup & Hasilnya"];
    [Option new:realm :29 :58 :@" Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Lainnya"];
    [Option new:realm :29 :59 :@"Distribusi Semen"];
    [Option new:realm :29 :60 :@"Distribusi Pupuk / Obat Hama"];
    [Option new:realm :29 :61 :@"Distribusi Besi Beton"];
    [Option new:realm :29 :62 :@"Distribusi Beras"];
    [Option new:realm :29 :63 :@"Distribusi Bahan Bakar Minyak"];
    [Option new:realm :29 :64 :@"Distribusi Lainnya"];
    [Option new:realm :29 :65 :@"Pedagang Eceran"];
    [Option new:realm :29 :66 :@"Restoran"];
    [Option new:realm :29 :67 :@"Hotel"];
    [Option new:realm :29 :68 :@"Pengangkutan, Pergudangan dan Komunikasi"];
    [Option new:realm :29 :69 :@"Pengangkutan Umum Darat"];
    [Option new:realm :29 :70 :@"Pengangkutan Umum Sungai"];
    [Option new:realm :29 :71 :@"Pengangkutan Umum laut"];
    [Option new:realm :29 :72 :@"Biro Perjalanan"];
    [Option new:realm :29 :73 :@"Pergudangan"];
    [Option new:realm :29 :74 :@" Komunikasi"];
    [Option new:realm :29 :75 :@"Jasa-jasa Dunia Usaha - Real Estate Lainnya"];
    [Option new:realm :29 :76 :@"Jasa-jasa Dunia Usaha - Leasing"];
    [Option new:realm :29 :77 :@"Jasa-jasa Dunia Usaha - Lainnya"];
    [Option new:realm :29 :78 :@"Jasa-jasa sosial/masyarakat - Hiburan dan kebudayaan"];
    [Option new:realm :29 :79 :@"Jasa-jasa sosial/masyarakat - Kesehatan - Profesi"];
    [Option new:realm :29 :80 :@"Jasa-jasa sosial/masyarakat - Kesehatan - tempat Perawatan/Pengobatan"];
    [Option new:realm :29 :81 :@"Jasa-jasa sosial/masyarakat - Pendidikan - Perguruan Tinggi"];
    [Option new:realm :29 :82 :@"Jasa-jasa sosial/masyarakat - Pendidikan Lainnya"];
    [Option new:realm :29 :83 :@"Lain-lain - Perumahan"];
    [Option new:realm :29 :84 :@"Lain-lain - Kendaraan"];
    [Option new:realm :29 :85 :@"Lain-lain - Alat Rumah Tangga"];
    
    [Option new:realm :30 :0 :@"Pengurus - Pemilik"];
    [Option new:realm :30 :1 :@"Pemilik - Direktur Utama / Pres. Dir"];
    [Option new:realm :30 :2 :@"Pemilik - Direktur"];
    [Option new:realm :30 :3 :@"Pemilik - Komisaris Utama / Pres. Kom"];
    [Option new:realm :30 :4 :@"Pemilik - Komisaris"];
    [Option new:realm :30 :5 :@"Pemilik - Kuasa Direksi"];
    [Option new:realm :30 :6 :@"Pemilik - Pemilik Bukan Pengurus"];
    [Option new:realm :30 :7 :@"Pemilik - Masyarakat"];
    [Option new:realm :30 :8 :@"Pemilik - Ketua Umum"];
    [Option new:realm :30 :9 :@"Pemilik - Ketua"];
    [Option new:realm :30 :10 :@"Pemilik - Sekretaris"];
    [Option new:realm :30 :11 :@"Pemilik - Bendahara"];
    [Option new:realm :30 :12 :@"Pemilik - Lainnya"];
    [Option new:realm :30 :13 :@"Pengurus Bukan Pemilik"];
    [Option new:realm :30 :14 :@"Bukan Pemilik - Direktur Utama / Pres. Dir"];
    [Option new:realm :30 :15 :@"Bukan Pemilik - Direktur"];
    [Option new:realm :30 :16 :@"Bukan Pemilik - Komisaris Utama / Pres. Kom"];
    [Option new:realm :30 :17 :@"Bukan Pemilik - Komisaris"];
    [Option new:realm :30 :18 :@"Bukan Pemilik - Kuasa Direksi"];
    [Option new:realm :30 :19 :@"Bukan Pemilik - Ketua Umum"];
    [Option new:realm :30 :20 :@"Bukan Pemilik - Ketua"];
    [Option new:realm :30 :21 :@"Bukan Pemilik - Sekretaris"];
    [Option new:realm :30 :22 :@"Bukan Pemilik - Bendahara"];
    [Option new:realm :30 :23 :@"Bukan Pemilik - Lainnya"];
    
    [Option new:realm :31 :0 :@"12"];
    [Option new:realm :31 :1 :@"18"];
    [Option new:realm :31 :2 :@"24"];
    [Option new:realm :31 :3 :@"30"];
    [Option new:realm :31 :4 :@"36"];
    
    [realm commitWriteTransaction];
}

+ (void)new:(RLMRealm *)realm :(NSInteger)category :(NSInteger)sort :(NSString *)name{
    Option *option = [[Option alloc] init];
    option.name = name;
    option.sort = sort;
    option.category = category;
    
    [realm addObject:option];
}

@end
