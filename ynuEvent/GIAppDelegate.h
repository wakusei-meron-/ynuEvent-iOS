//
//  GIAppDelegate.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/21.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface GIAppDelegate : UIResponder
<UIApplicationDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) UIWindow *window;

@end
