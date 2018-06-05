//
//  ProductViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/24/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductCollectionViewCell.h"
#import "ProductDetailViewController.h"
@interface ProductViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *products;
@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.collectionView registerClass:[ProductCollectionViewCell self] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self downloadData];
    // Do any additional setup after loading the view from its nib.
}
- (void)downloadData {
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
  //  NSDictionary * parameter = @{ @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            //      @"token" : [MPMUserInfo getToken]};
    [manager POST:[NSString stringWithFormat:@"%@/product",kApiUrl] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.products = responseObject[@"data"];
            [self.collectionView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _products.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"product-%li",(long)indexPath.row]]];
    cell.title.text = _products[indexPath.row][@"desc"];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
    detailVC.contentString = self.products[indexPath.row][@"description"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
 
 "id": 3,
 "desc": "New Car",
 "desc_id": "Pembiayaan Mobil Baru",
 "description": "<div><strong>Pembiayaan Mobil Baru</strong></div>\r\n\r\n<div>&nbsp;</div>\r\n\r\n<div>Menyadari tingginya kebutuhan masyarakat akan mobil pribadi, MPM Finance menyediakan fasilitas pembiayaan mobil dalam kondisi baru. Diperkuat dengan jaringan authorized dealer yang luas, setiap konsumen akan semakin mudah untuk membeli unit mobil idaman. MPM Finance menawarkan struktur pembiayaan yang kompetitif, suku bunga tetap, dengan proses pengajuan pembiayaan yang mudah dan cepat. Selain itu, MPM Finance memiliki keamanan yang sangat baik untuk penyimpanan BPKB kendaraan.</div>\r\n\r\n<div>&nbsp;</div>\r\n\r\n<div>Adapun detail pengajuan untuk Pembiayaan Mobil Baru yaitu</div>\r\n\r\n<ol>\r\n\t<li>Jenis Mobil Yang Dibiayai :</font></font>\r\n\r\n\t<ul>\r\n\t\t<li>Pribadi (Sedan/jeep/minibus)</li>\r\n\t\t<li>Pick Up</li>\r\n\t\t<li>Truck</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Minimum Uang Muka\r\n\t<ul>\r\n\t\t<li>20% untuk kendaraan pribadi</li>\r\n\t\t<li>25% untuk pick up dan truck</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Jangka Waktu Pembiayaan\r\n\t<ul>\r\n\t\t<li>12 &ndash; 60&nbsp;bulan</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Syarat &amp; Ketentuan\r\n\t<ul>\r\n\t\t<li>\r\n\t\t<div>Usia minimum 21 tahun atau sudah menikah dan memiliki penghasilan sendiri.</div>\r\n\t\t</li>\r\n\t\t<li>\r\n\t\t<div>Usia maksimum 60 tahun saat masa kredit selesai</div>\r\n\t\t</li>\r\n\t\t<li>\r\n\t\t<div>Warga Negara Indonesia (WNI)</div>\r\n\t\t</li>\r\n\t\t<li>\r\n\t\t<div>Tidak masuk dalam daftar bad debt/negative list APPI dan/atau MPM Finance.</div>\r\n\t\t</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Biaya Yang Dikenakan\r\n\t<ul>\r\n\t\t<li>Biaya Administrasi</li>\r\n\t\t<li>Biaya Asuransi (premi asuransi dan polis)</li>\r\n\t\t<li>Biaya Provisi</li>\r\n\t\t<li>Biaya Fidusia</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Dokumen Yang Perlu Disiapkan</li>\r\n</ol>\r\n\r\n<ul>\r\n\t<li>Pribadi:\r\n\t<ul>\r\n\t\t<li>Formulir Permohon Pembiayaan (FPP) yang telah dilengkapi</li>\r\n\t\t<li>Fotokopi KTP konsumen dan pasangan</li>\r\n\t\t<li>Fotokopi Kartu Keluarga</li>\r\n\t\t<li>Fotokopi NPWP</li>\r\n\t\t<li>Fotokopi PBB / rekening listrik 3 bulan terakhir</li>\r\n\t\t<li>Fotokopi rekening tabungan 3 bulan terakhir/ rekening koran / Nota/ kwitansi pembayaran</li>\r\n\t\t<li>Asli slip gaji / Surat Keterangan Kerja</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Badan Usaha :\r\n\t<ul>\r\n\t\t<li>Fotokopi izin usaha (SIUP / TDP) / SPPT terakhir</li>\r\n\t\t<li>Surat Keterangan Domisili</li>\r\n\t\t<li>Fotokopi Akta Pendirian Perusahaan dan perubahannya</li>\r\n\t\t<li>Fotokopi Akta Pengesahan Kementerian Hukum dan HAM</li>\r\n\t\t<li>Fotokopi identitas komisaris dan direksi</li>\r\n\t</ul>\r\n\t</li>\r\n</ul>\r\n",
 "description_id": "<div><strong>Pembiayaan Mobil Baru</strong></div>\r\n\r\n<div>&nbsp;</div>\r\n\r\n<div>Menyadari tingginya kebutuhan masyarakat akan mobil pribadi, MPM Finance menyediakan fasilitas pembiayaan mobil dalam kondisi baru. Diperkuat dengan jaringan authorized dealer yang luas, setiap konsumen akan semakin mudah untuk membeli unit mobil idaman. MPM Finance menawarkan struktur pembiayaan yang kompetitif, suku bunga tetap, dengan proses pengajuan pembiayaan yang mudah dan cepat. Selain itu, MPM Finance memiliki keamanan yang sangat baik untuk penyimpanan BPKB kendaraan.</div>\r\n\r\n<div>&nbsp;</div>\r\n\r\n<div>Adapun detail pengajuan untuk Pembiayaan Mobil Baru yaitu</div>\r\n\r\n<ol>\r\n\t<li>Jenis Mobil Yang Dibiayai :</font></font>\r\n\r\n\t<ul>\r\n\t\t<li>Pribadi (Sedan/jeep/minibus)</li>\r\n\t\t<li>Pick Up</li>\r\n\t\t<li>Truck</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Minimum Uang Muka\r\n\t<ul>\r\n\t\t<li>20% untuk kendaraan pribadi</li>\r\n\t\t<li>25% untuk pick up dan truck</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Jangka Waktu Pembiayaan\r\n\t<ul>\r\n\t\t<li>12 &ndash; 60&nbsp;bulan</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Syarat &amp; Ketentuan\r\n\t<ul>\r\n\t\t<li>\r\n\t\t<div>Usia minimum 21 tahun atau sudah menikah dan memiliki penghasilan sendiri.</div>\r\n\t\t</li>\r\n\t\t<li>\r\n\t\t<div>Usia maksimum 60 tahun saat masa kredit selesai</div>\r\n\t\t</li>\r\n\t\t<li>\r\n\t\t<div>Warga Negara Indonesia (WNI)</div>\r\n\t\t</li>\r\n\t\t<li>\r\n\t\t<div>Tidak masuk dalam daftar bad debt/negative list APPI dan/atau MPM Finance.</div>\r\n\t\t</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Biaya Yang Dikenakan\r\n\t<ul>\r\n\t\t<li>Biaya Administrasi</li>\r\n\t\t<li>Biaya Asuransi (premi asuransi dan polis)</li>\r\n\t\t<li>Biaya Provisi</li>\r\n\t\t<li>Biaya Fidusia</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Dokumen Yang Perlu Disiapkan</li>\r\n</ol>\r\n\r\n<ul>\r\n\t<li>Pribadi:\r\n\t<ul>\r\n\t\t<li>Formulir Permohon Pembiayaan (FPP) yang telah dilengkapi</li>\r\n\t\t<li>Fotokopi KTP konsumen dan pasangan</li>\r\n\t\t<li>Fotokopi Kartu Keluarga</li>\r\n\t\t<li>Fotokopi NPWP</li>\r\n\t\t<li>Fotokopi PBB / rekening listrik 3 bulan terakhir</li>\r\n\t\t<li>Fotokopi rekening tabungan 3 bulan terakhir/ rekening koran / Nota/ kwitansi pembayaran</li>\r\n\t\t<li>Asli slip gaji / Surat Keterangan Kerja</li>\r\n\t</ul>\r\n\t</li>\r\n\t<li>Badan Usaha :\r\n\t<ul>\r\n\t\t<li>Fotokopi izin usaha (SIUP / TDP) / SPPT terakhir</li>\r\n\t\t<li>Surat Keterangan Domisili</li>\r\n\t\t<li>Fotokopi Akta Pendirian Perusahaan dan perubahannya</li>\r\n\t\t<li>Fotokopi Akta Pengesahan Kementerian Hukum dan HAM</li>\r\n\t\t<li>Fotokopi identitas komisaris dan direksi</li>\r\n\t</ul>\r\n\t</li>\r\n</ul>\r\n",
 "jumlah": 0,
 "selected": "",
 "imageIcon": "https://www.mpm-finance.com/assets/img/produk/android/new_car_product_2.png",
 "imageIconIos": "https://www.mpm-finance.com/assets/img/produk/android/new_car_product_2.png"
 }
 */
@end
