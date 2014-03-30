//
//  GISettingViewController.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/24.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GISettingViewController.h"

@interface GISettingViewController ()

@end

@implementation GISettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)];
    [self.view addGestureRecognizer:gesture];
}

- (void)backView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
