//
//  GIViewController.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/21.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#import "GIGMSMarker.h"

@interface GIViewController : UIViewController<GMSMapViewDelegate>
{
//    GMSMarker *marker;
    NSMutableArray *events, *eventsForTable, *markers;
    GMSMarker *newMarker;
}
@property (nonatomic, weak) IBOutlet GMSMapView *mapView;

- (IBAction)showEvents:(id)sender;
- (IBAction)reloadMarker:(id)sender;
- (IBAction)config:(id)sender;

@end
