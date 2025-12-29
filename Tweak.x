#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/stat.h>
#import <sys/sysctl.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import <netdb.h>
#import "fishhook.h"

// 🔒 إعدادات التخفي (ما زلنا نحتفظ بالاسم هنا فقط لغرض "الإخفاء" إذا قمت بحقنه يدوياً)
#define HIDDEN_DYLIB "CoreData.dylib"
#define FAKE_SYSTEM_PATH "/System/Library/Frameworks/Security.framework/Security"
#define FAKE_SYSTEM_NAME "Security"

// ============================================================================
// 1. العقل المدبر (Quantum Analysis Engine)
// ============================================================================
static BOOL QuantumScan(const char *input, const char *target) {
    if (!input || !target) return NO;
    size_t lenInput = strlen(input);
    size_t lenTarget = strlen(target);
    if (lenTarget > lenInput) return NO;
    return strcasestr(input, target) != NULL;
}

// ============================================================================
// 2. نظام الترحيب (Safe UI)
// ============================================================================
static void ShowQuantumWelcome() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (!window) window = [[UIApplication sharedApplication] windows].firstObject;
        
        UIViewController *topController = window.rootViewController;
        while (topController.presentedViewController) topController = topController.presentedViewController;

        if (!topController) return;

        // رسالة مختلفة لتوضيح أن الوضع "حماية فقط"
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🛡️ PURE SHIELD ACTIVE 🛡️" 
                                                                     message:@"System: SECURED\nAuto-Load: OFF\nStatus: WAITING FOR INJECTION..." 
                                                              preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        @try { [topController presentViewController:alert animated:YES completion:nil]; } @catch (NSException *e) {}
    });
}

// ============================================================================
// 3. شبح الشبكة (NetGhost)
// ============================================================================
static int (*orig_getaddrinfo)(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);

int hooked_getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) {
    if (node) {
        const char *blacklist[] = {
            "log", "report", "crash", "analytics", "data", "trace", "bugly", 
            "beacon", "tpns", "gcloud", "tdid", "monitor", "shield", "ace"
        };
        
        for (int i = 0; i < 14; i++) {
            if (QuantumScan(node, blacklist[i])) return EAI_NONAME;
        }
    }
    return orig_getaddrinfo(node, service, hints, res);
}

// ============================================================================
// 4. نظام الإخفاء (Stealth) - يحميك حتى لو حقنت الهاك يدوياً
// ============================================================================
static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname) {
        // إذا اكتشفنا ملف الهاك أو ملف الحماية، نقوم بتزوير بياناته
        if (strstr(info->dli_fname, "GCloudCore") || strstr(info->dli_fname, HIDDEN_DYLIB)) {
            info->dli_fname = FAKE_SYSTEM_PATH;
            info->dli_sname = "SecTrustEvaluate"; 
        }
    }
    return result;
}

static const char* (*orig_dyld_get_image_name)(uint32_t image_index);
const char* hooked_dyld_get_image_name(uint32_t image_index) {
    const char *name = orig_dyld_get_image_name(image_index);
    // إخفاء الاسم الحقيقي عن اللعبة
    if (name && (strstr(name, "GCloudCore") || strstr(name, HIDDEN_DYLIB))) {
        return "/usr/lib/libSystem.B.dylib";
    }
    return name;
}

// ============================================================================
// 5. حماية الملفات (File Integrity)
// ============================================================================
static FILE *(*orig_fopen)(const char *, const char *);
FILE *hooked_fopen(const char *path, const char *mode) {
    if (path) {
        if (QuantumScan(path, "tss") || QuantumScan(path, "table") || 
            QuantumScan(path, "save") || QuantumScan(path, "pic") || 
            QuantumScan(path, "light") || QuantumScan(path, "shadow")) {
            return orig_fopen("/dev/null", mode);
        }
    }
    return orig_fopen(path, mode);
}

// ============================================================================
// التشغيل الرئيسي (Main Entry)
// ============================================================================
__attribute__((constructor))
static void InitQuantumShield() {
    // تفعيل الهوكات (حماية + إخفاء + منع اتصالات)
    struct rebinding rebinds[] = {
        {"getaddrinfo", (void *)hooked_getaddrinfo, (void **)&orig_getaddrinfo},
        {"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr},
        {"fopen", (void *)hooked_fopen, (void **)&orig_fopen},
        {"_dyld_get_image_name", (void *)hooked_dyld_get_image_name, (void **)&orig_dyld_get_image_name}
    };
    
    rebind_symbols(rebinds, 4);
    
    // ⚠️ تم حذف دالة InjectCoreData نهائياً

    ShowQuantumWelcome();
}
