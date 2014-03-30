//
//  GIViewController.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/21.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GIViewController.h"
#import "GIEventListViewController.h"
#import "AFNetworking.h"
#import "GIEvent.h"
#import "GIEventDetailViewController.h"
#import "GISettingViewController.h"

@interface GIViewController ()

@end

@implementation GIViewController

#define LAT_YNU 35.4738828
#define LON_YNU 139.589725

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initialLoad];
    
    [self fetchEventsAndIsNew:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedMarker:) name:@"SelectMarker" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMarkerToMap:) name:@"PostComplete" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectMarker" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PostComplete" object:nil];
}

#pragma mark - Notification
- (void)selectedMarker:(NSNotification *)notificatin
{
    GIEvent *sEvent = [notificatin.userInfo objectForKey:@"selectedEvent"];
    NSInteger index = [events indexOfObject:sEvent];

    GMSMarker *sMarker = [markers objectAtIndex:index];
    self.mapView.selectedMarker = sMarker;
    float currentZoom = self.mapView.camera.zoom;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:sMarker.position.latitude
                                                            longitude:sMarker.position.longitude
                                                                 zoom:currentZoom];
    self.mapView.camera = camera;
}

- (void)addMarkerToMap:(NSNotification *)notification
{
    newMarker = [notification.userInfo objectForKey:@"newMarker"];
    [self fetchEventsAndIsNew:YES];
}




#pragma mark - myFunction

//#define SERVERURL @"http://localhost:3000"
//#define SERVERURL @"http://planet-meron.com:2001"
- (void)fetchEventsAndIsNew:(BOOL)isNew
{
    static AFHTTPClient *sharedCliant = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedCliant = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVERURL]];
    });
    
    NSString *path = [NSString stringWithFormat:@"events.json"];
    [sharedCliant setParameterEncoding:AFJSONParameterEncoding];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:[sharedCliant requestWithMethod:@"GET" path:path parameters:nil]
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                        
                                                        //データの取得に成功した時の処理
                                                        NSLog(@"JSON: %@", JSON);
                                                        
                                                        //イベント一覧の選別
                                                        events = [NSMutableArray array];
                                                        events = [self extractEventsFromJSON:JSON];
                                                        NSLog(@"events.count : %d", events.count);
                                                        
                                                        markers = [NSMutableArray array];
                                                        
                                                        //データが無かったらスルー
                                                        if ([events isEqualToArray:[NSMutableArray array]]) {
                                                            return ;
                                                        }
                                                        
                                                        //日付順にソート
                                                        events = [self sortDateAscending:events];
                                                        
                                                        //日付ごとに分ける
                                                        eventsForTable = [self classifyArrayToSameDate:events];
                                                        
                                                        //マーカーの表示
                                                        [self showMarkerToMap:events];
                                                        
                                                        if (isNew) {
                                                            
                                                            
                                                            
                                                            float currentZoom = self.mapView.camera.zoom;
                                                            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newMarker.position.latitude
                                                                                                                    longitude:newMarker.position.longitude
                                                                                                                         zoom:currentZoom];
                                                            self.mapView.camera = camera;
                                                            [self reloadMarker:nil];
                                                        }
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,NSError *error, id JSON){
                                                        
                                                        //データの取得に失敗した時の処理
                                                        NSLog(@"error: %@", error);
                                                        [[[UIAlertView alloc] initWithTitle:@"通信失敗"
                                                                                    message:@"データの取得ができませんでした"
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles: nil] show];
                                                    }];
    
    [sharedCliant enqueueHTTPRequestOperation:operation];
    

}



- (void)showMarkerToMap:(NSMutableArray *)eventList
{
 
    NSDateFormatter *df = [[NSDateFormatter alloc] init];    
    for (int i=0; i<eventList.count; i++) {
        
        GIEvent *aEvent = [eventList objectAtIndex:i];
        GMSMarker *aMarker = [[GMSMarker alloc] init];
        
        //マーカー
        aMarker.position = CLLocationCoordinate2DMake([aEvent getEventCoordinate].latitude,
                                                      [aEvent getEventCoordinate].longitude);
        aMarker.title = aEvent.title;
        
        
        df.dateFormat = @"M/d H:mm~";
        
        NSString *strTemp = [NSString stringWithFormat:@"日時:%@\n団体名:%@\n場所:%@\n\n%@",
                             
                             [df stringFromDate:aEvent.date],
                             aEvent.groupName,
                             aEvent.spot,
                             aEvent.body];
        aMarker.snippet = strTemp;
        aMarker.appearAnimation = kGMSMarkerAnimationPop;
        aMarker.map = self.mapView;
        
        [markers addObject:aMarker];
    }
}

