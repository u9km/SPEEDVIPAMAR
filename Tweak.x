#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <netdb.h>
#import <objc/runtime.h>
#import "fishhook.h"

// 🎯 الهدف المحمي (اسم ملف الهاك المشفر سحابياً في Esign)
#define TARGET_HACK "libwebp"

// ============================================================================
// 1. تجاوز فحص البصمة والتشفير السحابي (Cloud Bypass)
// ============================================================================
static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname) {
        // تمويه الدايلب كأنه مكتبة Security الرسمية لتبرير وجود التشفير السحابي
        if (strstr(info->dli_fname, TARGET_HACK)) {
            info->dli_fname = "/System/Library/Frameworks/Security.framework/Security";
            info->dli_sname = "SecItemCopyMatching"; 
            return 1;
        }
    }
    return result;
}

// ============================================================================
// 2. حماية الذاكرة والفيزياء (Bullet Track Shield)
// ============================================================================
static const char* (*orig_dyld_get_image_name)(uint32_t image_index);
const char* hooked_dyld_get_image_name(uint32_t image_index) {
    const char *name = orig_dyld_get_image_name(image_index);
    if (name && strstr(name, TARGET_HACK)) {
        // إخفاء المسار الحقيقي للملف عن رادار الحماية ACE
        return "/usr/lib/libSystem.B.dylib";
    }
    return name;
}

// ============================================================================
// 3. قطع الاتصال بسيرفرات الحماية السحابية (AI Firewall)
// ============================================================================
static int (*orig_getaddrinfo)(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);
int hooked_getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) {
    if (node) {
        // حظر سيرفرات تحليل التشفير السحابي والتبليغات المسؤولة عن باند اللوبي
        if (strstr(node, "ace") || strstr(node, "cloud") || strstr(node, "report") || strstr(node, "vmp") || strstr(node, "log")) {
            return EAI_NONAME;
        }
    }
    return orig_getaddrinfo(node, service, hints, res);
}

// ============================================================================
// 4. واجهة الترحيب VIP (مصححة الأقواس برمجياً)
// ============================================================================
static void ShowWelcome() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
        if (!window) return;
        
        UIViewController *top = window.rootViewController;
        while (top.presentedViewController) {
            top = top.presentedViewController;
        }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"💎 BLACK AND AMAR CLOUD PRO" 
                                                                     message:@"Cloud Encryption: BYPASSED\nBullet Track: PROTECTED\nSecurity: TITANIUM V6.0" 
                                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"START GAME" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [top presentViewController:alert animated:YES completion:nil];
    });
}

__attribute__((constructor))
static void Init() {
    struct rebinding rebinds[] = {
        {"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr},
        {"getaddrinfo", (void *)hooked_getaddrinfo, (void **)&orig_getaddrinfo},
        {"_dyld_get_image_name", (void *)hooked_dyld_get_image_name, (void **)&orig_dyld_get_image_name}
    };
    rebind_symbols(rebinds, 3);
    ShowWelcome();
}
