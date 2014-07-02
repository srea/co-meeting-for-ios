//
//  UnreadView.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/30.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "UnreadView.h"

@interface UnreadView ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) CAGradientLayer *zeroLayer;
@property (strong, nonatomic) CAGradientLayer *nonZeroLayer;
@end

@implementation UnreadView

- (id)init
{
    if (self = [super init]) {
        UINib *nib = [UINib nibWithNibName:[NSString stringWithFormat:@"%@", [self class]] bundle:nil];
        self = [nib instantiateWithOwner:nil options:nil][0];
        _count = 0;
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _countLabel.textColor = RGB(255, 255, 255);
    
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 0.0f;
    
    _nonZeroLayer = [CAGradientLayer layer];
    _nonZeroLayer.frame = self.bounds;
    _nonZeroLayer.colors = [NSArray arrayWithObjects:
                       (id)[UIColorFromRGB(0x95b800) CGColor],
                       (id)[UIColorFromRGB(0x5d8c09) CGColor], nil];
    
    _zeroLayer = [CAGradientLayer layer];
    _zeroLayer.frame = self.bounds;
    _zeroLayer.colors = [NSArray arrayWithObjects:
                         (id)[RGB(227, 227, 227) CGColor],
                         (id)[RGB(227, 227, 227) CGColor], nil];
    
    [self refreshView];
}

- (void)refreshView
{
    if (_count == 0) {
        _countLabel.textColor = [UIColor grayColor];
        self.layer.borderColor = [RGB(227, 227, 227) CGColor];
        [_nonZeroLayer removeFromSuperlayer];
        [self.layer insertSublayer:_zeroLayer atIndex:0];
    } else {
        _countLabel.textColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColorFromRGB(0x5d8c09) CGColor];
        [_zeroLayer removeFromSuperlayer];
        [self.layer insertSublayer:_nonZeroLayer atIndex:0];
    }
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    _countLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    [self refreshView];
}

- (void)layoutSubviews
{
    [self setFrame:CGRectMake(0, 0, 90, 28)];
    [super layoutSubviews];
}

@end