- (NSMutableArray *)classifyArrayToSameDate:(NSMutableArray *)array
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSMutableArray *tmpArr = [NSMutableArray array];
    NSMutableArray *arrDayEvents = [NSMutableArray array];
    GIEvent *aEvent = [events objectAtIndex:0];
    [arrDayEvents addObject:aEvent];
    NSDate *currDate = aEvent.date;
    
    for (int i=1; i<events.count; i++) {
        
        aEvent = [events objectAtIndex:i];
        
        // 日付を比較
        NSComparisonResult result = [[df stringFromDate:currDate] compare:[df stringFromDate:aEvent.date]];
        switch(result) {
            case NSOrderedSame: // 一致したとき
                [arrDayEvents addObject:aEvent];
                break;
                
            case NSOrderedAscending:
                
                [tmpArr addObject:arrDayEvents];
                arrDayEvents = [NSMutableArray array];
                [arrDayEvents addObject:aEvent];
                currDate = aEvent.date;
                break;
                
            case NSOrderedDescending:
                break;
        }
        
        
    }
    //最後に入れる
    [tmpArr addObject:arrDayEvents];
    
    return tmpArr;
}

- (NSMutableArray *)sortDateAscending:(NSMutableArray *)array
{

    //Eventからdateで比較して昇順に並べ替える
    NSSortDescriptor *sortDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescArray = [NSArray arrayWithObjects:sortDate, nil];
    [events sortUsingDescriptors:sortDescArray];
    return events;
}

- (void)initialLoad{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:LAT_YNU
                                                            longitude:LON_YNU
                                                                 zoom:16];

    self.mapView.camera = camera;
    self.mapView.delegate = self;
    self.mapView.settings.compassButton = YES;

}

- (NSMutableArray *)extractEventsFromJSON:(id)json
{
    
    //日付
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.000Z'"];
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    
    //それぞれのイベントについて調べる
    for (NSDictionary *jsonObject in json) {
        
        //GIEvent生成
        GIEvent *event = [self deleteEventEarlierToday:jsonObject compareDate:[NSDate date]];
        if (!event) {
            continue;
        }

        //イベント内容の取得
        event.date  = [df dateFromString:[jsonObject objectForKey:@"eDate"]];
        event.spot  = [jsonObject objectForKey:@"spot"];
        event.title = [jsonObject objectForKey:@"title"];
        event.body  = [jsonObject objectForKey:@"body"];
        event.groupName = [jsonObject objectForKey:@"groupName"];
        
        //idと経度・緯度
        [event setIdAndCoordinate:[[jsonObject objectForKey:@"id"] intValue]
                         latitude:[[jsonObject objectForKey:@"latitude"] floatValue]
                        longitude:[[jsonObject objectForKey:@"longitude"] floatValue]];
        
        //一時配列に記録
        [tmpArr addObject:event];
    }
    
    return tmpArr;
}

- (GIEvent *)deleteEventEarlierToday:(NSDictionary *)jsonObject compareDate:(NSDate *)today
{

    //今日の日付の0時
    NSDateFormatter *tdf = [[NSDateFormatter alloc] init];
    tdf.dateFormat = @"yyyy-MM-dd'T00:00:00.000Z'";
    
    //今日と日付の比較(今日より前だと飛ばす)
    NSComparisonResult result = [[tdf stringFromDate:today] compare:[jsonObject objectForKey:@"eDate"]];
    switch(result) {
        case NSOrderedSame:         // 一致したとき
            return [[GIEvent alloc] init];
            
        case NSOrderedAscending:    // todayが小さいとき
            return [[GIEvent alloc] init];
            
        case NSOrderedDescending:   // todayが大きいとき
            return nil;
            
    }
}


#pragma mark - IBAction
- (IBAction)showEvents:(id)sender {
    

    GIEventListViewController *evc = [[GIEventListViewController alloc] initWithNibName:@"GIEventListViewController" bundle:nil];
    
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:evc];

    
    [self presentViewController:nvc animated:YES completion:^(void){}];
    evc.events = events;
    evc.eventsForTable = eventsForTable;
}

- (IBAction)reloadMarker:(id)sender {
    
    [self.mapView clear];
    [self fetchEventsAndIsNew:NO];
}

- (IBAction)config:(id)sender {
    
    GISettingViewController *svc = [[GISettingViewController alloc] initWithNibName:@"GISettingViewController" bundle:nil];
    [self presentViewController:svc animated:YES completion:^(void){}];
}

#pragma mark - GMSMap Delegate
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{


    NSInteger index = [markers indexOfObject:marker];
    NSLog(@"%d", index);
    GIEventDetailViewController *dvc = [[GIEventDetailViewController alloc] initWithNibName:@"GIEventDetailViewController" bundle:nil];

    [self presentViewController:dvc animated:YES completion:^(void){
    }];
    
    [dvc setEventInfo:[events objectAtIndex:index]];
    [dvc showGoToMarkerButton:NO];

}
@end
