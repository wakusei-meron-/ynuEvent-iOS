//
//  GIEvent.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/23.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>


@interface GIEvent : NSObject
{
    int eventID;
    float latitude, longitude;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *spot;
@property (nonatomic, retain) NSDate *date;

- (void)setIdAndCoordinate:(int)eID latitude:(float)lat longitude:(float)lon;
- (CLLocationCoordinate2D)getEventCoordinate;
- (int)getID;

@end
