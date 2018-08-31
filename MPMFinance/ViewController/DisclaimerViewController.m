//
//  DisclaimerViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/16/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "WorkOrderModel.h"
#import "BarcodeViewController.h"
#import "SubmenuViewController.h"
#import "ReasonViewController.h"
#import "AFImageDownloader.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "WorkOrderListViewController.h"
#import "DataSource.h"
#import "HistoryViewController.h"
#import "Menu.h"
#import "AppDelegate.h"
#import "ListViewController.h"
@interface DisclaimerViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, BarcodeDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *disagreeButton;
@property (weak, nonatomic) IBOutlet UIButton *viewBarcodeButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

@property BOOL isAgree;
@property BOOL isPhotoTaken;

@end

@implementation DisclaimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:self.menu.title];
    
    if (self.isReadOnly || ([self.valueDictionary objectForKey:@"ttd"] && [[self.valueDictionary objectForKey:@"ttd"] length] > 0)) {
        if (self.isReadOnly) {
            self.submitButton.hidden = true;
            self.viewBarcodeButton.hidden = false;
        }
        self.isPhotoTaken = true;
        self.takePhotoButton.hidden = true;
      if ([self.valueDictionary objectForKey:@"pernyataanPemohon"] && [[self.valueDictionary objectForKey:@"pernyataanPemohon"] isEqual:@0]) {
        self.isAgree = false;
      } else {
        self.isAgree = true;
      }
      
        [self setRightBarButton];
        
        if ([MPMGlobal isStringAnURL:[self.valueDictionary objectForKey:@"ttd"]]) {
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.valueDictionary objectForKey:@"ttd"]]
                                                          cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                                      timeoutInterval:60];
            
            __weak typeof(self) weakSelf = self;
            [[AFImageDownloader defaultInstance] downloadImageForURLRequest:imageRequest success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                weakSelf.imageView.image = responseObject;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            }];
        } else {
            self.imageView.image = [MPMGlobal decodeFromBase64String:[self.valueDictionary objectForKey:@"ttd"]];
        }
        
    } else {
        self.submitButton.hidden = false;
        self.viewBarcodeButton.hidden = true;
        self.takePhotoButton.hidden = false;
        self.isAgree = true;
        self.isPhotoTaken = false;
    }
    
    [self refreshSelected];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *contentString = @"Pernyataan Pemohon<br/>1. Dengan ini saya menyatakan, bahwa<br/>a. MPM Finance berhak menyimpan, menggunakan, dan/atau memberikan data-data pribadi saya kepada group,afiliasi, dan konsultan (“Pihak yang Diizinkan”), baik untuk tujuan komersil yang berkaitan dengan produk dan/atau layanan dari MPM Group dan afiliasinya dan/atau tujuan lain sepanjang tidak bertentangan dengan peraturan yang berlaku. Atas persetujuan dan penggunaan data pribadi saya kepada “Pihak yang Diizinkan”, dengan ini saya menyatakan bahwa saya memahami segala konsekuensi yang terjadi di kemudian hari.<br/>b. Menerima penawaran promosi produk dan/atau layanan dari MPM Group dan afiliasinya melalui sarana komunikasi pribadi, antara lain SMS, email, voice mail, telepon dan/atau menggunakan sarana komunikasi lainnya.<br/>2. Saya menyatakan telah menerima, memahami dan mengerti semua informasi yang tertera dan mengakui bahwa data yang tertulis adalah benar.<br/>3. Saya memberikan kuasa kepada MPM Finance untuk memeriksa informasi tersebut dengan cara yang layak menurut MPM Finance.<br/>4. Bahwa data yang saya berikan adalah data yang benar, valid, dan dapat dipertanggung jawabkan secara hukum.<br/>5. Dengan melengkapi informasi dan data-data sebagaimana tersebut diatas, saya menyatakan setuju dan tunduk pada ketentuan yang berlaku pada MPM Finance.<br/><br/><b>www.mpm-finance.com</b><br/><b>Terdaftar dan Diawasi oleh Otoritas Jasa Keuangan (OJK)</b>";
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [contentString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName : [UIFont systemFontOfSize:14.0f] }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    
    self.textView.attributedText = attributedString;
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    NSString *first = self.parentMenu.primaryKey;
    NSString *second = [NSString stringWithFormat:@"%@ ",kMenuMonitoring];
    if ([first isEqualToString:second]) {
        
    }
}

