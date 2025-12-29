#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <sys/sysctl.h>

// ==========================================
// 1. محرك فك التشفير السيادي (Sovereign Decrypt)
// ==========================================
// تشفير النصوص باستخدام XOR لمنع الكشف الاستاتيكي
static NSString *Sovereign_Decrypt(const char *cipher) {
    char key = 0x53; // مفتاح التشفير 'S'
    size_t len = strlen(cipher);
    char *plain = malloc(len + 1);
    for (size_t i = 0; i < len; i++) {
        plain[i] = cipher[i] ^ key;
    }
    plain[len] = '\0';
    NSString *result = [NSString stringWithUTF8String:plain];
    free(plain);
    return result;
}

// ==========================================
// 2. معقم الأدلة والتقارير (Evidence Sanitizer)
// ==========================================
@interface SovereignSanitizer : NSObject
+ (void)igniteCleaningProtocol;
@end

@implementation SovereignSanitizer
+ (void)igniteCleaningProtocol {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (YES) {
            // فك تشفير مسار "Documents" ومجلدات "Logs, Bugly, Slardar"
            NSString *docs = [NSHomeDirectory() stringByAppendingPathComponent:Sovereign_Decrypt("\x07\x2C\x20\x36\x2E\x26\x2D\x37\x30")];
            NSFileManager *fm = [NSFileManager defaultManager];
            
            // استهداف مجلدات التقارير المشفرة
            NSArray *targets = @[@"\x1F\x2C\x24\x30", @"\x11\x26\x34\x3F\x2A", @"\x01\x36\x24\x2F\x3A", @"\x10\x2F\x22\x31\x27\x22\x31"];
            for (NSString *enc in targets) {
                NSString *path = [docs stringByAppendingPathComponent:Sovereign_Decrypt([enc UTF8String])];
                if ([fm fileExistsAtPath:path]) [fm removeItemAtPath:path error:nil];
            }
            sleep(12); // دورة تنظيف كل 12 ثانية
        }
    });
}
@end

// ==========================================
// 3. فلتر الشبكة المعتم (Network Ghost Filter)
// ==========================================
// حجب تقارير البلاغات والمراقبين بشكل مشفر
@implementation NSMutableURLRequest (SovereignApex)
+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        Method orig = class_getInstanceMethod(self, @selector(setURL:));
        Method swiz = class_getInstanceMethod(self, @selector(sovereign_setURL:));
        method_exchangeImplementations(orig, swiz);
    });
}

- (void)sovereign_setURL:(NSURL *)url {
    NSString *u = [url absoluteString].lowercaseString;
    // فحص الكلمات المشفرة (report, spectate, analytics)
    if ([u containsString:Sovereign_Decrypt("\x31\x26\x33\x2C\x31\x37")] || 
        [u containsString:Sovereign_Decrypt("\x30\x33\x26\x20\x37\x22\x37\x26")] ||
        [u containsString:Sovereign_Decrypt("\x20\x2D\x20\x2F\x3A\x37\x2A\x20\x30")]) {
        // تحويل الطلب إلى "الثقب الأسود" (Null Route)
        [self sovereign_setURL:[NSURL URLWithString:Sovereign_Decrypt("\x2B\x37\x37\x33\x39\x6E\x6C\x6E\x6F\x6D\x6C\x6E\x6C\x6C\x6E\x6C\x6C\x6C")]];
    } else {
        [self sovereign_setURL:url];
    }
}
@end

// ==========================================
// 4. منظم النظام والواجهة (Orchestrator)
// ==========================================
@interface SovereignOrchestrator : NSObject
+ (void)startSystem;
@end

@implementation SovereignOrchestrator
+ (void)startSystem {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [SovereignSanitizer igniteCleaningProtocol];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification 
                                                          object:nil 
                                                           queue:[NSOperationQueue mainQueue] 
                                                      usingBlock:^(NSNotification *note) {
            [self showStatus];
        }];
    });
}

+ (void)showStatus {
    UIWindow *w = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *s in UIApplication.sharedApplication.connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive && [s isKindOfClass:UIWindowScene.class]) {
                w = ((UIWindowScene *)s).windows.firstObject; break;
            }
        }
    }
    if (w.rootViewController && !w.rootViewController.presentedViewController) {
        UIAlertController *a = [UIAlertController alertControllerWithTitle:Sovereign_Decrypt("\x10\x1C\x05\x16\x01\x16\x1A\x1D\x1D\x53\x12\x03\x16\x1B\x53\x15\x60\x6A") 
                                                                    message:Sovereign_Decrypt("\x1A\x2D\x37\x26\x24\x31\x2A\x37\x3A\x6A\x53\x00\x3A\x2F\x20\x2E\x2A\x20") 
                                                             preferredStyle:UIAlertControllerStyleAlert];
        [a addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [w.rootViewController presentViewController:a animated:YES completion:nil];
    }
}
@end

__attribute__((constructor))
static void SovereignEntry() {
    [SovereignOrchestrator startSystem];
}
