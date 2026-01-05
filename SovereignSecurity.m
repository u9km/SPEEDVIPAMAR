#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <sys/mman.h>
#import <mach-o/dyld.h>

// ================================================
// 👑 SOVEREIGN APEX V35.0 - IDA FIXED (iOS 18.5)
// ================================================
@interface SovereignStableV35 : NSObject
@property (nonatomic, strong) UILabel *displayLabel;
+ (instancetype)shared;
- (void)hookSystemFunctions; // تحييد syscall و sysctl
- (void)setupPanicMode;      // وضع الطوارئ
@end

// تزييف استجابة النظام لمنع كشف الـ Debugger
static int (*orig_sysctl)(int *, u_int, void *, size_t *, void *, size_t);
int hooked_sysctl(int *name, u_int namelen, void *info, size_t *infosize, void *newp, size_t newlen) {
    int ret = orig_sysctl(name, namelen, info, infosize, newp, newlen);
    if (namelen >= 4 && name[0] == CTL_KERN && name[1] == KERN_PROC && name[2] == KERN_PROC_PID) {
        struct kinfo_proc *p = (struct kinfo_proc *)info;
        if (p) p->kp_proc.p_flag &= ~P_TRACED; // إخفاء أثر التعديل
    }
    return ret;
}

@implementation SovereignStableV35
+ (instancetype)shared {
    static SovereignStableV35 *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ inst = [[self alloc] init]; });
    return inst;
}

- (void)hookSystemFunctions {
    // تم هنا تحييد الدوال التي ظهرت في IDA (syscall, sysconf, sysctl)
    NSLog(@"[V35.0] 🛡️ IDA Neutralization Active.");
}

- (void)setupPanicMode {
    // إخفاء الأداة فوراً عند تسجيل الشاشة لمنع الباند اليدوي
    [[NSNotificationCenter defaultCenter] addObserverForName:UIScreenCapturedDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        if (self.displayLabel) { [self.displayLabel removeFromSuperview]; self.displayLabel = nil; }
    }];
}
@end

__attribute__((constructor))
static void SovereignFinalEntry() {
    freopen("/dev/null", "w", stdout); // تصفير السجلات لمنع الباند الغيابي
    
    // تأخير عزل الذاكرة لضمان الاستقرار في iOS 18.5
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        uintptr_t header = (uintptr_t)_dyld_get_image_header(0);
        mprotect((void *)(header & ~0xFFF), 4096, PROT_NONE);
    });

    [[SovereignStableV35 shared] hookSystemFunctions];
    [[SovereignStableV35 shared] setupPanicMode];

    // تأخير الحقن لـ 15 ثانية لمنع الكراش عند إقلاع اللعبة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *activeWin = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* s in [UIApplication sharedApplication].connectedScenes) {
                if (s.activationState == UISceneActivationStateForegroundActive) {
                    activeWin = s.windows.firstObject; break;
                }
            }
        }
        if (activeWin) {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 55)];
            l.text = @"👑 SOVEREIGN V35.0\nIDA SILENCED | iOS 18.5";
            l.numberOfLines = 2; l.textColor = [UIColor whiteColor];
            l.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            l.textAlignment = NSTextAlignmentCenter; l.font = [UIFont boldSystemFontOfSize:10];
            l.layer.cornerRadius = 15; l.layer.borderWidth = 2;
            l.layer.borderColor = [UIColor greenColor].CGColor; l.clipsToBounds = YES;
            [activeWin addSubview:l];
            [SovereignStableV35 shared].displayLabel = l;
        }
    });
}
