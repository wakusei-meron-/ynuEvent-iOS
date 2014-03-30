//
//  GIGMSMarker.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/23.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "GIEvent.h"

@interface GIGMSMarker : GMSMarker

@property (nonatomic, retain) GIEvent *event;

@end
