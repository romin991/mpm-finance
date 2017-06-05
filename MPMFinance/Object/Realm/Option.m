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
    
    [Option new:realm :0 :0 :4 :@"Investasi"];
    [Option new:realm :0 :1 :5 :@"Modal Kerja"];
    [Option new:realm :0 :2 :6 :@"Multiguna"];
    
    [Option new:realm :1 :0 :7 :@"Indirect"];
    [Option new:realm :1 :1 :8 :@"Call Center"];
    [Option new:realm :1 :2 :9 :@"Direct Rio"];
    
    [Option new:realm :2 :0 :3 :@"New Car"];
    [Option new:realm :2 :1 :4 :@"Used Car"];
    [Option new:realm :2 :2 :8 :@"Dahsyat 4W"];
    [Option new:realm :2 :3 :7 :@"Dahsyat 2W"];
    [Option new:realm :2 :4 :1 :@"New Bike"];
    [Option new:realm :2 :5 :12 :@"Property"];
    [Option new:realm :2 :6 :13 :@"Electronic Finance"];
    [Option new:realm :2 :7 :14 :@"Corporate Finance"];
    [Option new:realm :2 :8 :15 :@"Tourism Finance"];
    
    [Option new:realm :3 :0 :10 :@"> 60 Km"];
    [Option new:realm :3 :1 :11 :@"60 - 120 Km"];
    [Option new:realm :3 :2 :12 :@"> 120 Km"];
    [Option new:realm :3 :3 :13 :@"Property"];
    
    [Option new:realm :4 :0 :118 :@"Additional Order"];
    [Option new:realm :4 :1 :119 :@"Instant Approval"];
    [Option new:realm :4 :2 :120 :@"Regular"];
    [Option new:realm :4 :3 :286 :@"Repeat Order"];
    
    [Option new:realm :5 :0 :103 :@"Milik Sendiri"];
    [Option new:realm :5 :1 :104 :@"Dinas"];
    [Option new:realm :5 :2 :105 :@"Keluarga"];
    [Option new:realm :5 :3 :106 :@"Kontrak / Kos"];
    
    [Option new:realm :6 :0 :14 :@"Laki - Laki"];
    [Option new:realm :6 :1 :15 :@"Perempuan"];
    
    [Option new:realm :7 :0 :16 :@"Islam"];
    [Option new:realm :7 :1 :20 :@"Katolik"];
    [Option new:realm :7 :2 :17 :@"Kristen"];
    [Option new:realm :7 :3 :18 :@"Hindu"];
    [Option new:realm :7 :4 :19 :@"Budha"];
    
    [Option new:realm :8 :0 :85 :@"Company"];
    [Option new:realm :8 :1 :84 :@"Customer"];
    
    [Option new:realm :9 :0 :86 :@"New"];
    [Option new:realm :9 :1 :87 :@"Used"];
    
    [Option new:realm :10 :0 :88 :@"Commercial"];
    [Option new:realm :10 :1 :89 :@"Non-commercial"];
    [Option new:realm :10 :2 :90 :@"Semi-commercial"];
    
    [Option new:realm :11 :0 :91 :@"Sumatera dan Kepulauan sekitarnya"];
    [Option new:realm :11 :1 :92 :@"DKI Jakarta"];
    [Option new:realm :11 :2 :93 :@"Jawa Barat"];
    [Option new:realm :11 :3 :94 :@"Banten"];
    [Option new:realm :11 :4 :95 :@"Selain Wilayah 1 dan 2"];
    
    [Option new:realm :12 :0 :21 :@"Belum Kawin"];
    [Option new:realm :12 :1 :22 :@"Kawin"];
    [Option new:realm :12 :2 :23 :@"Janda"];
    [Option new:realm :12 :3 :24 :@"Duda"];
    
    [Option new:realm :13 :0 :25 :@"Sendiri"];
    [Option new:realm :13 :1 :26 :@"Orang Tua"];
    [Option new:realm :13 :2 :27 :@"Keluarga"];
    [Option new:realm :13 :3 :28 :@"Kontrak"];
    [Option new:realm :13 :4 :29 :@"Perusahaan"];
    [Option new:realm :13 :5 :30 :@"Lainnya"];
    
    [Option new:realm :14 :0 :31 :@"Apartemen"];
    [Option new:realm :14 :1 :32 :@"Masuk gang"];
    [Option new:realm :14 :2 :33 :@"Perkampungan"];
    [Option new:realm :14 :3 :35 :@"Perumahan"];
    [Option new:realm :14 :4 :34 :@"Ruko"];
    
    [Option new:realm :15 :0 :36 :@"SD"];
    [Option new:realm :15 :1 :37 :@"SMP"];
    [Option new:realm :15 :2 :38 :@"SMA"];
    [Option new:realm :15 :3 :39 :@"D3"];
    [Option new:realm :15 :4 :40 :@"S1"];
    [Option new:realm :15 :5 :41 :@"S2"];
    [Option new:realm :15 :6 :42 :@"S3"];
    [Option new:realm :15 :7 :43 :@"Tidak Sekolah"];
    
    [Option new:realm :16 :0 :44 :@"Domisili"];
    [Option new:realm :16 :1 :45 :@"Tempat Kerja"];
    
    [Option new:realm :17 :0 :46 :@"Profesional"];
    [Option new:realm :17 :1 :47 :@"Wiraswasta"];
    [Option new:realm :17 :2 :48 :@"PNS"];
    [Option new:realm :17 :3 :49 :@"Karyawan Swasta"];
    
    [Option new:realm :18 :0 :52 :@"Permanen"];
    [Option new:realm :18 :1 :53 :@"Kontrak"];
    
    [Option new:realm :19 :0 :54 :@"KTA"];
    [Option new:realm :19 :1 :55 :@"KPR / KPA"];
    [Option new:realm :19 :2 :56 :@"CC"];
    [Option new:realm :19 :3 :57 :@"KKB"];
    
    [Option new:realm :20 :0 :274 :@"Anak"];
    [Option new:realm :20 :1 :275 :@"Saudara Kandung"];
    [Option new:realm :20 :2 :276 :@"Orang Tua"];
    [Option new:realm :20 :3 :277 :@"Lainnya"];
    
    [Option new:realm :21 :0 :58 :@"Bank Transfer"];
    [Option new:realm :21 :1 :59 :@"Cash"];
    [Option new:realm :21 :2 :60 :@"PDC"];
    
    [Option new:realm :22 :0 :61 :@"Fixed"];
    [Option new:realm :22 :1 :62 :@"Floating"];
    
    [Option new:realm :23 :0 :66 :@"Advance"];
    [Option new:realm :23 :1 :67 :@"Arrear"];
    
    [Option new:realm :24 :0 :@"Gaji"];
    [Option new:realm :24 :1 :@"Hasil Usaha"];
    
    [Option new:realm :25 :0 :72 :@"Annual"];
    [Option new:realm :25 :1 :73 :@"Full Tenor"];
    
    [Option new:realm :26 :0 :70 :@"At Cost"];
    [Option new:realm :26 :1 :71 :@"Customer"];
    
    [Option new:realm :27 :0 :116 :@"Yes"]; //kepemilikan garasi
    [Option new:realm :27 :1 :117 :@"No"];
    
    [Option new:realm :28 :0 :121 :@"Akunting / Keuangan"];
    [Option new:realm :28 :1 :122 :@"Customer Service"];
    [Option new:realm :28 :2 :123 :@"Engineering"];
    [Option new:realm :28 :3 :124 :@"Eksekutif"];
    [Option new:realm :28 :4 :125 :@"Administrasi Umum"];
    [Option new:realm :28 :5 :126 :@"Teknologi Informasi"];
    [Option new:realm :28 :6 :127 :@"Konsultan / Analis"];
    [Option new:realm :28 :7 :128 :@"Marketing"];
    [Option new:realm :28 :8 :129 :@"Pengajar (Guru, Dosen)"];
    [Option new:realm :28 :9 :130 :@"Pemerintahan dan Lembaga Negara"];
    [Option new:realm :28 :10 :131 :@"Pensiunan"];
    [Option new:realm :28 :11 :132 :@"Pelajar / Mahasiswa"];
    [Option new:realm :28 :12 :133 :@"Wiraswasta"];
    [Option new:realm :28 :13 :134 :@"Polisi"];
    [Option new:realm :28 :14 :135 :@"Petani"];
    [Option new:realm :28 :15 :136 :@"Nelayan"];
    [Option new:realm :28 :16 :137 :@"Peternak"];
    [Option new:realm :28 :17 :138 :@"Dokter"];
    [Option new:realm :28 :18 :139 :@"Tenaga Medis (Perawan, Bidan, dsb)"];
    [Option new:realm :28 :19 :140 :@"Hukum (Notaris)"];
    [Option new:realm :28 :20 :141 :@"Perhotelan dan Restoran (Koki, Bartender, dsb)"];
    [Option new:realm :28 :21 :142 :@"Peneliti"];
    [Option new:realm :28 :22 :143 :@"Desainer"];
    [Option new:realm :28 :23 :144 :@"Arsitek"];
    [Option new:realm :28 :24 :145 :@"Pekerja Seni (Artis, Musisi, Pelukis, dsb)"];
    [Option new:realm :28 :25 :146 :@"Pengamanan"];
    [Option new:realm :28 :26 :147 :@"Pialang / Broker"];
    [Option new:realm :28 :27 :148 :@"Distributor"];
    [Option new:realm :28 :28 :149 :@"Transportasi Udara (Pilot, Pramugari)"];
    [Option new:realm :28 :29 :150 :@"Transportasi Laut (Nahkoda, ABK)"];
    [Option new:realm :28 :30 :151 :@"Transportasi Darat (Masinis, Sopir, Kondektur)"];
    [Option new:realm :28 :31 :152 :@"Buruh (Buruh Pabrik, Buruh Bangunan, Buruh Tani)"];
    [Option new:realm :28 :32 :153 :@"Pertukangan dan Pengrajin (Tukang Kayu, Pengrajin Kulit, dsb)"];
    [Option new:realm :28 :33 :154 :@"Ibu Rumah Tangga"];
    [Option new:realm :28 :34 :155 :@"Pekerja Informal (Asisten Rumah Tangga, Asongan)"];
    [Option new:realm :28 :35 :156 :@"Lain-lain"];
    
    [Option new:realm :29 :0 :157 :@"Tanaman Pangan - Padi"];
    [Option new:realm :29 :1 :158 :@"Tanaman Pangan - Palawija - lainnya"];
    [Option new:realm :29 :2 :159 :@"Perkebunan karet"];
    [Option new:realm :29 :3 :160 :@"Perkebunan Kelapa"];
    [Option new:realm :29 :4 :161 :@"Perkebunan Kopi"];
    [Option new:realm :29 :5 :162 :@"Perkebunan Tembakau"];
    [Option new:realm :29 :6 :163 :@"Perkebunan Kelapa Sawit"];
    [Option new:realm :29 :7 :164 :@"Perkebunan Teh"];
    [Option new:realm :29 :8 :165 :@"Perkebunan Tebu"];
    [Option new:realm :29 :9 :166 :@"Perkebunan Cengkeh"];
    [Option new:realm :29 :10 :167 :@"Perkebunan lainnya"];
    [Option new:realm :29 :11 :168 :@"Perikanan Laut - lainnya"];
    [Option new:realm :29 :12 :169 :@"Perikanan Darat - lainnya"];
    [Option new:realm :29 :13 :170 :@"Peternakan Unggas"];
    [Option new:realm :29 :14 :171 :@"Peternakan Sapi"];
    [Option new:realm :29 :15 :172 :@"Peternakan lainnya"];
    [Option new:realm :29 :16 :173 :@"Kehutanan dan Pemotongan Kayu (logging)"];
    [Option new:realm :29 :17 :174 :@"Sarana Pertanian - Alat penggarapan tanah"];
    [Option new:realm :29 :18 :175 :@"Pertambangan Minyak dan Gas Bumi"];
    [Option new:realm :29 :19 :176 :@"Pertambangan Biji Logam - Timah"];
    [Option new:realm :29 :20 :177 :@"Pertambangan Biji Logam - Nikel"];
    [Option new:realm :29 :21 :178 :@"Pertambangan Biji Logam - Lainnya"];
    [Option new:realm :29 :22 :179 :@"Pertambangan Batubara"];
    [Option new:realm :29 :23 :180 :@"Pertambangan Barang Tambang Lainnya"];
    [Option new:realm :29 :24 :181 :@"Industri - Gula"];
    [Option new:realm :29 :25 :182 :@"Industri - Minyak Kelapa Sawit Merah"];
    [Option new:realm :29 :26 :183 :@"Industri - Minyak tumbuhan lain"];
    [Option new:realm :29 :27 :184 :@"Industri - Garam"];
    [Option new:realm :29 :28 :185 :@"Industri - Minuman"];
    [Option new:realm :29 :29 :186 :@"Industri - Tembakau"];
    [Option new:realm :29 :30 :187 :@"Industri - Rokok"];
    [Option new:realm :29 :31 :188 :@"Industri - Makana Ternak Ikan"];
    [Option new:realm :29 :32 :189 :@"Industri - Tekstil"];
    [Option new:realm :29 :33 :190 :@"Industri - Kulit"];
    [Option new:realm :29 :34 :191 :@"Industri - Bahan Kayu"];
    [Option new:realm :29 :35 :192 :@"Industri - Kertas dan hasil-hasil kertas"];
    [Option new:realm :29 :36 :193 :@"Industri - Percetakan dan penerbitan"];
    [Option new:realm :29 :37 :194 :@"Industri - Pupuk / Obat Hama"];
    [Option new:realm :29 :38 :195 :@"Industri - Farmasi"];
    [Option new:realm :29 :39 :196 :@"Industri - Plastik"];
    [Option new:realm :29 :40 :197 :@"Industri Logam Dasar - Besi baja"];
    [Option new:realm :29 :41 :198 :@"Pembuatan Komponen - Maritim"];
    [Option new:realm :29 :42 :199 :@"Pembuatan Komponen - Otomatif"];
    [Option new:realm :29 :43 :200 :@"Pembuatan Komponen - Elektronika"];
    [Option new:realm :29 :44 :201 :@"Pembuatan Komponen - Alat Pertanian"];
    [Option new:realm :29 :45 :202 :@"Pembuatan Komponen - lainnya"];
    [Option new:realm :29 :46 :203 :@"Konstruksi - Perumhan Sederhana PERUMNAS"];
    [Option new:realm :29 :47 :204 :@"Konstruksi - Jalan Raya dan Jembatan"];
    [Option new:realm :29 :48 :205 :@"Konstruksi - Pelabuhan"];
    [Option new:realm :29 :49 :206 :@"Konstruksi - Irigasi"];
    [Option new:realm :29 :50 :207 :@"Konstruksi - Listrik Lainnya"];
    [Option new:realm :29 :51 :208 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Beras"];
    [Option new:realm :29 :52 :209 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Kayu"];
    [Option new:realm :29 :53 :210 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Karet"];
    [Option new:realm :29 :54 :211 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Kelapa Sawit"];
    [Option new:realm :29 :55 :212 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : kopra"];
    [Option new:realm :29 :56 :213 :@"Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Cengkeh"];
    [Option new:realm :29 :57 :214 :@" Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Hewan Hidup & Hasilnya"];
    [Option new:realm :29 :58 :215 :@" Pembelian & Pengumpulan Brg. Dagangan Dlm. Neg. : Lainnya"];
    [Option new:realm :29 :59 :216 :@"Distribusi Semen"];
    [Option new:realm :29 :60 :217 :@"Distribusi Pupuk / Obat Hama"];
    [Option new:realm :29 :61 :218 :@"Distribusi Besi Beton"];
    [Option new:realm :29 :62 :219 :@"Distribusi Beras"];
    [Option new:realm :29 :63 :220 :@"Distribusi Bahan Bakar Minyak"];
    [Option new:realm :29 :64 :221 :@"Distribusi Lainnya"];
    [Option new:realm :29 :65 :222 :@"Pedagang Eceran"];
    [Option new:realm :29 :66 :223 :@"Restoran"];
    [Option new:realm :29 :67 :224 :@"Hotel"];
    [Option new:realm :29 :68 :225 :@"Pengangkutan, Pergudangan dan Komunikasi"];
    [Option new:realm :29 :69 :226 :@"Pengangkutan Umum Darat"];
    [Option new:realm :29 :70 :227 :@"Pengangkutan Umum Sungai"];
    [Option new:realm :29 :71 :228 :@"Pengangkutan Umum laut"];
    [Option new:realm :29 :72 :229 :@"Biro Perjalanan"];
    [Option new:realm :29 :73 :230 :@"Pergudangan"];
    [Option new:realm :29 :74 :231 :@" Komunikasi"];
    [Option new:realm :29 :75 :232 :@"Jasa-jasa Dunia Usaha - Real Estate Lainnya"];
    [Option new:realm :29 :76 :233 :@"Jasa-jasa Dunia Usaha - Leasing"];
    [Option new:realm :29 :77 :234 :@"Jasa-jasa Dunia Usaha - Lainnya"];
    [Option new:realm :29 :78 :235 :@"Jasa-jasa sosial/masyarakat - Hiburan dan kebudayaan"];
    [Option new:realm :29 :79 :236 :@"Jasa-jasa sosial/masyarakat - Kesehatan - Profesi"];
    [Option new:realm :29 :80 :237 :@"Jasa-jasa sosial/masyarakat - Kesehatan - tempat Perawatan/Pengobatan"];
    [Option new:realm :29 :81 :238 :@"Jasa-jasa sosial/masyarakat - Pendidikan - Perguruan Tinggi"];
    [Option new:realm :29 :82 :239 :@"Jasa-jasa sosial/masyarakat - Pendidikan Lainnya"];
    [Option new:realm :29 :83 :240 :@"Lain-lain - Perumahan"];
    [Option new:realm :29 :84 :241 :@"Lain-lain - Kendaraan"];
    [Option new:realm :29 :85 :242 :@"Lain-lain - Alat Rumah Tangga"];
    
    [Option new:realm :30 :0 :244 :@"Pengurus - Pemilik"];
    [Option new:realm :30 :1 :245 :@"Pemilik - Direktur Utama / Pres. Dir"];
    [Option new:realm :30 :2 :246 :@"Pemilik - Direktur"];
    [Option new:realm :30 :3 :247 :@"Pemilik - Komisaris Utama / Pres. Kom"];
    [Option new:realm :30 :4 :248 :@"Pemilik - Komisaris"];
    [Option new:realm :30 :5 :249 :@"Pemilik - Kuasa Direksi"];
    [Option new:realm :30 :6 :250 :@"Pemilik - Pemilik Bukan Pengurus"];
    [Option new:realm :30 :7 :251 :@"Pemilik - Masyarakat"];
    [Option new:realm :30 :8 :252 :@"Pemilik - Ketua Umum"];
    [Option new:realm :30 :9 :253 :@"Pemilik - Ketua"];
    [Option new:realm :30 :10 :254 :@"Pemilik - Sekretaris"];
    [Option new:realm :30 :11 :255 :@"Pemilik - Bendahara"];
    [Option new:realm :30 :12 :256 :@"Pemilik - Lainnya"];
    [Option new:realm :30 :13 :257 :@"Pengurus Bukan Pemilik"];
    [Option new:realm :30 :14 :258 :@"Bukan Pemilik - Direktur Utama / Pres. Dir"];
    [Option new:realm :30 :15 :259 :@"Bukan Pemilik - Direktur"];
    [Option new:realm :30 :16 :260 :@"Bukan Pemilik - Komisaris Utama / Pres. Kom"];
    [Option new:realm :30 :17 :261 :@"Bukan Pemilik - Komisaris"];
    [Option new:realm :30 :18 :262 :@"Bukan Pemilik - Kuasa Direksi"];
    [Option new:realm :30 :19 :263 :@"Bukan Pemilik - Ketua Umum"];
    [Option new:realm :30 :20 :264 :@"Bukan Pemilik - Ketua"];
    [Option new:realm :30 :21 :265 :@"Bukan Pemilik - Sekretaris"];
    [Option new:realm :30 :22 :266 :@"Bukan Pemilik - Bendahara"];
    [Option new:realm :30 :23 :267 :@"Bukan Pemilik - Lainnya"];
    
    [Option new:realm :31 :0 :@"12"];
    [Option new:realm :31 :1 :@"18"];
    [Option new:realm :31 :2 :@"24"];
    [Option new:realm :31 :3 :@"30"];
    [Option new:realm :31 :4 :@"36"];
    
    [Option new:realm :32 :0 :1 :@"Cabang"];
    [Option new:realm :32 :1 :2 :@"KP"];
    [Option new:realm :32 :2 :3 :@"B-Sat"];
    
    [Option new:realm :33 :0 :278 :@"Regular Fixed Installment"];
    [Option new:realm :33 :1 :279 :@"Irregular Installment"];
    [Option new:realm :33 :2 :280 :@"Step Up / Step Down"];
    [Option new:realm :33 :3 :281 :@"Basic Step up / down"];
    [Option new:realm :33 :4 :282 :@"Normal Step up / down"];
    [Option new:realm :33 :5 :283 :@"Leasing Step up / down"];
    [Option new:realm :33 :6 :284 :@"Even Principle"];
    [Option new:realm :33 :7 :285 :@"Daily Interest"];

    [Option new:realm :34 :0 :107 :@"1 Lantai"];
    [Option new:realm :34 :1 :108 :@"2 Lantai"];
    [Option new:realm :34 :2 :109 :@"3 Lantai"];
    [Option new:realm :34 :3 :110 :@"> 3 Lantai"];
    
    [Option new:realm :35 :0 :1 :@"1-2 tahun"];
    [Option new:realm :35 :1 :2 :@"2-4 tahun"];
    [Option new:realm :35 :2 :3 :@"4-5 tahun"];
    
    [Option new:realm :36 :0 :98 :@"Tetangga"];
    [Option new:realm :36 :1 :99 :@"RT / RW"];
    [Option new:realm :36 :2 :100 :@"Satpam"];
    
    [Option new:realm :37 :0 :76 :@"Yes"]; //banjir
    [Option new:realm :37 :1 :77 :@"No"];
    
    [Option new:realm :38 :0 :272 :@"Yes"]; //gempa bumi
    [Option new:realm :38 :1 :273 :@"No"];
    
    [Option new:realm :39 :0 :74 :@"Yes"]; //srcc
    [Option new:realm :39 :1 :75 :@"No"];
    
    [Option new:realm :40 :0 :78 :@"Yes"]; //tpl
    [Option new:realm :40 :1 :79 :@"No"];
    
    [Option new:realm :41 :0 :80 :@"Yes"]; //pa
    [Option new:realm :41 :1 :81 :@"No"];
    
    [Option new:realm :42 :0 :82 :@"Yes"]; //asuransi jiwa kredit
    [Option new:realm :42 :1 :83 :@"No"];
    
    [Option new:realm :43 :0 :96 :@"Yes"]; //alamat rumah ditemukan
    [Option new:realm :43 :1 :97 :@"No"];
    
    [Option new:realm :44 :0 :101 :@"Yes"]; //kebenaran domisili
    [Option new:realm :44 :1 :102 :@"No"];
    
    [Option new:realm :45 :0 :111 :@"Jalan Raya"];
    [Option new:realm :45 :1 :112 :@"Jalan Komplek"];
    [Option new:realm :45 :2 :113 :@"Jalan Desa"];
    [Option new:realm :45 :3 :114 :@"Gang Lebar"];
    [Option new:realm :45 :4 :115 :@"Gang Sempit"];
    
    [realm commitWriteTransaction];
}

+ (void)new:(RLMRealm *)realm :(NSInteger)category :(NSInteger)sort :(NSString *)name{
    [self new:realm :category :sort :-1 :name];
}

+ (void)new:(RLMRealm *)realm :(NSInteger)category :(NSInteger)sort :(NSInteger)primaryKey :(NSString *)name{
    Option *option = [[Option alloc] init];
    option.name = name;
    option.sort = sort;
    option.category = category;
    option.primaryKey = primaryKey;
    
    [realm addObject:option];
}

@end
