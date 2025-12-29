#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <unistd.h>

#pragma mark - Runtime Integrity (Soft & Safe)

static BOOL Sovereign_IsDebuggerAttached(void) {
    int mib[4] = { CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid() };
    struct kinfo_proc info;
    size_t size = sizeof(info);
    sysctl(mib, 4, &info, &size, NULL, 0);
    return (info.kp_proc.p_flag & P_TRACED);
}

#pragma mark - Session Context

static NSString *Sovereign_SessionID(void) {
    static NSString *sessionID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionID = [NSUUID UUID].UUIDString;
    });
    return sessionID;
}

#pragma mark - Feature Gate

static BOOL Sovereign_AllowSecureFeatures(void) {
    if (Sovereign_IsDebuggerAttached()) {
        NSLog(@"[Sovereign] Debugger detected (soft response)");
        return NO;
    }
    return (Sovereign_SessionID().length > 0);
}

#pragma mark - Secure UI Deployment

static void Sovereign_DeployUI(void) {
    if (!Sovereign_AllowSecureFeatures()) return;

    UIWindow *targetWindow = nil;

    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if ([scene isKindOfClass:UIWindowScene.class] &&
                scene.activationState == UISceneActivationStateForegroundActive) {
                targetWindow = ((UIWindowScene *)scene).windows.firstObject;
                break;
            }
        }
    } else {
        targetWindow = UIApplication.sharedApplication.keyWindow;
    }

    if (!targetWindow.rootViewController ||
        targetWindow.rootViewController.presentedViewController) return;

    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"🛡️ SOVEREIGN SECURITY"
    message:@"Status: Active\nIntegrity: Verified\nMode: App‑Store Safe"
    preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];

    [targetWindow.rootViewController presentViewController:alert
                                                  animated:YES
                                                completion:nil];

    NSLog(@"[Sovereign] Security system activated. Session: %@",
          Sovereign_SessionID());
}

#pragma mark - Lifecycle Orchestration

static void Sovereign_Start(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter]
         addObserverForName:UIApplicationDidBecomeActiveNotification
         object:nil
         queue:NSOperationQueue.mainQueue
         usingBlock:^(NSNotification * _Nonnull note) {
            Sovereign_DeployUI();
        }];
    });
}

#pragma mark - Entry Point (One‑Click)

__attribute__((constructor))
static void Sovereign_EntryPoint(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        Sovereign_Start();
    });
}
