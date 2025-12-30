#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ================================================
// 👁️ محرك الكشف الذكي (Smart ESP Engine)
// ================================================
@interface SmartESPEngine : NSObject
+ (void)initializeESP;
@end

@implementation SmartESPEngine

static BOOL _espEnabled = NO;

+ (void)initializeESP {
    if (_espEnabled) return;
    _espEnabled = YES;

    NSLog(@"[SMART ESP] 👁️ بدء تشغيل الكشف الذكي...");

    // انتظر 5 ثوانٍ لضمان استقرار واجهة اللعبة قبل الرسم
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupOverlay];
    });
}

+ (void)setupOverlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
        if (!mainWindow) return;

        // إشعار بسيط للتأكد من عمل الكاشف داخل اللعبة
        UIView *notifyView = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 220, 40)];
        notifyView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        notifyView.layer.cornerRadius = 8;

        UILabel *label = [[UILabel alloc] initWithFrame:notifyView.bounds];
        label.text = @"👁️ Sovereign ESP Active";
        label.textColor = [UIColor greenColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];

        [notifyView addSubview:label];
        [mainWindow addSubview:notifyView];

        // هنا يبدأ محرك الرسم الفعلي (CADisplayLink) الخاص بـ ESP.m
        NSLog(@"[SMART ESP] ✅ طبقة الرسم جاهزة للعمل.");
    });
}
@end

// ================================================
// 🚀 المدخل الرئيسي (Constructor)
// ================================================
__attribute__((constructor))
static void ESPMainEntry() {
    // تشغيل الكود بمجرد أن تصبح اللعبة نشطة لمنع الخروج المفاجئ (Crash)
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification 
                                                      object:nil 
                                                       queue:[NSOperationQueue mainQueue] 
                                                  usingBlock:^(NSNotification *note) {
        [SmartESPEngine initializeESP];
    }];
}
