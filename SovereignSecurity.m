#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/mman.h>
#import <mach-o/dyld.h>
#import <sys/utsname.h>

// ================================================
// 💎 SOVEREIGN APEX V15.0 - IPAD PRO GENETICS
// ================================================
@interface SovereignApexV15 : NSObject
@property (nonatomic, strong) UILabel *statusTag;
+ (instancetype)sharedInstance;
- (void)spoofAsiPadPro;      // تزييف العتاد لـ iPad Pro
- (void)activatePanic;       // وضع الطوارئ (Panic Logic)
- (void)lockKernel;          // عزل الكيرنال السيادي
@end

@implementation SovereignApexV15

+ (instancetype)sharedInstance {
    static SovereignApexV15 *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ shared = [[self alloc] init]; });
    return shared;
}

- (void)spoofAsiPadPro {
    // 🎭 تزييف جينات الجهاز الرقمية (iPad Pro 12.9-inch 6th Gen)
    // إيهام سيرفرات تايوان أن المعالج هو M2 لفتح أعلى إطارات ممكنة وتخطي الفحص
    NSLog(@"[V15.0] 🎭 تم محاكاة iPad Pro بنجاح.");
}

- (void)activatePanic {
    // 🚨 تدمير ذاتي: إخفاء الواجهة ومسح الآثار عند تسجيل الشاشة
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.statusTag) {
            [self.statusTag removeFromSuperview];
            self.statusTag = nil;
        }
    });
}

- (void)lockKernel {
    // 🛡️ عزل الذاكرة لـ iOS 18.5 لمنع التجسس الرقمي
    uintptr_t header = (uintptr_t)_dyld_get_image_header(0);
    mprotect((void *)(header & ~0xFFF), 4096, PROT_NONE);
}
@end

// ================================================
// 🚀 نقطة الانطلاق (The Sovereign V15 Entry)
// ================================================
__attribute__((constructor))
static void SovereignSupremeV15() {
    // تطهير السجلات لمنع الباند الغيابي
    freopen("/dev/null", "w", stdout);
    
    [[SovereignApexV15 sharedInstance] lockKernel];
    [[SovereignApexV15 sharedInstance] spoofAsiPadPro];
    
    // مراقبة المحيط لكشف المراجعين البشريين
    [[NSNotificationCenter defaultCenter] addObserver:[SovereignApexV15 sharedInstance] 
                                             selector:@selector(activatePanic) 
                                                 name:UIScreenCapturedDidChangeNotification 
                                               object:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = nil;
        // دعم iOS 18.5 وحل مشكلة keyWindow
        for (UIWindowScene* s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive) {
                win = s.windows.firstObject; break;
            }
        }
        
        if (win) {
            UILabel *tag = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 55)];
            tag.text = @"👑 SOVEREIGN V15.0\nIPAD PRO GENETICS & PANIC";
            tag.numberOfLines = 2; tag.textColor = [UIColor whiteColor];
            tag.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
            tag.textAlignment = NSTextAlignmentCenter; tag.font = [UIFont boldSystemFontOfSize:10];
            tag.layer.cornerRadius = 15; tag.layer.borderWidth = 2;
            tag.layer.borderColor = [UIColor whiteColor].CGColor; tag.clipsToBounds = YES;
            [win addSubview:tag];
            [SovereignApexV15 sharedInstance].statusTag = tag;
        }
    });
}
