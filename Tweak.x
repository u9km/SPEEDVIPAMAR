#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <netdb.h>
#import "fishhook.h"

// 🛡️ إعدادات الحماية
#define TARGET_HACK "libwebp"
#define ORIGINAL_BUNDLE "com.pubg.korea" // استبدله بالبندل الأصلي لنسختك

// ============================================================================
// 1. حل مشكلة الشاشة السوداء (Bundle Spoofing)
// ============================================================================
static NSString* (*orig_bundleIdentifier)(id self, SEL _cmd);
NSString* hooked_bundleIdentifier(id self, SEL _cmd) {
    // تزوير البندل داخلياً لمنع الشاشة السوداء عند الحقن ببندل مختلف
    return @ORIGINAL_BUNDLE;
}

// ============================================================================
// 2. منظف البصمات (Anti-Ban Cleaner)
// ============================================================================
static void CleanGameLogs() {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // تنظيف المجلدات التي تخزن سجلات البند والبلاغات
    NSArray *paths = @[@"Logs", @"ShadowTrackerExtra/Saved/Logs", @"Pandora"];
    for (NSString *path in paths) {
        NSString *fullPath = [docPath stringByAppendingPathComponent:path];
        if ([fm fileExistsAtPath:fullPath]) {
            [fm removeItemAtPath:fullPath error:nil];
        }
    }
}

// ============================================================================
// 3. حماية البولت تراك والذاكرة (Anti-10 Years & Lobby Ban)
// ============================================================================
static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    if (addr == NULL) return 0; // حماية ضد الكراش
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname && strstr(info->dli_fname, TARGET_HACK)) {
        // تمويه الهاك كأنه ملف فيزياء رسمي من Apple
        info->dli_fname = "/System/Library/Frameworks/SceneKit.framework/SceneKit";
        info->dli_sname = "SCNPhysicsContact"; 
        return 1;
    }
    return result;
}

// ============================================================================
// 4. نظام الواجهة المستقر (Anti-Crash UI)
// ============================================================================
static void ShowTitaniumAlert() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        // استخدام نظام Scenes بدلاً من keyWindow المسبب للكراش
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
                }
            }
        }
        if (window && window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"💎 TITANIUM PRO" 
                                                                         message:@"Bundle Fix: ACTIVE\nLogs: CLEANED\nProtection: STABLE" 
                                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"START" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

__attribute__((constructor))
static void Init() {
    CleanGameLogs(); // تنظيف البصمات فور التشغيل
    struct rebinding rebinds[] = {
        {"bundleIdentifier", (void *)hooked_bundleIdentifier, (void **)&orig_bundleIdentifier},
        {"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr}
    };
    rebind_symbols(rebinds, 2);
    ShowTitaniumAlert();
}
