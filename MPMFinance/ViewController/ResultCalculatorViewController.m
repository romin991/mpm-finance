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
#import "AgreementCardViewController.h"
@interface ResultCalculatorViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *agreementButton;


@end

@implementation ResultCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    if (self.dataSources.count == 0) self.dataSources = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated {
  self.agreementButton.hidden = !self.isDahsyat;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}
- (IBAction)lihatAgreement:(id)sender {
  AgreementCardViewController *vc = [[AgreementCardViewController alloc] init];
  vc.dataSources = [self setupDataSourcesRequest2:self.requestDictionary response:self.responseDictionary];
  [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ResultTableData *data = [self.dataSources objectAtIndex:indexPath.row];
    if (data) {
        [cell setupCellWithData:data];
    }
    
    return cell;
}
- (NSString *)getTanggalAngsuranFor:(NSInteger )index withBulanPencairan:(NSString *)bulanPencairan {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"MMMM yyyy";
  [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
  NSDate *bulanPencairanDate = [formatter dateFromString:bulanPencairan];
  if (bulanPencairanDate) {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:index];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:bulanPencairanDate options:0];
    return [formatter stringFromDate:newDate];
  }
  else {
    return @"";
  }
}
- (NSMutableArray *)setupDataSourcesRequest2:(NSDictionary *)requestDictionary response:(NSDictionary *)responseDictionary{
  NSMutableArray *dataSources = [NSMutableArray array];
  
  [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
  
  //Perincian
  //[dataSources addObject:[ResultTableData addDataWithLeft:@"Perincian" middle:@"" right:@"" type:ResultTableDataTypeHeader]];
  [dataSources addObject:[ResultTableData addDataWithLeft:@"Bulan Pencairan" middle:[requestDictionary objectForKey:@"bulanPencairan"] right:@"" type:ResultTableDataTypeNormal]];
  [dataSources addObject:[ResultTableData addDataWithLeft:@"Pokok Hutang" middle:[responseDictionary objectForKey:@"ntfKapitalisasi"] right:@"" type:ResultTableDataTypeNormal]];
  [dataSources addObject:[ResultTableData addDataWithLeft:@"Nilai Pencairan" middle:[responseDictionary objectForKey:@"disburse"] right:@"" type:ResultTableDataTypeNormal]];
  [dataSources addObject:[ResultTableData addDataWithLeft:@"Angsuran Ke-" middle:@"Tanggal Jatuh Tempo" right:@"Nilai Angsuran" type:ResultTableDataTypeNormal]];
  NSInteger total = 0;
  for (int i=0; i< [requestDictionary[@"tenor"] integerValue]; i++) {
    [dataSources addObject:[ResultTableData addDataWithLeft:[NSString stringWithFormat:@"%i",(i)] middle:[self getTanggalAngsuranFor:(i+1) withBulanPencairan:[requestDictionary objectForKey:@"bulanPencairan"]] right:[responseDictionary objectForKey:@"installment"] type:ResultTableDataTypeNormal]];
    total += [[responseDictionary[@"installment"] stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];
  }
  
  [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"Total" right:[MPMGlobal formatToMoney:@(total)] type:ResultTableDataTypeNormal]];
  
  return dataSources;
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
