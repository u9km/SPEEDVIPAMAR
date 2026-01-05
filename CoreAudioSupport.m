#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <sys/mman.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>

// 👻 V42: The Silencer - مكافحة ذكية للتقارير
@interface CAStreamOptimizer : NSObject
+ (instancetype)shared;
- (void)activateActiveSilencer; // الحارس النشط
@end

// 1. تزوير هوية النظام (لمنع تتبع Kernel)
static int (*orig_sysctl_v42)(int *, u_int, void *, size_t *, void *, size_t);
int hooked_sysctl_v42(int *name, u_int namelen, void *info, size_t *infosize, void *newp, size_t newlen) {
    if (namelen >= 4 && name[0] == CTL_KERN && name[1] == KERN_PROC && name[2] == KERN_PROC_PID) {
        int ret = orig_sysctl_v42(name, namelen, info, infosize, newp, newlen);
        struct kinfo_proc *p = (struct kinfo_proc *)info;
        if (p) p->kp_proc.p_flag &= ~P_TRACED; // إزالة علامة المراقبة
        return ret;
    }
    return orig_sysctl_v42(name, namelen, info, infosize, newp, newlen);
}

@implementation CAStreamOptimizer
+ (instancetype)shared {
    static CAStreamOptimizer *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ inst = [[self alloc] init]; });
    return inst;
}

- (void)activateActiveSilencer {
    // 🔥 الذكاء هنا: خيط منفصل يعمل للأبد (Infinite Loop)
    // مهمته الوحيدة: التأكد من أن اللعبة لا تملك "قلم ورقة" لكتابة التقارير
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // قائمة المجلدات الخبيثة التي تخزن أدلة ضدك
        NSArray *evidencePaths = @[
            [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ShadowTrackerExtra/Saved/Logs"],
            [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ShadowTrackerExtra/Saved/Paks"], // أحياناً يخزنون الصور هنا
            [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CrashReports"],
            [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.crashlytics.data"],
            [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
        ];

        while (YES) {
            for (NSString *path in evidencePaths) {
                NSFileManager *fm = [NSFileManager defaultManager];
                
                // 1. فحص: هل المجلد موجود وهو "مجلد حقيقي"؟ (يعني اللعبة أصلحته)
                BOOL isDir;
                if ([fm fileExistsAtPath:path isDirectory:&isDir] && isDir) {
                    // 2. الهجوم: تدمير المجلد فوراً
                    [fm removeItemAtPath:path error:nil];
                }
                
                // 3. الإغلاق: إنشاء ثقب أسود مكانه (Symlink to /dev/null)
                // إذا كان الرابط موجوداً، هذا الأمر سيفشل بصمت (وهذا جيد)
                // إذا كانت اللعبة قد حذفت الرابط، سنعيده فوراً
                symlink("/dev/null", [path UTF8String]);
            }
            
            // استراحة المحارب: نصف ثانية ثم نعيد الفحص
            [NSThread sleepForTimeInterval:0.5];
        }
    });
}
@end

// نقطة البداية (Entry Point)
__attribute__((constructor))
static void AudioEngineStart() {
    // 1. تفعيل الكاتم النشط فوراً (قبل أي شيء)
    [[CAStreamOptimizer shared] activateActiveSilencer];

    // 2. قتل المخرجات القياسية
    freopen("/dev/null", "w", stdout);
    freopen("/dev/null", "w", stderr);

    // 3. التمويه والتأخير (استراتيجية Phantom)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // انتظار 20 ثانية لتجاوز فحص الإقلاع
        [NSThread sleepForTimeInterval:20.0];
        
        // عزل الذاكرة بعد الاستقرار
        uintptr_t header = (uintptr_t)_dyld_get_image_header(0);
        mprotect((void *)(header & ~0xFFF), 4096, PROT_NONE);
    });
}
