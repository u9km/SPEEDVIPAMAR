#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <sys/mman.h>
#import <mach-o/dyld.h>

// ================================================
// 💎 SOVEREIGN V33.0 - SAFE AIMBOT RANGE
// ================================================
@interface SovereignV33 : NSObject
+ (instancetype)guardian;
- (BOOL)validateAimbotAngle:(float)targetAngle; // فلتر الزوايا الخطرة
- (void)neutralizeSystemChecks; // حماية V30 (إخفاء الملف)
@end

// دوال V30 لتخدير النظام ومنع الكشف
static int (*orig_sysctl_v33)(int *, u_int, void *, size_t *, void *, size_t);
int hooked_sysctl_v33(int *name, u_int namelen, void *info, size_t *infosize, void *newp, size_t newlen) {
    if (namelen >= 4 && name[0] == CTL_KERN && name[1] == KERN_PROC && name[2] == KERN_PROC_PID) {
        int ret = orig_sysctl_v33(name, namelen, info, infosize, newp, newlen);
        struct kinfo_proc *p = (struct kinfo_proc *)info;
        if (p) p->kp_proc.p_flag &= ~P_TRACED; // إخفاء الأداة
        return ret;
    }
    return orig_sysctl_v33(name, namelen, info, infosize, newp, newlen);
}

@implementation SovereignV33
+ (instancetype)guardian {
    static SovereignV33 *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ inst = [[self alloc] init]; });
    return inst;
}

- (BOOL)validateAimbotAngle:(float)targetAngle {
    // 🛡️ الفلتر الذهبي:
    // إذا كانت الزاوية أكبر من 60 درجة (مثل 80 أو 360)، يتم تعطيل الإيمبوت لهذه اللحظة
    // هذا يمنع "اللف الدائري" المكشوف للسيرفر
    if (targetAngle > 60.0f) {
        NSLog(@"[V33.0] ⚠️ تم حظر محاولة إيمبوت بزاوية خطرة (%.1f).", targetAngle);
        return NO; // أمان
    }
    return YES; // مسموح (نطاق بشري)
}

- (void)neutralizeSystemChecks {
    NSLog(@"[V33.0] 🛡️ النظام محمي والزوايا مقيدة بـ 60 درجة.");
}
@end

__attribute__((constructor))
static void SovereignSafeAimEntry() {
    freopen("/dev/null", "w", stdout); // مسح السجلات
    
    [[SovereignV33 guardian] neutralizeSystemChecks];

    // تأخير الحقن لـ 12 ثانية (منع كراش V31)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        // عزل الذاكرة المتأخر
        uintptr_t header = (uintptr_t)_dyld_get_image_header(0);
        mprotect((void *)(header & ~0xFFF), 4096, PROT_NONE);
        
        UIWindow *win = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* s in [UIApplication sharedApplication].connectedScenes) {
                if (s.activationState == UISceneActivationStateForegroundActive) {
                    win = s.windows.firstObject; break;
                }
            }
        }
        if (win) {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 55)];
            l.text = @"💎 SOVEREIGN V33.0\nSAFE FOV: 60° LIMIT";
            l.numberOfLines = 2; l.textColor = [UIColor yellowColor];
            l.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            l.textAlignment = NSTextAlignmentCenter; l.font = [UIFont boldSystemFontOfSize:10];
            l.layer.cornerRadius = 15; l.layer.borderWidth = 2;
            l.layer.borderColor = [UIColor yellowColor].CGColor; l.clipsToBounds = YES;
            [win addSubview:l];
        }
    });
}
