//
//  ResultCalculatorViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 30/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ResultCalculatorViewController.h"
#import "ResultTableViewCell.h"
#import "ResultTableData.h"

@interface ResultCalculatorViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *dataSources;

@end

@implementation ResultCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.dataSources = [NSMutableArray array];
    [self setupDataSources];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ResultTableData *data = [self.dataSources objectAtIndex:indexPath.row];
    if (data) {
        [cell setupCellWithData:data];
    }
    
    return cell;
}

- (void)setupDataSources{
    //Setting Rate
    [self addDataWithLeft:@"Setting Rate" middle:@"" right:@"" type:ResultTableDataTypeHeader];
    [self addDataWithLeft:@"Rate" middle:[self.requestDictionary objectForKey:@"rate"] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Tenor" middle:[self.requestDictionary objectForKey:@"tenor"] right:@"Bulan" type:ResultTableDataTypeRightTextAlignmentLeft];
    [self addDataWithLeft:@"Supplier Rate" middle:[NSString stringWithFormat:@"%@%%",[self.requestDictionary objectForKey:@"supplierRate"]] right:@"Efektif" type:ResultTableDataTypeRightTextAlignmentLeft];
    [self addDataWithLeft:@"Tipe Pembayaran" middle:[self.requestDictionary objectForKey:@"tipePembayaran"] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Supplier Rate" middle:[NSString stringWithFormat:@"%@%%",[self.responseDictionary objectForKey:@"supplier_Rate"]] right:@"flat per tahun" type:ResultTableDataTypeRightTextAlignmentLeft];
    [self addDataWithLeft:@"Refund Bunga" middle:[NSString stringWithFormat:@"%@%%",[self.requestDictionary objectForKey:@"refundBunga"]] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Refund Asuransi" middle:[NSString stringWithFormat:@"%@%%",[self.requestDictionary objectForKey:@"refundAsuransi"]] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Running Rate" middle:[NSString stringWithFormat:@"%@%%",[self.responseDictionary objectForKey:@"running_Rate"]] right:@"flat per tahun" type:ResultTableDataTypeRightTextAlignmentLeft];
    [self addDataWithLeft:@"Biaya Provisi" middle:[NSString stringWithFormat:@"%@%%",[self.requestDictionary objectForKey:@"uppingProvisi"]] right:[self.requestDictionary objectForKey:@"biayaProvisi"] type:ResultTableDataTypeRightTextAlignmentLeft];
    [self addDataWithLeft:@"Upping Provisi" middle:[NSString stringWithFormat:@"%@%%",[self.requestDictionary objectForKey:@"uppingProvisi"]] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Opsi Asuransi Jiwa" middle:[self.requestDictionary objectForKey:@"opsiAsuransiJiwa"] right:[self.requestDictionary objectForKey:@"opsiAsuransiJiwaKapitalisasi"] type:ResultTableDataTypeRightTextAlignmentLeft];
    [self addDataWithLeft:@"Opsi Biaya Admin" middle:[self.requestDictionary objectForKey:@"opsiBiayaAdministrasi"] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Opsi Biaya Fidusia" middle:[self.requestDictionary objectForKey:@"opsiBiayaFidusia"] right:[self.requestDictionary objectForKey:@"opsiBiayaFidusiaKapitalisasi"] type:ResultTableDataTypeRightTextAlignmentLeft];
    [self addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal];
    
    //Asuransi Kendaraan
    [self addDataWithLeft:@"Asuransi Kendaraan" middle:@"" right:@"" type:ResultTableDataTypeHeader];
    [self addDataWithLeft:@"Wilayah" middle:@"" right:[self.requestDictionary objectForKey:@"wilayahAsuransiKendaraan"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Opsi Premi" middle:@"" right:[self.requestDictionary objectForKey:@"opsiPremi"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Pertanggungan" middle:@"" right:[self.requestDictionary objectForKey:@"pertanggungan"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Opsi Asuransi" middle:@"" right:[self.requestDictionary objectForKey:@"opsiAsuransiKendaraan"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Penggunaan" middle:@"" right:[self.requestDictionary objectForKey:@"penggunaan"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Nilai Tunai Sebagian" middle:@"" right:[self.requestDictionary objectForKey:@"nilaiTunaiSebagian"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal];
    
    //Struktur Pembiayaan
    [self addDataWithLeft:@"Struktur Pembiayaan" middle:@"" right:@"" type:ResultTableDataTypeHeader];
    [self addDataWithLeft:@"Harga OTR Kendaraan" middle:@"" right:[self.requestDictionary objectForKey:@"otrKendaraan"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Uang Muka" middle:[self.requestDictionary objectForKey:@"dpPercentage"] right:[self.requestDictionary objectForKey:@"dpRupiah"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Pokok Hutang" middle:@"" right:[self.requestDictionary objectForKey:@"pokokHutang"] type:ResultTableDataTypeNormal];
    
    [self addDataWithLeft:@"Biaya Kapitalisasi" middle:@"" right:@"" type:ResultTableDataTypeBold];
    [self addDataWithLeft:@"1. Biaya Administrasi" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_kapitalisasi_biaya_administrasi"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"2. Asuransi Kendaraan" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_kapitalisasi_asuransi_kendaraan"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"3. Polis Asuransi Kendaraan" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_kapitalisasi_polis_asuransi_kendaraan"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"4. Biaya Provisi" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_kapitalisasi_biaya_provisi"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"5. Asuransi Jiwa" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_kapitalisasi_asuransi_jiwa"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"6. Polis Asuransi Jiwa" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_kapitalisasi_polis_asuransi_jiwa"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"7. Biaya Fidusia" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_kapitalisasi_biaya_fidusia"] type:ResultTableDataTypeNormal];
    
    [self addDataWithLeft:@"Biaya Tunai" middle:@"" right:@"" type:ResultTableDataTypeBold];
    [self addDataWithLeft:@"1. Biaya Administrasi" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_administrasi_biaya_tunai"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"2. Asuransi Kendaraan" middle:@"" right:[self.responseDictionary objectForKey:@"asuransi_kendaraan_biaya_tunai"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"3. Polis Asuransi Kendaraan" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_polis_ass_kendaraan_biaya_tunai"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"4. Biaya Provisi" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_provisi_biaya_tunai"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"5. Biaya Fidusia" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_fidusia_biaya_tunai"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"6. Biaya Survey (Jika ada)" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_survey_biaya_tunai"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"7. Biaya Cek/Blokir BPKB" middle:@"" right:[self.responseDictionary objectForKey:@"biaya_cek_blokir_bpkp_biaya_tunai"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"8. Asuransi Jiwa" middle:@"" right:[self.responseDictionary objectForKey:@"asuransi_jiwa_biaya_tunai"] type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"9. Polis Asuransi Jiwa" middle:@"" right:[self.responseDictionary objectForKey:@"polis_asuransi_jiwa_biaya_tunai"] type:ResultTableDataTypeNormal];
    
    [self addDataWithLeft:@"Total Uang Muka (TDP)" middle:@"" right:[self.responseDictionary objectForKey:@"total_uang_muka_biaya_tunai"] type:ResultTableDataTypeBold];
    [self addDataWithLeft:@"Pembayaran (Disburse)" middle:@"" right:[self.responseDictionary objectForKey:@"pembayaran_disbure"] type:ResultTableDataTypeBold];
    [self addDataWithLeft:@"Nil Pertanggungan Ass Jiwa" middle:@"" right:[self.responseDictionary objectForKey:@"nilai_pertanggunggan_asuransi_jiwa"] type:ResultTableDataTypeBold];
    [self addDataWithLeft:@"NTF Kapitalisasi" middle:@"" right:[self.responseDictionary objectForKey:@"ntf_kapitalisasi"] type:ResultTableDataTypeBold];
    [self addDataWithLeft:@"Angsuran Per Bulan" middle:[NSString stringWithFormat:@"(%lix)", (long) [[self.responseDictionary objectForKey:@"angsuran_perbulan_2"] integerValue]] right:[self.responseDictionary objectForKey:@"angsuran_perbulan"] type:ResultTableDataTypeBold];
    [self addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal];
    
    //Refund Bunga
    [self addDataWithLeft:@"Refund Bunga" middle:@"" right:@"" type:ResultTableDataTypeHeader];
    [self addDataWithLeft:@"% Refund" middle:[NSString stringWithFormat:@"%@%%", [self.responseDictionary objectForKey:@"presentase_refund_bunga"]] right:@"flat per tahun" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Running Rate" middle:[NSString stringWithFormat:@"%@%%", [self.responseDictionary objectForKey:@"running_rate_refund_bunga"]] right:@"flat per tahun" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Gross Refund" middle:[self.responseDictionary objectForKey:@"gross_refund_refund_bunga"] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal];
    
    //Refund Provisi
    [self addDataWithLeft:@"Refund Provisi" middle:@"" right:@"" type:ResultTableDataTypeHeader];
    [self addDataWithLeft:@"% Refund" middle:[NSString stringWithFormat:@"%@%%", [self.responseDictionary objectForKey:@"refund_provisi"]] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Gross Refund" middle:[self.responseDictionary objectForKey:@"gross_refund_refund_provisi"] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal];
    
    //Refund Asuransi
    [self addDataWithLeft:@"Refund Asuransi" middle:@"" right:@"" type:ResultTableDataTypeHeader];
    [self addDataWithLeft:@"% Refund" middle:[NSString stringWithFormat:@"%@%%", [self.responseDictionary objectForKey:@"refund_asuransi"]] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"Gross Refund" middle:[self.responseDictionary objectForKey:@"gross_refund_refund_asuransi"] right:@"" type:ResultTableDataTypeNormal];
    [self addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal];
    
    [self addDataWithLeft:@"Maks. Refund" middle:@"" right:[self.responseDictionary objectForKey:@"maks_refund"] type:ResultTableDataTypeSummary];
}

- (void)addDataWithLeft:(NSString *)left middle:(NSString *)middle right:(NSString *)right type:(ResultTableDataType)type{
    @try {
        ResultTableData *data = [[ResultTableData alloc] init];
        data.leftString = left;
        data.middleString = middle;
        data.rightString = right;
        data.type = type;
        [self.dataSources addObject:data];
        
    } @catch(NSException *exception) {
        NSLog(@"%@", exception);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
