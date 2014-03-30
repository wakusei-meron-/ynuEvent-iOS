//
//  GITableViewCell.m
//  ynuEvent
//
//  Created by Genki Ishibashi on 2014/03/22.
//  Copyright (c) 2014年 Genki Ishibashi. All rights reserved.
//

#import "GITableViewCell.h"

@implementation GITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *textFont = [UIFont systemFontOfSize:17.0];
        
        // ラベル
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 130, 44)];
        nameLabel.backgroundColor = [UIColor clearColor];
        [nameLabel setFont:textFont];
        [self.contentView addSubview:nameLabel];
        
        

    }
    return self;
}

#define TAG_EVENTDATE   2

- (void)setTitleAndTag:(NSString *)title tag:(NSInteger)tag
{
    UIFont *textFont = [UIFont systemFontOfSize:17.0];
    [nameLabel setText:title];
    
    if ( tag == TAG_EVENTDATE) {
        
        _lblDate = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 140, 44)];
        [self.contentView addSubview:_lblDate];
        return;
    }
    
    // テキスト

    _txf = [[UITextField alloc] initWithFrame:CGRectMake(130, 0, 140, 44)];
    _txf.delegate = self;
    [_txf setFont:textFont];
    _txf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _txf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.contentView addSubview:_txf];
    
    
    _txf.placeholder = title;
    _txf.returnKeyType = UIReturnKeyNext;
    _txf.tag = tag;
    return;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
