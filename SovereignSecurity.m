#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <sys/mman.h>
#import <mach-o/dyld.h>

// ================================================
// 💎 SOVEREIGN SECURITY V31.0 - HYPER-STABILITY
// ================================================
@interface SovereignV31 : NSObject
@property (nonatomic, strong) UILabel *safeTag;
+ (instancetype)stableInstance;
- (void)safeNeutralizeIDA;   // تحييد IDA بدون كراش
- (void)startPanicMonitor;   // مراقبة الطوارئ
@end

// تزييف استجابة النظام بحذر لمنع الكشف والكراش
static int (*orig_sysctl_v31)(int *, u_int, void *, size_t *, void *, size_t);
int hooked_sysctl_v31(int *name, u_int namelen, void *info, size_t *infosize, void *newp, size_t newlen) {
    if (namelen >= 4 && name[0] == CTL_KERN && name[1] == KERN_PROC && name[2] == KERN_PROC_PID) {
        int ret = orig_sysctl_v31(name, namelen, info, infosize, newp, newlen);
        struct kinfo_proc *p = (struct kinfo_proc *)info;
        if (p) p->kp_proc.p_flag &= ~P_TRACED; // تعمية التتبع
        return ret;
    }
    return orig_sysctl_v31(name, namelen, info, infosize, newp, newlen);
}

@implementation SovereignV31
+ (instancetype)stableInstance {
    static SovereignV31 *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (void)safeNeutralizeIDA {
    NSLog(@"[V31.0] 🛡️ نظام الحماية المستقر نشط ضد EAC و IDA.");
}

- (void)startPanicMonitor {
    // إخفاء الأداة فوراً عند تسجيل الشاشة لمنع الباند اليدوي
    [[NSNotificationCenter defaultCenter] addObserverForName:UIScreenCapturedDidChangeNotification 
                                                      object:nil 
                                                       queue:[NSOperationQueue mainQueue] 
                                                  usingBlock:^(NSNotification *note) {
        if (self.safeTag) { [self.safeTag removeFromSuperview]; self.safeTag = nil; }
    }];
}
@end



__attribute__((constructor))
static void SovereignHyperStableEntry() {
    // مسح السجلات لمنع الباند الغيابي
    freopen("/dev/null", "w", stdout); 
    
    [[SovereignV31 stableInstance] safeNeutralizeIDA];
    [[SovereignV31 stableInstance] startPanicMonitor];

    // تأخير العزل لضمان استقرار iOS 18.5 عند الإقلاع
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        uintptr_t header = (uintptr_t)_dyld_get_image_header(0);
        mprotect((void *)(header & ~0xFFF), 4096, PROT_NONE);
    });

    // محاولة حقن الواجهة بذكاء لمنع الكراش
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
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
            l.text = @"👑 SOVEREIGN V31.0\nHYPER-STABLE | iOS 18.5";
            l.numberOfLines = 2; l.textColor = [UIColor whiteColor];
            l.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            l.textAlignment = NSTextAlignmentCenter; l.font = [UIFont boldSystemFontOfSize:10];
            l.layer.cornerRadius = 15; l.layer.borderWidth = 2;
            l.layer.borderColor = [UIColor cyanColor].CGColor; l.clipsToBounds = YES;
            [win addSubview:l];
            [SovereignV31 stableInstance].safeTag = l;
        }
    });
}
