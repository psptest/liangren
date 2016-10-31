//
//  hangCell.m
//  security2.0
//
//  Created by liuhuangshuzz on 7/7/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import "hangCell.h"
#import "prefrenceHeader.h"
#import "Masonry.h"
#define kLeftCap 5
#define kOneLineHeight 15
@implementation hangCell
{
    UILabel *_lab;
    UIButton *_control;
    UILabel *_lastLab;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _lab = [[UILabel alloc] init];
        _lab.textColor = kLightTitleColor;
        [self.contentView addSubview:_lab];
        _lastLab = _lab;
        
        _control = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _control.tintColor = kMainGreenColor;
        [self.contentView addSubview:_control];
        [_control addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftCap);
        make.top.mas_equalTo(kLeftCap);
        make.width.mas_equalTo(kSelfWidth);
        make.height.mas_equalTo(kOneLineHeight);
    }];
    
    [_control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kLeftCap);
        make.bottom.mas_equalTo(-kLeftCap);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
}
-(void)setRecommandString:(NSString *)recommands
{
    _lab.text = recommands;
}
-(void)setContents:(NSArray *)contents
{
    if (contents.count != 0) {
        
        for (NSString *content in contents) {
            
            UILabel *lab = [[UILabel alloc] init];
            lab.textColor = kMainGreenColor;
            lab.text = [NSString stringWithFormat:@"*%@",content];
            [self.contentView addSubview:lab];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_lastLab.mas_bottom).offset(kLeftCap);
                make.left.mas_equalTo(_lastLab.mas_left);
                make.right.mas_equalTo(_lastLab.mas_right);
                make.height.mas_equalTo(kOneLineHeight);
            }];
            
            _lastLab = lab;
        }
    }
    
    
}

#pragma mark - click event 
-(void)btnClick
{
    [_delegate btnClicked:self];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
