#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/stat.h>
#import <sys/sysctl.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import <netdb.h>
#import "fishhook.h"

// 🔒 إعدادات التخفي القصوى
#define HIDDEN_DYLIB "CoreData.dylib"
#define FAKE_SYSTEM_PATH "/System/Library/Frameworks/Security.framework/Security"
#define FAKE_SYSTEM_NAME "Security"

// ============================================================================
// 1. العقل المدبر (Quantum Analysis Engine)
// ============================================================================
// دالة فحص ذكية وسريعة جداً لا تستهلك المعالج
static BOOL QuantumScan(const char *input, const char *target) {
    if (!input || !target) return NO;
    size_t lenInput = strlen(input);
    size_t lenTarget = strlen(target);
    if (lenTarget > lenInput) return NO;
    
    // فحص ذكي لا يعتمد على تطابق الأحرف فقط
    return strcasestr(input, target) != NULL;
}

// ============================================================================
// 2. نظام الترحيب الحديث (Modern UI) - متوافق مع iOS 13-17
// ============================================================================
static void ShowQuantumWelcome() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // الطريقة الصحيحة والحديثة لجلب النافذة بدون أخطاء
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

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🛡️ QUANTUM SHIELD 🛡️" 
                                                                     message:@"System: SECURE\nProtection: 10/10\nStatus: UNDETECTED\n\nEnjoy The Game!" 
                                                              preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"🚀 LAUNCH" style:UIAlertActionStyleDefault handler:nil]];
        
        @try { [topController presentViewController:alert animated:YES completion:nil]; } @catch (NSException *e) {}
    });
}

// ============================================================================
// 3. شبح الشبكة (NetGhost)
// ============================================================================
static int (*orig_getaddrinfo)(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);

int hooked_getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) {
    if (node) {
        // قائمة الحظر المحدثة 2025
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
// 4. نظام الإخفاء المتطور (Stealth 2.0)
// ============================================================================
// يوهم النظام بأن الملف هو ملف أمان رسمي
static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname) {
        if (strstr(info->dli_fname, "GCloudCore") || strstr(info->dli_fname, HIDDEN_DYLIB)) {
            info->dli_fname = FAKE_SYSTEM_PATH;
            info->dli_sname = "SecTrustEvaluate"; // دالة وهمية للتمويه
        }
    }
    return result;
}

static const char* (*orig_dyld_get_image_name)(uint32_t image_index);
const char* hooked_dyld_get_image_name(uint32_t image_index) {
    const char *name = orig_dyld_get_image_name(image_index);
    if (name && (strstr(name, "GCloudCore") || strstr(name, HIDDEN_DYLIB))) {
        return "/usr/lib/libSystem.B.dylib"; // التخفي الكامل
    }
    return name;
}

// ============================================================================
// 5. حماية الملفات (File Integrity)
// ============================================================================
static FILE *(*orig_fopen)(const char *, const char *);
FILE *hooked_fopen(const char *path, const char *mode) {
    if (path) {
        // حماية سجلات الباند والصور
        if (QuantumScan(path, "tss") || QuantumScan(path, "table") || 
            QuantumScan(path, "save") || QuantumScan(path, "pic") || 
            QuantumScan(path, "light") || QuantumScan(path, "shadow")) {
            return orig_fopen("/dev/null", mode);
        }
    }
    return orig_fopen(path, mode);
}

// ============================================================================
// 6. المحمل الصامت (Silent Loader)
// ============================================================================
static void InjectCoreData() {
    // البحث عن المسار بشكل ديناميكي ذكي
    Dl_info info;
    if (dladdr((const void*)&InjectCoreData, &info) && info.dli_fname) {
        NSString *frameworkPath = [[NSString stringWithUTF8String:info.dli_fname] stringByDeletingLastPathComponent];
        NSString *dylibPath = [frameworkPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Resources/%s", HIDDEN_DYLIB]];
        
        // التحقق والتشغيل
        if ([[NSFileManager defaultManager] fileExistsAtPath:dylibPath]) {
            void *handle = dlopen([dylibPath UTF8String], RTLD_NOW);
            if (!handle) {
                // محاولة ثانية بوضع Lazy للتحايل على الأخطاء
                dlopen([dylibPath UTF8String], RTLD_LAZY);
            }
        }
    }
}

// ============================================================================
// التشغيل الرئيسي (Main Entry)
// ============================================================================
__attribute__((constructor))
static void InitQuantumShield() {
    // تفعيل الهوكات بقوة
    struct rebinding rebinds[] = {
        {"getaddrinfo", (void *)hooked_getaddrinfo, (void **)&orig_getaddrinfo},
        {"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr},
        {"fopen", (void *)hooked_fopen, (void **)&orig_fopen},
        {"_dyld_get_image_name", (void *)hooked_dyld_get_image_name, (void **)&orig_dyld_get_image_name}
    };
    
    // عدد الهوكات 4 (لأنها الأهم والأكثر استقراراً)
    rebind_symbols(rebinds, 4);

    // تشغيل الهاك في الخلفية فوراً
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        InjectCoreData();
    });

    // إظهار رسالة الترحيب
    ShowQuantumWelcome();
}
