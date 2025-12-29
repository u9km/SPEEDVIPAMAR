#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import "fishhook.h"

// 🛡️ هدف الحماية (ملف libwebp المشفر سحابياً)
#define TARGET_HACK "libwebp"

// دالة حماية الذاكرة والتمويه الاحترافي
static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    if (addr == NULL) return 0; // حماية ضد عناوين الذاكرة الفارغة لمنع الكراش
    
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname && strstr(info->dli_fname, TARGET_HACK)) {
        // تمويه الدايلب كجزء من نظام الأمان الرسمي لتجاوز ACE 5.5+
        info->dli_fname = "/System/Library/Frameworks/Security.framework/Security";
        info->dli_sname = "SecItemCopyMatching"; 
        return 1;
    }
    return result;
}

// نظام إظهار التنبيه الآمن (Scene-Based UI) لمنع الكراش
static void ShowSafeWelcome() {
    // تأخير 20 ثانية لضمان استقرار محرك اللعبة تماماً
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        // حل مشكلة keyWindow المرفوضة في iOS الحديث
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
                }
            }
        }
        
        if (window && window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"💎 BLACK AND AMAR PRO MAX" 
                                                                         message:@"AI Shield: Titanium V7\nMode: Safe (No-Jailbreak)\nStatus: Protected" 
                                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"LETS GO" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

__attribute__((constructor))
static void Init() {
    // ربط الدوال باستخدام Fishhook بأسلوب خفيف لمنع اكتشاف الحماية
    rebind_symbols((struct rebinding[1]){{"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr}}, 1);
    ShowSafeWelcome();
}
