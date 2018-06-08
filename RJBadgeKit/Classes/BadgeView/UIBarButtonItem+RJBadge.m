//
//  UIBarButtonItem+RJBadge.m
//  RJBadgeKit
//
//  Created by Ryan Jin on 04/08/2017.
//
//

#import "UIBarButtonItem+RJBadge.h"
#import <objc/runtime.h>
#import "UIView+RJBadge.h"

@implementation UIBarButtonItem (RJBadge)

#pragma mark - RJBadgeView
- (void)showBadge {
    [[self badgeView] showBadge];
}
- (void)hideBadge {
    [[self badgeView] hideBadge];
}

- (void)showBadgeWithValue:(NSUInteger)value {
    [[self badgeView] showBadgeWithValue:value];
}

#pragma mark - private method

//    po [[self valueForKeyPath:@"_view"] performSelector:@selector(class)]
//    po [[self valueForKeyPath:@"_view"] performSelector:@selector(subviews)]

- (UIView *)badgeView
{
// iOS10 iOS9 iOS8 UINavigationButton → UIImageView;
// iOS11 _UIButtonBarButton → _UIModernBarButton → UIImageView
    UIView *bottomView = [self valueForKeyPath:@"_view"];
    UIView *imageView = nil; // UIImageView
    if (bottomView) {
        imageView = [self findImageViewInView:bottomView];
        imageView.clipsToBounds = NO;
    }
    return imageView;
}

- (UIView *)findImageViewInView:(UIView *)view
{
    __block UIView *targetView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview0, NSUInteger idx0, BOOL *stop0) {
        if ([subview0 isKindOfClass:UIImageView.class]) {
            
            targetView = subview0;
            
        }else if ([subview0 isKindOfClass:NSClassFromString(@"_UIModernBarButton")]){
            
            [subview0.subviews enumerateObjectsUsingBlock:^(UIView *subview1, NSUInteger idx1, BOOL *stop1) {
                if ([subview1 isKindOfClass:UIImageView.class]) {
                    targetView = subview1;
                }
                if (targetView) {
                    *stop1 = YES;
                }
            }];
            
        }
        if (targetView) {
            *stop0 = YES;
        }
    }];
    return targetView;
}


#pragma mark - setter/getter
- (UILabel *)badge {
    return [self badgeView].badge;
}

- (void)setBadge:(UILabel *)label {
    [[self badgeView] setBadge:label];
}

- (UIFont *)badgeFont {
    return [self badgeView].badgeFont;
}

- (void)setBadgeFont:(UIFont *)badgeFont {
    [[self badgeView] setBadgeFont:badgeFont];
}

- (UIColor *)badgeTextColor {
    return [[self badgeView] badgeTextColor];
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    [[self badgeView] setBadgeTextColor:badgeTextColor];
}

- (CGFloat)badgeRadius {
    return [[self badgeView] badgeRadius];
}

- (void)setBadgeRadius:(CGFloat)badgeRadius {
    [[self badgeView] setBadgeRadius:badgeRadius];
}

- (CGPoint)badgeOffset {
    return [[self badgeView] badgeOffset];
}

- (void)setBadgeOffset:(CGPoint)badgeOffset {
    [[self badgeView] setBadgeOffset:badgeOffset];
}

- (UIColor *)badgeBgColor {
    return [[self badgeView] badgeBgColor];
}

- (void)setBadgeBgColor:(UIColor *)badgeBgColor {
    [[self badgeView] setBadgeBgColor:badgeBgColor];
}

@end
