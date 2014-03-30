//
//  GIAppDelegate.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/21.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GIAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation GIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //GoogleMap認証
    [GMSServices provideAPIKey:@"AIzaSyD4RpJ-91iQq3EvQYuLNCxGqYugKbJZUwk"];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - SDPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"paymentQuere:updatedTransactions");
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
                //購入処理中
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"購入厨");
                break;
                
            case SKPaymentTransactionStatePurchased:
                NSLog(@"購入完了");
                //購入後処理
                
                //プロダクトIDの保持
                [[NSUserDefaults standardUserDefaults] setBool:YES
                                                        forKey:transaction.payment.productIdentifier];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //購入処理成功を通知する
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Purchased" object:transaction];
                
                [queue finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                
                NSLog(@"SKPaymentTransactonStateRestored");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:transaction.payment.productIdentifier];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Purchased" object:transaction];
                [queue finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"購入失敗");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Failed" object:transaction];
                [queue finishTransaction:transaction];
                
                //エラーメッセージ
                NSError *error = transaction.error;
                NSString *errormsg = [NSString stringWithFormat:@"%@ [%d]", error.localizedDescription, error.code];
                [[[UIAlertView alloc] initWithTitle:@"エラー" message:errormsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
                //エラー詳細
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    NSLog(@"SKPaymentTransactionStateFailed"
                          "- SKErrorPaymentCancelled");
                    
                }
                
                //請求先情報画面に移り、購入処理が強制終了した
                else if (transaction.error.code == SKErrorUnknown)
                {
                    NSLog(@"SKPaymentTransactionStateFailed""- SKErrorUnknown");
                }
                else{
                    NSLog(@"SKPaymentTransactionStateFailed -error.coe:%d", transaction.error.code);
                }
                break;
                //            default:
                //                break;
        }
    }
    
}

@end
