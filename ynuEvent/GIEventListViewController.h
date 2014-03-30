//
//  GIEventListViewController.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/21.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIEventListViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate,
 UIAlertViewDelegate>
{
    UIBarButtonItem *btnBack, *btnRegister;
}

@property (nonatomic, retain) NSMutableArray *events;
@property (nonatomic, retain) NSMutableArray *eventsForTable;
- (IBAction)backToMap:(id)sender;
- (IBAction)goToRegisterView:(UIBarButtonItem *)sender;

@end
