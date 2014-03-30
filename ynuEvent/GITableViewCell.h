//
//  GITableViewCell.h
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/22.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GITableViewCell : UITableViewCell<UITextFieldDelegate>
{
    UILabel *nameLabel;
    UIDatePicker *datePicker;
}
@property (nonatomic, retain) UITextField *txf;
@property (nonatomic, retain) UILabel *lblDate;
- (void)setTitleAndTag:(NSString *)title tag:(NSInteger)tag;

@end
