//
//  GIPostTableTableViewController.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/24.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIDateViewController.h"

@interface GIPostTableViewController : UITableViewController
<GIDateViewControllerDelegate>
{
    GIDateViewController *dvc;
}

@property(nonatomic, retain) NSDate *date;

@end
