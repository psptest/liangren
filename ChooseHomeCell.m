//
//  ChooseHomeCell.m
//  security2.0
//
//  Created by liuhuangshuzz on 3/31/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import "ChooseHomeCell.h"
#import "HouseModel.h"

#import "prefrenceHeader.h"
#import "Masonry.h"

const CGFloat kLeftMargin = -3;
const CGFloat kTopMargin = 1;

@interface ChooseHomeCell ()

@property(nonatomic,strong)UIButton *setBtn;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *backView;

@end

@implementation ChooseHomeCell

- (void)awakeFromNib {
}

-(instancetype)initWithStyle:(UITableViewCellStyle )style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backView = [[UIImageView alloc] init];
        [self.contentView addSubview:_backView];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = kLightTitleColor;
        [self.contentView addSubview:_nameLabel];
        
        _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setBtn addTarget:self action:@selector(setHome) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_setBtn];
    }
    
    return self;
}

-(void)setHome
{
    [self.delegate setHomeWithCell:self];
    
}
-(void)layoutSubviews
{
    __weak __typeof(self)weakSelf = self;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           __strong __typeof(weakSelf)sSelf = weakSelf;
        make.left.equalTo(sSelf.contentView.mas_left).offset(20);
        make.bottom.equalTo(sSelf.contentView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(sSelf.contentView.frame.size.width, 30));
    }];
    
    [_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)sSelf = weakSelf;
        make.right.equalTo(sSelf.contentView.mas_right).offset(-20);
        make.top.equalTo(sSelf.contentView.mas_top).offset(20);
         make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(@(kLeftMargin));
        make.topMargin.equalTo(@(kTopMargin));
        make.rightMargin.equalTo(@(-kLeftMargin));
        make.bottomMargin.equalTo(@(-kTopMargin));
    }];
}
//根据flage设置不同的cell风格
- (void)refreshWithSelectFlag:(BOOL)flag {
    if (flag) {
        self.backView.image = [UIImage imageNamed:@"ic_default_pair-home_"];
        self.contentView.backgroundColor = kMainGreenColor;
        self.textLabel.textColor = [UIColor blueColor];
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
       // [UIImage imageNamed:@"1361020_030924140000_2.jpg"]
        self.backView.image = [UIImage imageNamed:@"ic_default_pair-home_"];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

-(void)refreshUIWithModel:( HouseModel*)mod
{
    _nameLabel.text = mod.name;
    
    [_setBtn setBackgroundImage:[UIImage imageNamed:@"setting_my_home_nor_"] forState:UIControlStateNormal];
    [_setBtn setBackgroundImage:[UIImage imageNamed:@"setting_my_home_pre_"] forState:UIControlStateHighlighted];
   // [_backView setImage:[UIImage imageNamed:@"ic_default_pair-home_"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
