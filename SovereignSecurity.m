#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ================================================
// 👁️ محرك الكشف الذكي (Smart ESP Engine)
// ================================================
@interface SmartESPEngine : NSObject
+ (void)enableSmartESP:(BOOL)enable;
+ (void)setupDrawingOverlay;
@end

@implementation SmartESPEngine

static BOOL _espEnabled = NO;

+ (void)enableSmartESP:(BOOL)enable {
    _espEnabled = enable;
    if (enable) {
        NSLog(@"[SMART ESP] 👁️ بدء تشغيل محرك الكشف الذكي...");
        // تأخير التشغيل 5 ثوانٍ لضمان استقرار واجهة اللعبة
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupDrawingOverlay];
        });
    }
}

+ (void)setupDrawingOverlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!window) return;

        // إنشاء لوحة إشعار النشاط (Active Notification)
        UIView *overlayInfo = [[UIView alloc] initWithFrame:CGRectMake(30, 80, 200, 40)];
        overlayInfo.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        overlayInfo.layer.cornerRadius = 10;
        overlayInfo.userInteractionEnabled = NO;

        UILabel *statusLabel = [[UILabel alloc] initWithFrame:overlayInfo.bounds];
        statusLabel.text = @"👁️ ESP: ACTIVE";
        statusLabel.textColor = [UIColor cyanColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont boldSystemFontOfSize:14];

        [overlayInfo addSubview:statusLabel];
        [window addSubview:overlayInfo];

        NSLog(@"[SMART ESP] ✅ طبقة الرسم والاشعارات جاهزة.");
    });
}
@end

// ================================================
// 🚀 نقطة الانطلاق التلقائية (The Entry Point)
// ================================================
__attribute__((constructor))
static void ESP_Initializer() {
    // مراقبة نشاط التطبيق لتفعيل الكشف بدون كراش
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification 
                                                      object:nil 
                                                       queue:[NSOperationQueue mainQueue] 
                                                  usingBlock:^(NSNotification *note) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [SmartESPEngine enableSmartESP:YES];
        });
    }];
}
