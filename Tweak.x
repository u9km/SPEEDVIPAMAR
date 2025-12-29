#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/stat.h>
#import <sys/sysctl.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import <netdb.h>
#import "fishhook.h"

// 🎯 الأسماء التي نريد حمايتها (بناءً على خطتك)
// سيقوم الكود بإخفاء أي مسار يحتوي على هذه الكلمات
#define PROTECT_TARGET_1 "App.framework"  // مكان الحماية
#define PROTECT_TARGET_2 "libwebp"        // مكان التفعيلات

// التمويه: سنظهر للنظام أن هذه الملفات هي مكتبات صور تابعة للنظام
#define FAKE_PATH "/System/Library/Frameworks/ImageIO.framework/ImageIO"

// ============================================================================
// 1. المحرك الذكي (Smart Scan)
// ============================================================================
static BOOL SmartScan(const char *input, const char *pattern) {
    if (!input || !pattern) return NO;
    return strcasestr(input, pattern) != NULL;
}

// ============================================================================
// 2. واجهة الترحيب (Welcome Message)
// ============================================================================
static void ShowSplitModeMessage() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
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

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🛡️ GHOST MODE 🛡️" 
                                                                     message:@"📦 Injection: SPLIT\n📂 App.framework: SECURE\n📂 libwebp: HIDDEN\n⛔ Anti-Ban: ACTIVE" 
                                                              preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"GO" style:UIAlertActionStyleDefault handler:nil]];
        
        @try { [topController presentViewController:alert animated:YES completion:nil]; } @catch (NSException *e) {}
    });
}

// ============================================================================
// 3. نظام التخفي المزدوج (Double Stealth)
// ============================================================================
// هذه الدالة هي الأهم: تخفي الحماية وتخفي الهاك الموجود في libwebp
static const char* (*orig_dyld_get_image_name)(uint32_t image_index);
const char* hooked_dyld_get_image_name(uint32_t image_index) {
    const char *name = orig_dyld_get_image_name(image_index);
    if (name) {
        // إذا كان الملف هو الحماية أو الهاك
        if (strstr(name, PROTECT_TARGET_1) || strstr(name, PROTECT_TARGET_2)) {
            return "/usr/lib/libSystem.B.dylib"; // اجعله يبدو كملف نظام
        }
    }
    return name;
}

static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname) {
        // تزوير المعلومات عند الفحص
        if (strstr(info->dli_fname, PROTECT_TARGET_1) || strstr(info->dli_fname, PROTECT_TARGET_2)) {
            info->dli_fname = FAKE_PATH;
            info->dli_sname = "CGImageSourceCreate"; // دالة وهمية للصور
        }
    }
    return result;
}

// ============================================================================
// 4. حماية الذاكرة (Memory Guard)
// ============================================================================
static void* (*orig_dlsym)(void *, const char *);
void* hooked_dlsym(void *handle, const char *symbol) {
    if (symbol) {
        // حماية كشف الذاكرة المعتادة
        if (SmartScan(symbol, "MSHook") || SmartScan(symbol, "Substrate") || 
            SmartScan(symbol, "Cydia") || SmartScan(symbol, "Esp")) {
            return NULL; 
        }
    }
    return orig_dlsym(handle, symbol);
}

// ============================================================================
// 5. جدار الحماية (Firewall)
// ============================================================================
static int (*orig_getaddrinfo)(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);
int hooked_getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) {
    if (node) {
        const char *blacklist[] = {
            "log", "report", "crash", "analytics", "data", "trace", "bugly", 
            "beacon", "tpns", "gcloud", "tdid", "monitor", "shield", "ace"
        };
        for (int i = 0; i < 14; i++) {
            if (SmartScan(node, blacklist[i])) return EAI_NONAME;
        }
    }
    return orig_getaddrinfo(node, service, hints, res);
}

// ============================================================================
// 6. إخفاء الملفات (File Stealth)
// ============================================================================
static int (*orig_stat)(const char *, struct stat *);
int hooked_stat(const char *path, struct stat *buf) {
    if (path) {
        if (SmartScan(path, "Cydia") || SmartScan(path, "Substrate") || 
            SmartScan(path, "Tweak") || strstr(path, "apt/") || 
            SmartScan(path, "Filza")) {
            errno = ENOENT;
            return -1;
        }
    }
    return orig_stat(path, buf);
}

static FILE *(*orig_fopen)(const char *, const char *);
FILE *hooked_fopen(const char *path, const char *mode) {
    if (path) {
        if (SmartScan(path, "tss") || SmartScan(path, "save") || 
            SmartScan(path, "pic") || SmartScan(path, "trace")) {
            return orig_fopen("/dev/null", mode);
        }
    }
    return orig_fopen(path, mode);
}

// ============================================================================
// التشغيل (Init)
// ============================================================================
__attribute__((constructor))
static void InitSplitShield() {
    struct rebinding rebinds[] = {
        {"getaddrinfo", (void *)hooked_getaddrinfo, (void **)&orig_getaddrinfo},
        {"dlsym", (void *)hooked_dlsym, (void **)&orig_dlsym},
        {"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr},
        {"stat", (void *)hooked_stat, (void **)&orig_stat},
        {"fopen", (void *)hooked_fopen, (void **)&orig_fopen},
        {"_dyld_get_image_name", (void *)hooked_dyld_get_image_name, (void **)&orig_dyld_get_image_name}
    };
    
    rebind_symbols(rebinds, 6);
    ShowSplitModeMessage();
}
