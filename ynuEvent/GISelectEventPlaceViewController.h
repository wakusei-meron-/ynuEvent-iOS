//
//  GISelectEventPlaceViewController.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/22.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <StoreKit/StoreKit.h>

#import "GIDateViewController.h"

@interface GISelectEventPlaceViewController : UIViewController
<GMSMapViewDelegate, SKProductsRequestDelegate, UIAlertViewDelegate>
{
    GMSMarker *_marker;
    GIDateViewController *dvc;
    
    //ボタン
    UIBarButtonItem *btnBack, *btnRegister;
    
    //課金関連
    SKProduct *myProduct;
    SKProductsRequest *myProductRequest;
}
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, retain) NSMutableDictionary *params;
- (IBAction)backPostEventView:(id)sender;
- (IBAction)PostEventData:(UIBarButtonItem *)sender;


@end