- (void)setRightBarButton{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(close)];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectImage:(id)sender {
    [SVProgressHUD show];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:true completion:^{
        [SVProgressHUD dismiss];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^(void){
        self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.isPhotoTaken = true;
    }];
}

- (IBAction)agree:(id)sender {
    NSString *first = self.parentMenu.primaryKey;
    NSString *second = [NSString stringWithFormat:@"%@ ",kMenuMonitoring];
    if (self.isReadOnly) {
        return;
    }
    if (![self.parentMenu.primaryKey isEqualToString:kSubmenuListWorkOrder]) {
        self.isAgree = true;
        [self refreshSelected];
    }
}

- (IBAction)disagree:(id)sender {
    NSString *first = self.parentMenu.primaryKey;
    NSString *second = [NSString stringWithFormat:@"%@ ",kMenuMonitoring];
    if (self.isReadOnly) {
        return;
    }
    if (![self.parentMenu.primaryKey isEqualToString:kSubmenuListWorkOrder]) {
        self.isAgree = false;
        [self refreshSelected];
    }
}

- (void)refreshSelected{
    if ([self.parentMenu.primaryKey isEqualToString:kMenuMonitoring]) {
        self.agreeButton.tintColor = [UIColor grayColor];
        self.disagreeButton.tintColor = [UIColor grayColor];
    }
    if (self.isAgree) {
        self.agreeButton.selected = true;
        self.disagreeButton.selected = false;
    } else {
        self.agreeButton.selected = false;
        self.disagreeButton.selected = true;
    }
}

- (IBAction)submit:(id)sender {
    if (self.isPhotoTaken == false) {
        [SVProgressHUD showErrorWithStatus:@"Please take picture of your signature"];
        [SVProgressHUD dismissWithDelay:1.5];
    } else {
    
        __weak typeof(self) weakSelf = self;
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Apakah anda yakin dengan data yang telah anda isikan?" preferredStyle:UIAlertControllerStyleAlert];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Tidak" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Ya" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [weakSelf submitNow];
        }]];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (void)submitNow{
    [self.valueDictionary addEntriesFromDictionary:@{@"ttd" : [MPMGlobal encodeToBase64String:self.imageView.image],
                                                     @"pernyataanPemohon" : @(self.isAgree),
                                                     }];
    
    [SVProgressHUD show];
  
    [WorkOrderModel postListWorkOrder:self.list dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
        if (error == nil) {
            [SVProgressHUD dismiss];
            NSString *noRegistrasi = @"";
            @try {
                noRegistrasi = [[dictionary objectForKey:@"data"] objectForKey:@"noRegistrasi"];
            } @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
            
            __weak typeof(self) weakSelf = self;
          //if customer, no need to show stop process
          if ([[MPMUserInfo getRole] isEqualToString:kRoleCustomer] || [[MPMUserInfo getRole] isEqualToString:kRoleDealer] || [[MPMUserInfo getRole] isEqualToString:kRoleAgent]) {
            BarcodeViewController *barcodeVC = [[BarcodeViewController alloc] init];
            barcodeVC.barcodeString = noRegistrasi;
            barcodeVC.modalPresentationStyle = UIModalPresentationFullScreen;
            barcodeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            barcodeVC.delegate = weakSelf;
            
            [weakSelf presentViewController:barcodeVC animated:YES completion:nil];
            return ;
          }
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Apakah anda yakin akan melanjutkan proses?" preferredStyle:UIAlertControllerStyleAlert];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Tidak" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                ReasonViewController *reasonVC = [[ReasonViewController alloc] init];
                reasonVC.list = weakSelf.list;
                reasonVC.noRegistrasi = noRegistrasi;
                
                [weakSelf.navigationController pushViewController:reasonVC animated:YES];
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Ya" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [WorkOrderModel setStopProccessWithID:[[[dictionary objectForKey:@"data"] objectForKey:@"id"] integerValue] completion:nil];
                BarcodeViewController *barcodeVC = [[BarcodeViewController alloc] init];
                barcodeVC.barcodeString = noRegistrasi;
                barcodeVC.modalPresentationStyle = UIModalPresentationFullScreen;
                barcodeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                barcodeVC.delegate = weakSelf;
                
                [weakSelf presentViewController:barcodeVC animated:YES completion:nil];
            }]];
            
            [self presentViewController:actionSheet animated:YES completion:nil];
            
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (IBAction)viewBarcode:(id)sender {
    NSString *noRegistrasi = [self.valueDictionary objectForKey:@"noRegistrasi"];
    BarcodeViewController *barcodeVC = [[BarcodeViewController alloc] init];
    barcodeVC.barcodeString = noRegistrasi;
    barcodeVC.modalPresentationStyle = UIModalPresentationFullScreen;
    barcodeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    barcodeVC.delegate = self;
    
    [self presentViewController:barcodeVC animated:YES completion:nil];
}

