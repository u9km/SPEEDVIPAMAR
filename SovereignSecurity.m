#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ================================================
// 1. واجهة القائمة والزر العائم (Menu UI Engine)
// ================================================
@interface SovereignMenu : NSObject
+ (void)setupMenuSystem;
@end

@implementation SovereignMenu

static UIButton *floatingButton;
static UIView *mainMenuView;
static BOOL isMenuVisible = NO;

+ (void)setupMenuSystem {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!window) return;

        // --- إنشاء الزر العائم (Floating Button) ---
        floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        floatingButton.frame = CGRectMake(10, 150, 60, 60);
        floatingButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        floatingButton.layer.cornerRadius = 30;
        floatingButton.layer.borderWidth = 2;
        floatingButton.layer.borderColor = [UIColor cyanColor].CGColor;
        [floatingButton setTitle:@"👁️" forState:UIControlStateNormal];
        floatingButton.titleLabel.font = [UIFont systemFontOfSize:30];
        
        // إضافة إيماءة التحريك للزر
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [floatingButton addGestureRecognizer:pan];
        [floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        
        [window addSubview:floatingButton];

        // --- إنشاء نافذة المنيو (Main Menu) ---
        mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 350)];
        mainMenuView.center = window.center;
        mainMenuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        mainMenuView.layer.cornerRadius = 15;
        mainMenuView.layer.borderWidth = 1;
        mainMenuView.layer.borderColor = [UIColor cyanColor].CGColor;
        mainMenuView.hidden = YES; // مخفي في البداية

        // عنوان المنيو
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 280, 30)];
        title.text = @"SHADOWBREAKER V1.0";
        title.textColor = [UIColor cyanColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:18];
        [mainMenuView addSubview:title];

        // زر تفعيل ESP
        UIButton *espBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        espBtn.frame = CGRectMake(20, 60, 240, 45);
        espBtn.backgroundColor = [UIColor darkGrayColor];
        [espBtn setTitle:@"Enable Smart ESP" forState:UIControlStateNormal];
        [espBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        espBtn.layer.cornerRadius = 10;
        [espBtn addTarget:self action:@selector(actionESP) forControlEvents:UIControlEventTouchUpInside];
        [mainMenuView addSubview:espBtn];

        [window addSubview:mainMenuView];
    });
}

+ (void)handlePan:(UIPanGestureRecognizer *)p {
    UIView *btn = p.view;
    CGPoint trans = [p translationInView:btn.superview];
    btn.center = CGPointMake(btn.center.x + trans.x, btn.center.y + trans.y);
    [p setTranslation:CGPointZero inView:btn.superview];
}

+ (void)toggleMenu {
    isMenuVisible = !isMenuVisible;
    mainMenuView.hidden = !isMenuVisible;
    // اهتزاز بسيط عند الضغط
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [gen impactOccurred];
}

+ (void)actionESP {
    NSLog(@"[ESP] 👁️ تم تفعيل الكشف الذكي من القائمة.");
    // هنا يتم استدعاء كود الرسم
}
@end

// ================================================
// 2. فك الحماية والمراقبة (Protection & Match)
// ================================================
__attribute__((constructor))
static void SovereignSystemEntry() {
    // إسكات السجلات لمنع الوشاية
    freopen("/dev/null", "w", stdout);
    freopen("/dev/null", "w", stderr);

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification 
                                                      object:nil 
                                                       queue:[NSOperationQueue mainQueue] 
                                                  usingBlock:^(NSNotification *note) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            // تشغيل نظام المنيو بعد 5 ثوانٍ من استقرار اللعبة
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SovereignMenu setupMenuSystem];
            });
        });
    }];
}
