#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <netdb.h>
#import <objc/runtime.h>
#import "fishhook.h"

// الهدف المحمي (ملف الهاك الخاص بك)
#define TARGET_HACK "libwebp"

// ============================================================================
// حماية البولت تراك (Bullet Track Shield)
// ============================================================================
static int (*orig_dladdr)(const void *, Dl_info *);
int hooked_dladdr(const void *addr, Dl_info *info) {
    int result = orig_dladdr(addr, info);
    if (result && info && info->dli_fname) {
        if (strstr(info->dli_fname, TARGET_HACK)) {
            // تزوير الهوية لتظهر كمكتبة SceneKit الرسمية للفيزياء
            info->dli_fname = "/System/Library/Frameworks/SceneKit.framework/SceneKit";
            info->dli_sname = "SCNPhysicsContact"; 
            return 1;
        }
    }
    return result;
}

// ============================================================================
// حماية الشبكة (AI Network Guard)
// ============================================================================
static int (*orig_getaddrinfo)(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);
int hooked_getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) {
    if (node) {
        // حظر سيرفرات التبليغ ومنع إرسال سجلات البولت تراك
        if (strstr(node, "report") || strstr(node, "ace") || strstr(node, "shield") || strstr(node, "log")) {
            return EAI_NONAME;
        }
    }
    return orig_getaddrinfo(node, service, hints, res);
}

// ============================================================================
// إخفاء الملف عن رادار الحماية (Ghost Mode)
// ============================================================================
static const char* (*orig_dyld_get_image_name)(uint32_t image_index);
const char* hooked_dyld_get_image_name(uint32_t image_index) {
    const char *name = orig_dyld_get_image_name(image_index);
    if (name && strstr(name, TARGET_HACK)) {
        // التمويه كأهم مكتبة برمجية في النظام
        return "/usr/lib/libobjc.A.dylib";
    }
    return name;
}

// ============================================================================
// واجهة الترحيب الاحترافية
// ============================================================================
static void ShowWelcome() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
        UIViewController *top = window.rootViewController;
        while (top.presentedViewController) top = top.presentedViewController;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"💎 BLACK AND AMAR PRO" 
                                                                     message:@"AI Bullet Shield: ACTIVE\nStatus: UNDETECTED\nMode: GHOST" 
                                                              preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"START" style:UIAlertActionStyleDefault handler:nil]];
        [top present
