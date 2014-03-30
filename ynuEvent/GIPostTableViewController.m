//
//  GIPostTableTableViewController.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/24.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GIPostTableViewController.h"
#import "GITableViewCell.h"
#import "GISelectEventPlaceViewController.h"

@interface GIPostTableViewController ()

@end

@implementation GIPostTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登録内容";
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithTitle:@"戻る"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(backToEventList:)];
    self.navigationItem.leftBarButtonItem = btnBack;
}

- (void)backToEventList:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDateFromViewController:(NSDate *)date
{
    self.date = [NSDate date];
    self.date = date;
    
    
    GITableViewCell *cDate;
    cDate = (GITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    // 日付の表示形式を設定
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"M月d日 H時m分";
    
    // ログに日付を表示
    //    NSLog(@"%@", [df stringFromDate:date]);
    cDate.lblDate.text = [df stringFromDate:date];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 5;
            break;
            
        case 1:
            return 1;
            
        default:
            break;
    }
    return 0;
}

#define TAG_GROUPNAME   1
#define TAG_EVENTDATE   2
#define TAG_PLACE       3
#define TAG_TITLE       4
#define TAG_BODY        5
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
    static NSString *CellIdentifier = @"Cell";
    
    GITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        
        if (indexPath.section == 0) {
            cell = [[GITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            switch (indexPath.row) {
                case 0:
                    [cell setTitleAndTag:@"団体名" tag:TAG_GROUPNAME];
                    
                    break;
                case 1:
                    [cell setTitleAndTag:@"日時" tag:TAG_EVENTDATE];
                    break;
                case 2:
                    [cell setTitleAndTag:@"場所名" tag:TAG_PLACE];
                    break;
                case 3:
                    [cell setTitleAndTag:@"イベント名" tag:TAG_TITLE];
                    break;
                case 4:
                    [cell setTitleAndTag:@"内容" tag:TAG_BODY];
                    break;
                default:
                    break;
            }
        }else if (indexPath.section == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"次へ";
            return cell;
        }
        
    }
    return cell;
}




#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            dvc = [[GIDateViewController alloc] initWithNibName:@"GIDateViewController" bundle:nil];
            
            dvc.delegate = self;
            [self.navigationController pushViewController:dvc animated:YES];
            if (self.date) {
                
                [dvc.datePicker setDate:self.date];
            }
            //            [self presentViewController:dvc animated:YES completion:^(void){
            //            }];
        }
    }
    
    if (indexPath.section == 1) {
        GISelectEventPlaceViewController *svc = [[GISelectEventPlaceViewController alloc] initWithNibName:@"GISelectEventPlaceViewController" bundle:nil];
        GITableViewCell *cGName, *cSpot, *cTitle, *cBody;
        
        //セルの値の取得
        cGName = (GITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cTitle = (GITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cSpot  = (GITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cBody  = (GITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        
        if ([cGName.txf.text isEqualToString:@""] || !self.date || [cTitle.txf.text isEqualToString:@""] ||
            [cSpot.txf.text isEqualToString:@""] //|| [cBody.txf.text isEqualToString:@""]) {
            ){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"入力されていないフォームがあります" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
            return;
        }
        
        //辞書に代入
        //辞書の初期化
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        
        //最初のディクショナリーの生成
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:cGName.txf.text forKey:@"event[groupName]"];
        [params setObject:[df stringFromDate:self.date] forKey:@"event[eDate]"];
//        [params setObject:self.date forKey@"event[eDate"];
        [params setObject:cSpot.txf.text forKey:@"event[spot]"];
        [params setObject:cTitle.txf.text forKey:@"event[title]"];
        [params setObject:cBody.txf.text forKey:@"event[body]"];
        
        svc.params = (NSMutableDictionary *)params;
        [self.navigationController pushViewController:svc animated:YES];
        //        [self presentViewController:svc animated:YES completion:^(void){
        
        
        //        }];
        
    }
}


@end
