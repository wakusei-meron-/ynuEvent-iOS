//
//  GIDateViewController.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/22.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//
@protocol GIDateViewControllerDelegate;

#import <UIKit/UIKit.h>
@interface GIDateViewController : UIViewController

@property (nonatomic, assign) id<GIDateViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;


- (IBAction)backPostView:(id)sender;
@end

@protocol GIDateViewControllerDelegate <NSObject>

- (void)getDateFromViewController:(NSDate *)date;

@end
