//
//  GIEventDetailViewController.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/23.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GIEvent.h"

@interface GIEventDetailViewController : UIViewController
{
    


    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *groupName;
    IBOutlet UILabel *date;
    IBOutlet UILabel *spot;
    IBOutlet UITextView *body;
//    IBOutlet UILabel *body;
}

@property(nonatomic, retain) GIEvent *selectedEvent;
@property (strong, nonatomic) IBOutlet UIButton *btnGoMarker;

- (IBAction)backListView:(id)sender;
- (void)setEventInfo:(GIEvent *)event;
- (void)showGoToMarkerButton:(BOOL)isShow;
- (IBAction)goMarker:(id)sender;



@end
