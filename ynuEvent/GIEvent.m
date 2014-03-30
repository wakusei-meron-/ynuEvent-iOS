//
//  GIEvent.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/23.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GIEvent.h"

@implementation GIEvent

-(void)setIdAndCoordinate:(int)eID latitude:(float)lat longitude:(float)lon
{
    eventID = eID;
    latitude = lat;
    longitude = lon;
}

-(CLLocationCoordinate2D)getEventCoordinate
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return coordinate;
}

-(int)getID
{
    return eventID;
}
@end
