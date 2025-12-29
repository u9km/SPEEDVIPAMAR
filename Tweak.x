#import <Foundation/Foundation.h>
#import <sys/stat.h>
#import <sys/sysctl.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import "fishhook.h"

// ============================================================================
// إعدادات الملف المخفي (الذي ستضعه أنت لاحقاً)
// ============================================================================
#define HIDDEN_DYLIB_NAME "CoreData.dylib"

// ============================================================================
// 1. محرك الذكاء والتحليل (AI Engine)
// ============================================================================

// دالة فحص الرموز (لحماية تفعيلات الفل هاك)
static BOOL IsDangerousSymbol(const char *symbol) {
    if (!symbol) return NO;
    size_t len = strnlen(symbol, 256); // حماية ضد الكراش
    if (len == 0 || len >= 256) return NO;

    // كلمات مفتاحية للتفعيلات التي تبحث عنها اللعبة
    // نستخدم التجزئة لتجنب كشف الكلمات في ملفنا
    if (strcasestr(symbol, "Aim") && strcasestr(symbol, "Bot")) return YES;
    if (strcasestr(symbol, "Magic") && strcasestr(symbol, "Bullet")) return YES;
    if (strcasestr(symbol, "Recoil")) return YES;
    if (strcasestr(symbol, "ESP")) return YES;
    if (strcasestr(symbol, "Wall")) return YES;
    if (strcasestr(symbol, "Hook")) return YES;
    
    return NO;
}

// دالة فحص الملفات
static int AI_AnalyzeRisk(const char *path) {
    if (!path) return 0;
    size_t len = strnlen(path, 1024);
    if (len == 0 || len >= 1024) return 0;
    
    @try {
        // فحص سريع للمسارات الخطيرة
        if (strcasestr(path, "Cydia") || strcasestr(path, "Substrate") || 
            strcasestr(path, "Tweak") || strcasestr(path, "apt/")) {
            return 100;
        }
        return 0;
    } @catch (NSException *e) { return 0; }
}

// ============================================================================
// 2. المؤشرات الأصلية
// ============================================================================
static int (*orig_stat)(const char *, struct stat *);
static int (*orig_dladdr)(const void *, Dl_info *);
static int (*orig_sysctl)(int *, u_int, void *, size_t *, void *, size_t);
static void* (*orig_dlopen)(const char*, int);
static void* (*orig_dlsym)(void *, const char *);

// ============================================================================
// 3. الهوكات النشطة (Active Protection)
// ============================================================================

// [هام] هوك dlsym: يعمي اللعبة عن رؤية دوال الهاك
void* hooked_dlsym(void *handle, const char *symbol) {
    if (IsDangerousSymbol(symbol)) {
        return NULL; // الدالة غير موجودة (تمويه)
    }
    return orig_dlsym(handle, symbol);
}

// هوك الهوية: إخفاء الفريم وورك
int hooked_dladdr(const void *addr, Dl_info *info) {
    int ret = orig_dladdr(addr, info);
    if (ret != 0 && info && info->dli_fname) {
        if (strstr(info->dli_fname, "GCloudCore") || strstr(info->dli_fname, HIDDEN_DYLIB_NAME)) {
            info->dli_fname = "/usr/lib/libSystem.B.dylib";
            info->dli_sname = "mach_msg"; 
        }
    }
    return ret;
}

// هوك الملفات
int hooked_stat(const char *path, struct stat *buf) {
    if (AI_AnalyzeRisk(path) > 50) {
        errno = ENOENT;
        return -1;
    }
    return orig_stat(path, buf);
}

// هوك منع تحميل الحمايات (Anti-Cheat Modules)
void* hooked_dlopen(const char *path, int mode) {
    if (path) {
        if (strcasestr(path, "TenProtect") || strcasestr(path, "MTP") || strcasestr(path, "ACE")) {
            return NULL; 
        }
    }
    return orig_dlopen(path, mode);
}

// هوك الكيرنل (Anti-Debug)
int hooked_sysctl(int *name, u_int namelen, void *oldp, size_t *oldlenp, void *newp, size_t newlen) {
    if (namelen >= 2 && name && name[0] == CTL_KERN && name[1] == KERN_PROC) {
        int ret = orig_sysctl(name, namelen, oldp, oldlenp, newp, newlen);
        if (ret == 0 && oldp && oldlenp && *oldlenp >= sizeof(struct kinfo_proc)) {
            struct kinfo_proc *proc = (struct kinfo_proc *)oldp;
            if ((proc->kp_proc.p_flag & 0x800) != 0) { // P_TRACED
                proc->kp_proc.p_flag &= ~0x800;
            }
        }
        return ret;
    }
    return orig_sysctl(name, namelen, oldp, oldlenp, newp, newlen);
}

// ============================================================================
// 4. نظام التحميل (Loader System)
// ============================================================================
static void LoadHiddenModule() {
    Dl_info info;
    dladdr((const void*)&LoadHiddenModule, &info);
    if (!info.dli_fname) return;

    NSString *currentLibPath = [NSString stringWithUTF8String:info.dli_fname];
    NSString *frameworkPath = [currentLibPath stringByDeletingLastPathComponent];
    // المسار: GCloudCore.framework/Resources/CoreData.dylib
    NSString *targetPath = [NSString stringWithFormat:@"%@/Resources/%s", frameworkPath, HIDDEN_DYLIB_NAME];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        void *handle = dlopen([targetPath UTF8String], RTLD_NOW);
        if (handle) {
            NSLog(@"[GCloudCore] ✅ Core Module Loaded Successfully.");
        }
    }
}

// ============================================================================
// 5. التشغيل
// ============================================================================
__attribute__((constructor))
static void InitFramework() {
    struct rebinding rebinds[] = {
        {"dlsym", (void *)hooked_dlsym, (void **)&orig_dlsym},
        {"dladdr", (void *)hooked_dladdr, (void **)&orig_dladdr},
        {"stat", (void *)hooked_stat, (void **)&orig_stat},
        {"sysctl", (void *)hooked_sysctl, (void **)&orig_sysctl},
        {"dlopen", (void *)hooked_dlopen, (void **)&orig_dlopen}
    };
    rebind_symbols(rebinds, 5);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LoadHiddenModule();
    });
}

