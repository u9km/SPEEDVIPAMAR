#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import "fishhook.h"

// 🛡️ الهدف المحمي (اسم الدايلب في Esign)
#define TARGET_HACK "libwebp"

static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    // حماية ضد الكراش: التأكد من أن العنوان غير فارغ
    if (addr == NULL) return 0;
    
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname && strstr(info->dli_fname, TARGET_HACK)) {
        // تمويه آمن لبيئة بدون جيلبريك
        info->dli_fname = "/System/Library/Frameworks/Security.framework/Security";
        info->dli_sname = "SecItemCopyMatching"; 
        return 1;
    }
    return result;
}

static void ShowWelcome() {
    // تأخير الرسالة 15 ثانية لمنع الكراش عند بدء تشغيل اللعبة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window && @available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
        }

        if (window && window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"💎 BLACK AND AMAR PRO" 
                                                                         message:@"Safe Mode: ACTIVE\nNo-Jailbreak: SUPPORTED" 
                                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

__attribute__((constructor))
static void Init() {
    // ربط الدوال بأسلوب Fishhook المستخدم في صورك الناجحة
    rebind_symbols((struct rebinding[1]){{"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr}}, 1);
    ShowWelcome();
}
