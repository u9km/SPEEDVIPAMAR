#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <netdb.h>
#import "fishhook.h"

// 🛡️ الهدف المحمي (ملف التفعيلات الخاص بك)
#define TARGET_HACK "libwebp"

// ============================================================================
// 1. حماية الذاكرة والفيزياء (تجاوز باند نهاية الجيم وباند 10 سنين)
// ============================================================================
static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    if (addr == NULL) return 0; // منع الكراش عند العناوين الفارغة
    
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname && strstr(info->dli_fname, TARGET_HACK)) {
        // تمويه الهاك كأنه مكتبة "SceneKit" الرسمية لمنع فحص السلوك في نهاية الجيم
        info->dli_fname = "/System/Library/Frameworks/SceneKit.framework/SceneKit";
        info->dli_sname = "SCNPhysicsContact"; 
        return 1;
    }
    return result;
}

// ============================================================================
// 2. جدار الحماية (منع بلاغات المحققين وباند البلاغات)
// ============================================================================
static int (*orig_getaddrinfo)(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);
int hooked_getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) {
    if (node) {
        // حظر سيرفرات التبليغ المباشر ACE لضمان عدم وصول بلاغات اللاعبين
        if (strstr(node, "report") || strstr(node, "ace") || strstr(node, "shield") || strstr(node, "audit")) {
            return EAI_NONAME;
        }
    }
    return orig_getaddrinfo(node, service, hints, res);
}

// ============================================================================
// 3. نظام إظهار الرسائل المطور (منع كراش الدخول)
// ============================================================================
static void ShowSafeWelcome() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        // حل خطأ keyWindow المسبب للكراش في iOS الحديث
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
                }
            }
        }
        if (window && window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"💎 TITANIUM PRO ACTIVE" 
                                                                         message:@"AI Shield: ENABLED\nStatus: UNDETECTED" 
                                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"START" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

__attribute__((constructor))
static void Init() {
    struct rebinding rebinds[] = {
        {"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr},
        {"getaddrinfo", (void *)hooked_getaddrinfo, (void **)&orig_getaddrinfo}
    };
    rebind_symbols(rebinds, 2);
    ShowSafeWelcome();
}
