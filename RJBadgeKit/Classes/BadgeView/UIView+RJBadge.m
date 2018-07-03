//
//  UIView+RJBadge.m
//  RJBadgeKit
//
//  Created by Ryan Jin on 04/08/2017.
//
//

#import "UIView+RJBadge.h"
#import <objc/runtime.h>

#define kRJBadgeDefaultFont                ([UIFont boldSystemFontOfSize:12])
#define kRJBadgeDefaultMaximumBadgeNumber  99

static const CGFloat kRJBadgeDefaultRadius = 4.f;

@implementation UIView (RJBadge)

#pragma mark - RJBadgeView
- (void)showBadge
{
    if (self.badgeCustomView) {
        self.badgeCustomView.hidden   = NO;
        self.badge.hidden             = YES;
        [self adjustCustomViewFrame:self.badgeCustomView];
    } else {
        self.badge.text               = @"";
        self.badge.hidden             = NO;
        [self adjustDotFrame:self.badge];
    }
}

- (void)showBadgeWithValue:(NSUInteger)value
{
    self.badgeCustomView.hidden = YES;

    self.badge.hidden  = (value == 0);
    self.badge.font    = self.badgeFont;
    self.badge.text    = (value > kRJBadgeDefaultMaximumBadgeNumber ?
                         [NSString stringWithFormat:@"%@+", @(kRJBadgeDefaultMaximumBadgeNumber)] :
                         [NSString stringWithFormat:@"%@" , @(value)]);
    [self adjustLabelFrame:self.badge];
}

- (void)hideBadge
{
    if (self.badgeCustomView) {
        self.badgeCustomView.hidden = YES;
    }
    self.badge.hidden = YES;
}

#pragma mark - private methods

- (void)adjustCustomViewFrame:(UIView *)customView{
    CGFloat offsetX = CGRectGetWidth(self.bounds) + self.badgeOffset.x;
    customView.center = CGPointMake(offsetX, self.badgeOffset.y);
}

- (void)adjustDotFrame:(UILabel *)label
{
    CGFloat width = (self.badgeRadius ?: kRJBadgeDefaultRadius) * 2;
    label.bounds = CGRectMake(0, 0, width, width);
    label.layer.cornerRadius = width / 2;
    
    CGFloat offsetX   = CGRectGetWidth(self.bounds) + self.badgeOffset.x;
    label.center = CGPointMake(offsetX, self.badgeOffset.y);
}

- (void)adjustLabelFrame:(UILabel *)label
{
    CGSize labelsize = CGSizeZero;
    labelsize        = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX)
                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                             attributes:@{NSFontAttributeName: label.font}
                                context:nil].size;

    
    label.bounds     = CGRectMake(0,
                                  0,
                                  ceilf(MAX(labelsize.width, labelsize.height)) + 2,
                                  ceilf(labelsize.height) + 2);

    CGFloat offsetX   = CGRectGetWidth(self.bounds) + self.badgeOffset.x;
    label.center      = CGPointMake(offsetX, self.badgeOffset.y);
    
    label.layer.cornerRadius = CGRectGetHeight(label.bounds) / 2.f;
}

#pragma mark - setter/getter
- (UILabel *)badge
{
    UILabel *bLabel   = objc_getAssociatedObject(self, _cmd);
    if (!bLabel) {
        bLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        bLabel.textAlignment   = NSTextAlignmentCenter;
        bLabel.backgroundColor = [UIColor colorWithRed:0xFB/225.f
                                                 green:0x2E/225.f
                                                  blue:0x35/255.f
                                                 alpha:1.f];
        bLabel.textColor       = [UIColor whiteColor];
        bLabel.text            = @"";

        bLabel.layer.masksToBounds = YES;
        bLabel.hidden              = YES;
        
        [self adjustDotFrame:bLabel];

        objc_setAssociatedObject(self,
                                 _cmd,
                                 bLabel,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:bLabel];
        [self bringSubviewToFront:bLabel];
    }
    return bLabel;
}

- (void)setBadge:(UILabel *)badge {
    objc_setAssociatedObject(self,
                             @selector(badge),
                             badge,
                             OBJC_ASSOCIATION_RETAIN);
}

- (UIFont *)badgeFont {
    return objc_getAssociatedObject(self, _cmd) ?: kRJBadgeDefaultFont;
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self,
                             @selector(badgeFont),
                             badgeFont,
                             OBJC_ASSOCIATION_RETAIN);
    self.badge.font = badgeFont;
}

- (UIColor *)badgeBgColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBadgeBgColor:(UIColor *)badgeBgColor
{
    objc_setAssociatedObject(self,
                             @selector(badgeBgColor),
                             badgeBgColor,
                             OBJC_ASSOCIATION_RETAIN);
    self.badge.backgroundColor = badgeBgColor;
}

- (UIColor *)badgeTextColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self,
                             @selector(badgeTextColor),
                             badgeTextColor,
                             OBJC_ASSOCIATION_RETAIN);
    self.badge.textColor = badgeTextColor;
}

- (CGFloat)badgeRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setBadgeRadius:(CGFloat)badgeRadius {
    objc_setAssociatedObject(self,
                             @selector(badgeRadius),
                             @(badgeRadius),
                             OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)badgeOffset
{
    NSValue *offset = objc_getAssociatedObject(self, _cmd);
    
    if (!offset)      return CGPointZero;
    
    return [offset CGPointValue];
}

- (void)setBadgeOffset:(CGPoint)badgeOffset {
    objc_setAssociatedObject(self,
                             @selector(badgeOffset),
                             [NSValue valueWithCGPoint:badgeOffset],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)badgeImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBadgeImage:(UIImage *)badgeImage
{
    self.badgeCustomView = [[UIImageView alloc] initWithImage:badgeImage];
    objc_setAssociatedObject(self,
                             @selector(badgeImage),
                             badgeImage,
                             OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)badgeCustomView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBadgeCustomView:(UIView *)badgeCustomView
{
    if (self.badgeCustomView == badgeCustomView) return;

    if (self.badgeCustomView) [self.badgeCustomView removeFromSuperview];
    
    objc_setAssociatedObject(self,
                             @selector(badgeCustomView),
                             badgeCustomView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.badgeCustomView) {
        [self addSubview:self.badgeCustomView];
    }
    [self showBadge]; // refresh - in case of setting custom view after show badge
}

@end
