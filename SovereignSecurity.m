#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// ================================================
// 👑 SOVEREIGN NO-JAILBREAK EDITION (STABLE)
// ================================================

@interface SovereignSideload : NSObject
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation SovereignSideload

+ (void)load {
    // دالة +load تعمل تلقائياً عند حقن الـ dylib في الـ IPA
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self alloc] initStableShield];
    });
}

- (void)initStableShield {
    // 1. إخفاء السجلات (ضروري لمنع كشف الـ Debugging)
    freopen("/dev/null", "w", stdout);
    
    // 2. تفعيل الواجهة بعد استقرار اللعبة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self createOverlay];
    });
}

- (void)createOverlay {
    UIWindow *window = nil;
    // طريقة متوافقة مع الـ Sideloading لرصد نافذة اللعبة
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
    }
    
    if (window) {
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 200, 40)];
        self.statusLabel.text = @"👑 SOVEREIGN NO-JB ACTIVE";
        self.statusLabel.font = [UIFont boldSystemFontOfSize:10];
        self.statusLabel.textColor = [UIColor greenColor];
        self.statusLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.layer.cornerRadius = 12;
        self.statusLabel.clipsToBounds = YES;
        [window addSubview:self.statusLabel];
    }
}
@end
