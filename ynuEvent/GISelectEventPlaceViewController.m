//
//  GISelectEventPlaceViewController.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/22.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GISelectEventPlaceViewController.h"
#import "AFNetworking.h"
#import <MBProgressHUD.h>

@interface GISelectEventPlaceViewController ()

@end

@implementation GISelectEventPlaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        btnRegister = [[UIBarButtonItem alloc] initWithTitle:@"登録"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(PostButtonOnTouch:)];
        self.navigationItem.rightBarButtonItem = btnRegister;
        
        btnBack = [[UIBarButtonItem alloc] initWithTitle:@"戻る"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(backPostEventView:)];
        self.navigationItem.leftBarButtonItem = btnBack;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"場所の指定" message:@"イベントが行われる位置をタップして下さい"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    
    [self initialLoad];
    
    //プロダクトの購入済みか判定
    BOOL isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"ConsumableProduct"];
    if (isPurchased == YES) {
        //購入済みの初期化
    }
    else{
        //アプリ内課金プロダクト情報を取得する
        myProduct = nil;
        NSSet *productIds = [NSSet setWithObject:@"PostEvent100en"];
        myProductRequest =
        [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
        
        myProductRequest.delegate = self;
        
        NSLog(@"start");
        [myProductRequest start];
    }
}

#define LAT_YNU 35.4738828
#define LON_YNU 139.589725

- (void)initialLoad{

    //マップの初期位置とか
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:LAT_YNU
                                                            longitude:LON_YNU
                                                                 zoom:16];
    self.mapView.camera = camera;
    self.mapView.delegate = self;
    self.mapView.settings.compassButton = YES;

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchased:) name:@"Purchased" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToPurchase:) name:@"Failed" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Purchased" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Failed" object:nil];
    
}


#pragma mark - 通知(NSNotificationCenter)
- (void)purchased:(NSNotification *)notification
{
    
    [self PostEventData:nil];
}

- (void)failedToPurchase:(NSNotificationCenter *)notification
{
    [self setEnableButton:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark -

- (void)PostButtonOnTouch:(id)sender
{
    NSLog(@"postbtnTouch");
    
//#warning あとで戻す
//    [self PostEventData:nil];
    //機能制限チェックを行う
    if ([SKPaymentQueue canMakePayments] == NO) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"購入できません"
                                   message:@"App内の購入が機能制限されています"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //購入用ペイメントを生成
    SKPayment *payment = [SKPayment paymentWithProduct:myProduct];
    //SKPaymentQuereに追加=トランザクションの開始
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setEnableButton:NO];
 
}

//ボタンの機能制限
- (void)setEnableButton:(BOOL)isEnable
{
    btnBack.enabled = isEnable;
    btnRegister.enabled = isEnable;
}

- (IBAction)backPostEventView:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//#define SERVERURL @"http://localhost:3000"
//#define SERVERURL @"http://planet-meron.com:2001"

#define TAG_ALERT_POSTCOMPLETE 10

- (IBAction)PostEventData:(UIBarButtonItem *)sender {
    
    NSLog(@"postEventData");
    if (!_marker) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置の取得失敗"
                                                        message:@"イベントをする場所を\nタップして下さい"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    //HTTP通信クライアントの作製
    static AFHTTPClient *sharedCliant = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedCliant = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVERURL]];
    });
    
    NSString *path = [NSString stringWithFormat:@"events.json"];//パスの指定
    
    //パラメータの設置
    NSString *lon, *lat;
    lon = [NSString stringWithFormat:@"%f", _marker.position.longitude];
    lat = [NSString stringWithFormat:@"%f", _marker.position.latitude];
    [self.params setObject:lon forKey:@"event[longitude]"];
    [self.params setObject:lat forKey:@"event[latitude]"];
    
    [sharedCliant setParameterEncoding:AFFormURLParameterEncoding];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[sharedCliant requestWithMethod:@"POST" path:path parameters:self.params]
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                                            
                                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                            //通信が成功したときの処理
                                                                                            NSLog(@"request : %@, response : %@", request, response);
                                                                                            NSLog(@"JSON: %@", JSON);
//                                                                                            [self dismissViewControllerAnimated:YES completion:^(void){
//                                                                                                
//                                                                                            }];
                                                                                            
                                                                                            
                                                                                            
                                                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登録完了"
                                                                                                                                            message:@"イベントの登録が完了しました"
                                                                                                                                           delegate:self
                                                                                                                                  cancelButtonTitle:@"OK"
                                                                                                                                  otherButtonTitles: nil];
                                                                                            alert.tag = TAG_ALERT_POSTCOMPLETE;
                                                                                            [alert show];
                                                                                            
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,NSError *error, id JSON){
                                                                                            
                                                                                            //通信が失敗した時の処理
                                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                            NSLog(@"error: %@", error);
                                                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登録失敗"
                                                                                                                                            message:@"イベントの登録に失敗しました。b0941015@gmail.comまでご連絡下さい"
                                                                                                                                           delegate:nil
                                                                                                                                  cancelButtonTitle:@"閉じる"
                                                                                                                                  otherButtonTitles: nil];
                                                                                            [alert show];
                                                                                            [self setEnableButton:YES];
                                                                                            
                                                                                        }];
    
    [sharedCliant enqueueHTTPRequestOperation:operation];//通信開始
}

#pragma GMSMapView Delegate
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (!_marker) {
        
        //マーカー
        _marker = [[GMSMarker alloc] init];
        _marker.position = CLLocationCoordinate2DMake(LAT_YNU, LON_YNU);
        _marker.title = [self.params objectForKey:@"event[title]"];
        
        //日付
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";

        NSDate* formatterDate = [df dateFromString:[self.params objectForKey:@"event[eDate]"]];
        NSLog(@"date]%@", formatterDate);
        [df setDateFormat:@"yyyy年M月d日 H:m~"];
        NSString *strTemp = [NSString stringWithFormat:@"場所:%@\n日時:%@\n%@",
                             [self.params objectForKey:@"event[spot]"],
                             [df stringFromDate:formatterDate],
                             [self.params objectForKey:@"event[body]"]];
        _marker.snippet = strTemp;
        _marker.map = self.mapView;
    }

    _marker.position = coordinate;
}

#pragma mark - SKProductRequestDelegate
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (response == nil) {
        NSLog(@"didReceiveResponse response == nil");
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"エラー"
                                   message:@"購入できるものがありません"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    for (NSString *identifer in response.invalidProductIdentifiers) {
        NSLog(@"invalidProductIdentifiers : %@", identifer);
    }
    
    for (SKProduct *product in response.products) {
        NSLog(@"Product : %@ %@ %@ %d",
              product.productIdentifier,
              product.localizedTitle,
              product.localizedDescription,
              [product.price intValue]
              );
        
        myProduct = product;
    }
    
    //商品情報無し
    if (myProduct == nil) {
        NSLog(@"myProduct == nil");
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"エラー"
                                   message:@"購入できるものがありません"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAG_ALERT_POSTCOMPLETE) {
        [self dismissViewControllerAnimated:YES completion:^(void){
            NSDictionary *dic = [NSDictionary dictionaryWithObject:_marker forKey:@"newMarker"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostComplete" object:self userInfo:dic];
        }];

    }

}


@end
