//
//  AMPNavigationBar.m
//  co-meeting
//
//  Created by 玉澤 裕貴 on 2014/04/28.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "AMPNavigationBar.h"

@interface AMPNavigationBar ()

@property (nonatomic, strong) CALayer *extraColorLayer;

@end

static CGFloat const kDefaultColorLayerOpacity = 0.5f;

@implementation AMPNavigationBar

- (void)setBarTintColor:(UIColor *)barTintColor
{
    [super setBarTintColor:barTintColor];
	if (self.extraColorLayer == nil) {
		self.extraColorLayer = [CALayer layer];
		self.extraColorLayer.opacity = self.extraColorLayerOpacity;
		[self.layer addSublayer:self.extraColorLayer];
	}
	self.extraColorLayer.backgroundColor = barTintColor.CGColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	if (self.extraColorLayer != nil) {
		[self.extraColorLayer removeFromSuperlayer];
		self.extraColorLayer.opacity = self.extraColorLayerOpacity;
		[self.layer insertSublayer:self.extraColorLayer atIndex:1];
		CGFloat spaceAboveBar = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
		self.extraColorLayer.frame = CGRectMake(0, 0 - spaceAboveBar, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + spaceAboveBar);
	}
}

- (void)setExtraColorLayerOpacity:(CGFloat)extraColorLayerOpacity
{
    _extraColorLayerOpacity = extraColorLayerOpacity;
	[self setNeedsLayout];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        _extraColorLayerOpacity = [[decoder decodeObjectForKey:@"extraColorLayerOpacity"] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[super encodeWithCoder:encoder];
	[encoder encodeObject:@(self.extraColorLayerOpacity) forKey:@"extraColorLayerOpacity"];
}

@end