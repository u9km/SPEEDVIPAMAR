#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/stat.h>
#import <sys/sysctl.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import <netdb.h>
#import "fishhook.h"

// إعدادات النظام
#define HIDDEN_DYLIB_NAME "CoreData.dylib"

// ============================================================================
// 1. محرك الذكاء الاصطناعي (AI Analysis Core)
// ============================================================================
static BOOL SmartScan(const char *input, const char *pattern) {
    if (!input || !pattern) return NO;
    if (input[0] != pattern[0]) return NO;
    return strcasestr(input, pattern) != NULL;
}

// ============================================================================
// 2. نظام الترحيب (Safe UI) - تم التحديث للإصلاح
// ============================================================================
static void ShowWelcomeMessage() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // --- FIX: استخدام الطريقة الحديثة لجلب النافذة ---
        UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
        UIViewController *topController = window.rootViewController;
        // ------------------------------------------------
        
        if (!topController) return;
        while (topController.presentedViewController) topController = topController.presentedViewController;

        NSString *title = @"⚡ BLACK AND AMAR VIP ⚡";
        NSString *msg = @"🔰 PROTECTION: ACTIVE\n🌍 SERVER: BLOCKED\n🔫 BULLET FIX: ON\n🚀 VERSION: TITANIUM\n\nEnjoy Safely!";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title 
                                                                     message:msg 
                                                              preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *startBtn = [UIAlertAction actionWithTitle:@"🔥 START" 
                                                           style:UIAlertActionStyleDefault 
                                                         handler:nil];
        
        UIAlertAction *tgBtn = [UIAlertAction actionWithTitle:@"📢 CHANNEL" 
                                                        style:UIAlertActionStyleDestructive 
                                                      handler:^(UIAlertAction * action) {
            NSURL *url = [NSURL URLWithString:@"https://t.me/turbo506"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) 
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }];

        [alert addAction:startBtn];
        [alert addAction:tgBtn];

        @try { [topController presentViewController:alert animated:YES completion:nil]; } @catch (NSException *e) {}
    });
}

// ============================================================================
// 3. جدار الحماية (Firewall)
// ============================================================================
static int (*orig_getaddrinfo)(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);

int hooked_getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) {
    if (node) {
        if (SmartScan(node, "log") || SmartScan(node, "report") || 
            SmartScan(node, "tpns") || SmartScan(node, "beacon") || 
            SmartScan(node, "bugly") || SmartScan(node, "crash") || 
            SmartScan(node, "data") || SmartScan(node, "analytics") || 
            SmartScan(node, "gcloud") || SmartScan(node, "tdid") || 
            SmartScan(node, "rekoo") || SmartScan(node, "proxima")) {
            return EAI_NONAME;
        }
    }
    return orig_getaddrinfo(node, service, hints, res);
}

// ============================================================================
// 4. معالج الفيزياء (Bullet Track Fix)
// ============================================================================
static void* (*orig_dlsym)(void *, const char *);

void* hooked_dlsym(void *handle, const char *symbol) {
    if (symbol) {
        if (SmartScan(symbol, "VerifyHit") || SmartScan(symbol, "ProcessHit") || 
            SmartScan(symbol, "CheckBullet") || SmartScan(symbol, "ReportHit") || 
            SmartScan(symbol, "ServerNotify") || SmartScan(symbol, "Anticheat")) {
            return NULL; 
        }
        if (SmartScan(symbol, "Aim") || SmartScan(symbol, "Recoil") || 
            SmartScan(symbol, "Bullet") || SmartScan(symbol, "Esp") || 
            SmartScan(symbol, "Wall") || SmartScan(symbol, "Color")) {
            return NULL; 
        }
        if (SmartScan(symbol, "Parachute") || SmartScan(symbol, "Skydive") || 
            SmartScan(symbol, "Landing") || SmartScan(symbol, "Auto")) {
            return NULL;
        }
        if (SmartScan(symbol, "Upload") || SmartScan(symbol, "Send") || 
            SmartScan(symbol, "Log")) {
            return NULL;
        }
    }
    return orig_dlsym(handle, symbol);
}

// ============================================================================
// 5. ماسحة السجلات (Log Wiper)
// ============================================================================
static FILE *(*orig_fopen)(const char *, const char *);

FILE *hooked_fopen(const char *path, const char *mode) {
    if (path) {
        BOOL isSensitive = (SmartScan(path, "battle") || SmartScan(path, "report") || 
                            SmartScan(path, "trace") || SmartScan(path, "log"));
        BOOL isEvidence = (SmartScan(path, "High") || SmartScan(path, "Death") || 
                           SmartScan(path, "Moment") || SmartScan(path, "Pic"));

        if (isSensitive || isEvidence) {
            return orig_fopen("/dev/null", mode);
        }
    }
    return orig_fopen(path, mode);
}

// ============================================================================
// 6. التخفي (Stealth)
// ============================================================================
static const char* (*orig_dyld_get_image_name)(uint32_t image_index);
const char* hooked_dyld_get_image_name(uint32_t image_index) {
    const char *name = orig_dyld_get_image_name(image_index);
    if (name && (strstr(name, "GCloudCore") || strstr(name, HIDDEN_DYLIB_NAME))) {
        return "/usr/lib/libSystem.B.dylib";
    }
    return name;
}

static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    int ret = orig_dladdr(addr, info);
    if (ret != 0 && info && info->dli_fname) {
        if (strstr(info->dli_fname, "GCloudCore") || strstr(info->dli_fname, HIDDEN_DYLIB_NAME)) {
            info->dli_fname = "/System/Library/Frameworks/Security.framework/Security";
            info->dli_sname = "SecItemAdd"; 
        }
    }
    return ret;
}

// ============================================================================
// 7. فحص السلامة (Integrity)
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

static void* (*orig_dlopen)(const char*, int);
void* hooked_dlopen(const char *path, int mode) {
    if (path && (strstr(path, "TenProtect") || strstr(path, "MTP") || 
                 strstr(path, "Ano") || strstr(path, "ACE"))) {
        return NULL;
    }
    return orig_dlopen(path, mode);
}

// ============================================================================
// 8. المحمل (Loader)
// ============================================================================
static void LoadHiddenModule() {
    Dl_info info;
    dladdr((const void*)&LoadHiddenModule, &info);
    if (!info.dli_fname) return;

    NSString *currentPath = [NSString stringWithUTF8String:info.dli_fname];
    NSString *frameworkPath = [currentPath stringByDeletingLastPathComponent];
    NSString *targetPath = [NSString stringWithFormat:@"%@/Resources/%s", frameworkPath, HIDDEN_DYLIB_NAME];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        dlopen([targetPath UTF8String], RTLD_NOW);
    }
}

// ============================================================================
// التشغيل (Initialization)
// ============================================================================
__attribute__((constructor))
static void InitDiamond() {
    struct rebinding rebinds[] = {
        {"getaddrinfo", (void *)hooked_getaddrinfo, (void **)&orig_getaddrinfo},
        {"dlsym", (void *)hooked_dlsym, (void **)&orig_dlsym},
        {"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr},
        {"stat", (void *)hooked_stat, (void **)&orig_stat},
        {"dlopen", (void *)hooked_dlopen, (void **)&orig_dlopen},
        {"fopen", (void *)hooked_fopen, (void **)&orig_fopen},
        {"_dyld_get_image_name", (void *)hooked_dyld_get_image_name, (void **)&orig_dyld_get_image_name}
    };
    
    rebind_symbols(rebinds, 7);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        LoadHiddenModule();
    });

    ShowWelcomeMessage();
}
