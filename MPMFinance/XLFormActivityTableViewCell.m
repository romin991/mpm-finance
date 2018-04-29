//
//  XLFormActivityTableViewCell.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/29/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "XLFormActivityTableViewCell.h"
NSString * const XLFormRowDescriptorTypeFormActivity = @"XLFormRowDescriptorTypeFormActivity";
@interface XLFormActivityTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *txtInsSeq;
@property (weak, nonatomic) IBOutlet UILabel *txtMulaiTempo;
@property (weak, nonatomic) IBOutlet UILabel *txtAkhirTempo;
@property (weak, nonatomic) IBOutlet UILabel *txtPembayaranDiterima;
@property (weak, nonatomic) IBOutlet UILabel *txtTanggalBayar;
@property (weak, nonatomic) IBOutlet UILabel *txtCicilan;
@property (weak, nonatomic) IBOutlet UILabel *txtLcDays;
@property (weak, nonatomic) IBOutlet UILabel *txtJumlahLc;
@property (weak, nonatomic) IBOutlet UILabel *txtCaraBayar;
@property (weak, nonatomic) IBOutlet UILabel *txtNomorTTR;

@end

@implementation XLFormActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([XLFormActivityTableViewCell class]) forKey:XLFormRowDescriptorTypeFormActivity];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return 330.0f;
}

- (void)configure
{
    [super configure];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rowDescriptor.height = 301.0f;
}

- (void)update
{
    [super update];
    NSDictionary *value = self.rowDescriptor.value;
    self.txtInsSeq.text = [value[@"insSeqNo"] stringValue];
    self.txtLcDays.text = [value[@"totLCDays"] stringValue];
    self.txtCicilan.text = [MPMGlobal formatToMoney:value[@"installmentAmount"]];
    self.txtJumlahLc.text = [MPMGlobal formatToMoney:value[@"totLCAmount"]];
    self.txtNomorTTR.text = value[@"ttrno"];
    self.txtCaraBayar.text = value[@"wop"];
    self.txtAkhirTempo.text = value[@"maturityDate"];
    self.txtMulaiTempo.text = value[@"duedate"];
    self.txtTanggalBayar.text = value[@"paidDate"];
    self.txtPembayaranDiterima.text = [MPMGlobal formatToMoney:value[@"totalOutstandingInstallment"]];
    NSLog(@"value %@",value);
}

@end
