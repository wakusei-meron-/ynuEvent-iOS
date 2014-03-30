//
//  GIEventListViewController.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/21.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GIEventListViewController.h"
#import "GIPostEventViewController.h"
#import "GIEventDetailViewController.h"
#import "GIPostTableViewController.h"
#import "GIEvent.h"

@interface GIEventListViewController ()

@end

@implementation GIEventListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.events = [NSMutableArray array];
        
        btnRegister = [[UIBarButtonItem alloc] initWithTitle:@"登録"
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(goToRegisterView:)];
        self.navigationItem.rightBarButtonItem = btnRegister;
        
        btnBack = [[UIBarButtonItem alloc] initWithTitle:@"戻る"
                                                   style:UIBarButtonItemStyleBordered
                                                  target:self
                                                  action:@selector(backToMap:)];
        self.navigationItem.leftBarButtonItem = btnBack;
        
        self.title = @"イベント一覧";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"event count %d", self.eventsForTable.count);
    
}

- (IBAction)backToMap:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)goToRegisterView:(UIBarButtonItem *)sender {
    
    [[[UIAlertView alloc] initWithTitle:@"イベントの登録"
                                message:@"イベントの登録には100円がかかりますがよろしいでしょうか？？"
                               delegate:self
                      cancelButtonTitle:@"キャンセル"
                      otherButtonTitles:@"OK", nil]
     show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
//        GIPostEventViewController *pvc = [[GIPostEventViewController alloc] initWithNibName:@"GIPostEventViewController" bundle:nil];
        GIPostTableViewController *tvc = [[GIPostTableViewController alloc] initWithNibName:@"GIPostTableViewController" bundle:nil];
//        UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:tvc animated:YES];
//        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:pvc];
//        [self presentViewController:nvc animated:YES completion:^(void){}];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.

    //今日より前のを削除
    NSLog(@"count : %d", self.eventsForTable.count);
    return self.eventsForTable.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    NSMutableArray *tmpArr = [self.eventsForTable objectAtIndex:section];
    return tmpArr.count;
//    return self.events.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy年MM月dd日";
    NSMutableArray *tmpArr = [self.eventsForTable objectAtIndex:section];
    GIEvent *eve = [tmpArr objectAtIndex:0];
    return [df stringFromDate:eve.date];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSMutableArray *tmpArr = [self.eventsForTable objectAtIndex:indexPath.section];        
        GIEvent *aEvent = [tmpArr objectAtIndex:indexPath.row];//[self.events objectAtIndex:indexPath.row];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"M-d HH:mm";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = aEvent.groupName;//[df stringFromDate:aEvent.date];//@"団体名";
        cell.detailTextLabel.text = aEvent.title;//@"内容";
        
    }
    return cell;
}

 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GIEventDetailViewController *dvc = [[GIEventDetailViewController alloc] initWithNibName:@"GIEventDetailViewController" bundle:nil];
    [self.navigationController pushViewController:dvc animated:YES];

    NSMutableArray *tmpArr = [self.eventsForTable objectAtIndex:indexPath.section];
    [dvc performSelector:@selector(setEventInfo:) withObject:[tmpArr objectAtIndex:indexPath.row] afterDelay:0.1];
    [dvc showGoToMarkerButton:YES];
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}
@end
