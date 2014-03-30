//
//  GIPostEventViewController.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/21.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIDateViewController.h"

@interface GIPostEventViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,
                                        UIPickerViewDelegate,GIDateViewControllerDelegate>
{
    GIDateViewController *dvc;
}

@property (strong, nonatomic) UITableView *mainTableView;
@property (nonatomic, retain) NSDate *date;

- (void)backToEventList:(id)sender;
@end
