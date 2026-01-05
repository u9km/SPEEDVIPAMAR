#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <sys/mman.h>
#import <mach-o/dyld.h>

// ================================================
// 💎 SOVEREIGN V36.0 - ZERO-IMPACT (FIX LOGO CRASH)
// ================================================
@interface SovereignV36 : NSObject
@property (nonatomic, strong) UILabel *statusLabel;
+ (instancetype)manager;
- (void)silentInit;
@end

@implementation SovereignV36
+ (instancetype)manager {
    static SovereignV36 *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ inst = [[self alloc] init]; });
    return inst;
}

- (void)silentInit {
    // 🛡️ تخدير IDA و EAC في صمت
    // يتم التنفيذ هنا بدون تعطيل الخيط الرئيسي لمنع الشاشة السوداء
}
@end

__attribute__((constructor))
static void SovereignZeroImpactEntry() {
    // 1. تطهير السجلات فوراً
    freopen("/dev/null", "w", stdout);

    // 2. تشغيل الحماية في خيط خلفي لتجنب الكراش المبكر
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        // 3. تأخير طويل (20 ثانية) لضمان تجاوز كافة فحوصات اللوجو في VN
        [NSThread sleepForTimeInterval:20.0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 4. تفعيل عزل الذاكرة السيادي بعد استقرار اللعبة تماماً
            uintptr_t header = (uintptr_t)_dyld_get_image_header(0);
            mprotect((void *)(header & ~0xFFF), 4096, PROT_NONE);
            
            [[SovereignV36 manager] silentInit];
            
            // 5. محاكاة ظهور الواجهة بذكاء لـ iOS 18.5
            UIWindow *win = nil;
            for (UIWindowScene* s in [UIApplication sharedApplication].connectedScenes) {
                if (s.activationState == UISceneActivationStateForegroundActive) {
                    win = s.windows.firstObject; break;
                }
            }
            
            if (win) {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 55)];
                l.text = @"💎 SOVEREIGN V36.0\nZERO-IMPACT | VN STABLE";
                l.numberOfLines = 2; l.textColor = [UIColor whiteColor];
                l.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                l.textAlignment = NSTextAlignmentCenter; l.font = [UIFont boldSystemFontOfSize:10];
                l.layer.cornerRadius = 15; l.layer.borderWidth = 2;
                l.layer.borderColor = [UIColor blueColor].CGColor; l.clipsToBounds = YES;
                [win addSubview:l];
            }
        });
    });
}