- (void)close{
 
//  
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[MenuViewController class]]){
//            MenuViewController *menuVC = (MenuViewController *)vc;
//            MenuNavigationViewController *menuNavigationVC = (MenuNavigationViewController *)[menuVC getContainerViewController];
//            UIViewController *viewController = [menuNavigationVC getSelectedViewController];
//            if ([viewController isKindOfClass:HomeViewController.class]) {
//                HomeViewController *homeVC = (HomeViewController *)viewController;
//                Menu *menu = [Menu getMenuForPrimaryKey:kMenuListWorkOrder];
//                BOOL isMenuAvailable = [homeVC isMenuAvailable:menu];
//                if (isMenuAvailable) {
//                    WorkOrderListViewController *listViewController = [[WorkOrderListViewController alloc] initWithNibName:@"WorkOrderListViewController" bundle:nil];
//                    listViewController.menu = menu;
//                    listViewController.preferredType = kDataSourceTypeAll;
//                    [self.navigationController setViewControllers:@[vc, listViewController] animated:NO];
//
//                    return;
//                }
//            }
//        }
//    }
  NSArray *vcs = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[SubmenuViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
          return;
        } else if ([vc isKindOfClass:[ListViewController class]]) {
          [self.navigationController popToViewController:vc animated:NO];
          return;
        }
    }
  
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Barcode Delegate
- (void)finish{
  
  if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated] && ([self.list.status isEqualToString:@"Draft"] || [self.list.status isEqualToString:@"Draft Tidak Lengkap"] || !self.list.status)) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        UINavigationController *mainNavigation = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        WorkOrderListViewController *listViewController2 = [[WorkOrderListViewController alloc] initWithNibName:@"WorkOrderListViewController" bundle:nil];
        listViewController2.menu = [Menu getMenuForPrimaryKey:kMenuListWorkOrder];
        [mainNavigation pushViewController:listViewController2 animated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = mainNavigation;
        return;
  }
  else if (self.needToShowWorkOrder) {
    [self close];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    UINavigationController *mainNavigation = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
//    WorkOrderListViewController *listViewController2 = [[WorkOrderListViewController alloc] initWithNibName:@"WorkOrderListViewController" bundle:nil];
//    listViewController2.menu = [Menu getMenuForPrimaryKey:kMenuListWorkOrder];
//    SubmenuViewController *submenuViewController = [[SubmenuViewController alloc] init];
//    submenuViewController.menu = self.menu;
//    submenuViewController.list = self.list;
//    [mainNavigation pushViewController:listViewController2 animated:YES];
//    [mainNavigation pushViewController:submenuViewController animated:YES];
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.window.rootViewController = mainNavigation;
//    return;
  } else if (self.isFromMonitoring) {
    UIViewController *vc = self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:vc animated:YES];
  } else if(self.isFromHistory) {
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
   else if (![self.parentMenu.primaryKey isEqualToString:kSubmenuListWorkOrder]) {
        if ([[MPMUserInfo getRole] isEqualToString:kRoleCustomer] || [[MPMUserInfo getRole] isEqualToString:kRoleDealer] || [[MPMUserInfo getRole] isEqualToString:kRoleAgent]) {
            NSArray *viewControllers = self.navigationController.viewControllers;
            
            [self.navigationController popToViewController:viewControllers[1] animated:YES];
        } else {
            [self close];
        }
    }
    else {
        [self close];
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
