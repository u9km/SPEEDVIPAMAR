#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <netdb.h>
#import <objc/runtime.h>
#import "fishhook.h"

// 🛡️ تعريف الهدف (تأكد أن ملف الهاك في Esign اسمه libwebp.dylib)
#define TARGET_HACK "libwebp"

// ============================================================================
// 1. حماية البولت تراك (Memory Masking)
// ============================================================================
static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname) {
        if (strstr(info->dli_fname, TARGET_HACK)) {
            // تزوير هوية الملف ليبدو كمكتبة SceneKit الرسمية للفيزياء
            info->dli_fname = "/System/Library/Frameworks/SceneKit.framework/SceneKit";
            info->dli_sname = "SCNPhysicsContact"; 
            return 1;
        }
    }
    return result;
}

// ============================================================================
// 2. إخفاء ملفات الجيلبريك (Anti-Root Detection)
// ============================================================================
static int (*orig_stat)(const char *, struct stat *);
int hooked_stat(const char *path, struct stat *buf) {
    if (path) {
        if (strstr(path, "Cydia") || strstr(path, "Sileo") || strstr(path, "Tweak") || strstr(path, "Filza")) {
            errno = ENOENT;
            return -1;
        }
    }
    return orig_stat(path, buf);
}

// ============================================================================
// 3. جدار الحماية الذكي (AI Firewall)
// ============================================================================
static int (*orig_getaddrinfo)(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);
int hooked_getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) {
    if (node) {
        // حظر سيرفرات التبليغ فقط دون التأثير على استقرار اللعبة
        if (strstr(node, "report") || strstr(node, "ace") || strstr(node, "shield") || strstr(node, "log")) {
            return EAI_NONAME;
        }
    }
    return orig_getaddrinfo(node, service, hints, res);
}

// ============================================================================
// 4. إخفاء صورة الملف (Ghost Mode)
// ============================================================================
static const char* (*orig_dyld_get_image_name)(uint32_t image_index);
const char* hooked_dyld_get_image_name(uint32_t image_index) {
    const char *name = orig_dyld_get_image_name(image_index);
    if (name && strstr(name, TARGET_HACK)) {
        return "/usr/lib/libobjc.A.dylib";
    }
    return name;
}

// ============================================================================
// 5. واجهة ترحيب احترافية (VIP UI)
// ============================================================================
static void ShowWelcome() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
        if (!window) return;
        
        UIViewController *top = window.rootViewController;
        while (top.presentedViewController) top = top.presentedViewController;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"💎 BLACK AND AMAR VIP PRO" 
                                                                     message:@"AI Core: TITANIUM\nBullet Shield: ACTIVE\nStatus: UNDETECTED" 
                                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"START GAME" style:UIAlertActionStyleDefault handler:nil]];
        [top presentViewController:alert animated:YES completion:nil];
    });
}

__attribute__((constructor))
static void Init() {
    struct rebinding rebinds[] = {
        {"stat", (void *)hooked_stat, (void **)&orig_stat},
        {"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr},
        {"getaddrinfo", (void *)hooked_getaddrinfo, (void **)&orig_getaddrinfo},
        {"_dyld_get_image_name", (void *)hooked_dyld_get_image_name, (void **)&orig_dyld_get_image_name}
    };
    rebind_symbols(rebinds, 4);
    ShowWelcome();
}
