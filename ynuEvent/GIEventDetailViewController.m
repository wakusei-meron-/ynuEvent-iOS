//
//  GIEventDetailViewController.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/23.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GIEventDetailViewController.h"

@interface GIEventDetailViewController ()

@end

@implementation GIEventDetailViewController

- (void)backListView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void)setEventInfo:(GIEvent *)event
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy年M月d日 H:mm~";
    
    lblTitle.text = event.title;
    self.title = event.title;
    date.text = [df stringFromDate:event.date];
    groupName.text = event.groupName;
    spot.text = event.spot;
    body.text = event.body;
    if ([body.text isEqualToString:@""]) {
        body.text = @"なし";
    }
    self.selectedEvent = event;
}

- (IBAction)goMarker:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];
    NSLog(@"go");
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.selectedEvent forKey:@"selectedEvent"];
    NSLog(@"event : %@", self.selectedEvent);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectMarker" object:self userInfo:dic];
}

- (void)showGoToMarkerButton:(BOOL)isShow
{
    if (isShow) {
        
        self.btnGoMarker.alpha = 1.0;
        
    }else{
        
        self.btnGoMarker.alpha = 0.0;
    }
}
@end
