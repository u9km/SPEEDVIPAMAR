#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import "fishhook.h"

// 🛡️ هدف الحماية (ملف التفعيلات في Esign)
#define TARGET_HACK "libwebp"

static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    if (addr == NULL) return 0;
    
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname && strstr(info->dli_fname, TARGET_HACK)) {
        // تمويه الدايلب كجزء من نظام الأمان الرسمي
        info->dli_fname = "/System/Library/Frameworks/Security.framework/Security";
        info->dli_sname = "SecItemCopyMatching"; 
        return 1;
    }
    return result;
}

static void ShowSafeWelcome() {
    // تأخير الرسالة 15 ثانية لمنع الكراش عند بدء تشغيل اللعبة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        // حل مشكلة keyWindow المسببة للخطأ في صورتك
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
                }
            }
        }
        
        if (window && window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"💎 BLACK AND AMAR PRO" 
                                                                         message:@"AI Shield: TITANIUM\nStatus: Stable & Safe" 
                                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"START" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

__attribute__((constructor))
static void Init() {
    // تفعيل الحماية بأسلوب Fishhook الموثوق
    rebind_symbols((struct rebinding[1]){{"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr}}, 1);
    ShowSafeWelcome();
}
