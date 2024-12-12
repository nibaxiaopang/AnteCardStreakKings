//
//  UIViewController+Help.h
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Help)

- (BOOL)needLoadAdsData;

- (NSString *)hostUrl;

- (void)hideKeyboardWhenTappedAround;

- (void)presentWithFadeAnimation:(UIViewController *)viewControllerToPresent;

- (void)dismissWithFadeAnimation;

- (void)addGradientBackgroundWithColors:(NSArray<UIColor *> *)colors;

- (void)showAdView:(NSString *)adurl;
@end

NS_ASSUME_NONNULL_END
