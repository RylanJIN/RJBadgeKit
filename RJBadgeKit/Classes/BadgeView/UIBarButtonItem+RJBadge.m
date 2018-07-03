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
    UIView *bottomView = [self valueForKeyPath:@"_view"];
    UIView *targetView = nil;
    if (bottomView) {
        targetView = [self findTargetViewInView:bottomView];
        targetView.clipsToBounds = NO;
    }
    return targetView;
}


// iOS10 iOS9 iOS8 (UINavigationBar →)

//  UINavigationButton → UIImageView   //initWithImage,initWithBarButtonSystemItem
//  UINavigationButton → UIButtonLabel(UILable)   //initWithBarButtonSystemItem,initWithTitle
//  CustomView                          //initWithCustomView


// iOS11 (UINavigationBar → _UINavigationBarContentView → _UIButtonBarStackView →)

//  _UIButtonBarButton → _UIModernBarButton → UIImageView   //initWithImage,initWithBarButtonSystemItem
//  _UIButtonBarButton → _UIModernBarButton → UIButtonLabel(UILable)    //initWithBarButtonSystemItem,initWithTitle
// (_UIButtonBarButton → _UITAMICAdaptorView →) CustomView           //initWithCustomView


- (UIView *)findTargetViewInView:(UIView *)view
{
    __block UIView *targetView = nil;

    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.9) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
                if ([subview isKindOfClass:UIImageView.class] ||
                    [subview isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
                    targetView = subview;
                }
                if (targetView) {
                    *stop = YES;
                }
            }];
        }else{
            targetView = view;
        }
    }else{
        if ([view isKindOfClass:NSClassFromString(@"_UIButtonBarButton")]) {

            [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
                if ([subview isKindOfClass:NSClassFromString(@"_UIModernBarButton")]) {
                    if ([subview.subviews.firstObject isKindOfClass:UIImageView.class] ||
                        [subview.subviews.firstObject isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
                        targetView = subview.subviews.firstObject;
                    }
                }
                if (targetView) {
                    *stop = YES;
                }
            }];
        }else{
            targetView = view;
        }
    }
    
    if (targetView == nil) {
        NSLog(@"TargetView of UIBarButtonItem Not Found!");
    }
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
