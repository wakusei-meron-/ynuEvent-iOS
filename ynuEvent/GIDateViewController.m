//
//  GIDateViewController.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/22.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GIDateViewController.h"

@interface GIDateViewController ()

@end

@implementation GIDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"日付の指定";

        
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithTitle:@"決定"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(backPostView:)];
        self.navigationItem.leftBarButtonItem = btnBack;
//        [self.navigationItem.leftBarButtonItem.target addTarget:self action:@selector(backPostView:)];
    }
    return self;
}

- (void)viewDidLoad
{
    self.datePicker.minuteInterval = 10;
}

- (IBAction)backPostView:(id)sender {

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    if ([[df stringFromDate:[NSDate date]] compare:[df stringFromDate:self.datePicker.date]] == NSOrderedDescending) {
        [[[UIAlertView alloc] initWithTitle:@"エラー"
                                    message:@"今日以降の日付を指定して下さい"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        return;
    }
    
    [self.delegate getDateFromViewController:self.datePicker.date];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
