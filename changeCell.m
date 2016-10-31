//
//  changeCell.m
//  security2.0
//
//  Created by Sen5 on 16/6/29.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "changeCell.h"
#import "prefrenceHeader.h"
#import "Masonry.h"

@interface changeCell ()<UITextFieldDelegate>

@end
@implementation changeCell
{
    UIImageView *_control;
    UILabel *_descLabel;
    ;
}
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _control = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"20150529200613_T2cKW.jpeg"]];
        _control.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BtnClick)];
        [_control addGestureRecognizer:tap];
        [self.contentView addSubview:_control];
     
        
        _descLabel = [[UILabel alloc] init];
        [_descLabel setTextColor:kLightTitleColor];
        _descLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_descLabel];
       // _descLabel.text = @"Change your name";
        
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textAlignment = NSTextAlignmentLeft;
        
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.textColor = kMainGreenColor;
        _textField.delegate =self;
       // _textField.text = @"i am here";
        
        [self.contentView addSubview:_textField];
        self.backgroundColor = [UIColor whiteColor];
        //self.tintColor = kDarkBackgroudColor;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(30);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.9);
        make.width.mas_equalTo(_control.mas_height);
        
    }];
    
    [self layoutIfNeeded];
    _control.layer.cornerRadius = CGRectGetWidth(_control.frame)/2.0f;
    _control.clipsToBounds = YES;
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_control.mas_right).offset(20);
        make.top.mas_equalTo(_control.mas_top);
        make.height.mas_equalTo(_control.mas_height).multipliedBy(0.5);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_control.mas_right).offset(20);
        make.bottom.mas_equalTo(_control.mas_bottom);
        make.height.mas_equalTo(_control.mas_height).multipliedBy(0.5);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.7);
    }];
    
    
}
-(void)setRecommandWords:(NSString *)text
{
    _descLabel.text = text;
}
-(void)setIcan:(UIImage *)img
{
        //加载存储图像
    [_control setImage:img];
   
}

-(void )BtnClick
{
   [_delegate changeIcon];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
