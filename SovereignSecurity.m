#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ==========================================
// 1. Identity Coordinator Layer
// ==========================================
@interface SovereignIdentityCoordinator : NSObject
@property (nonatomic, readonly, strong) NSString *managedIdentifier;
+ (instancetype)sharedCoordinator;
@end

@implementation SovereignIdentityCoordinator

+ (instancetype)sharedCoordinator {
    static SovereignIdentityCoordinator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)managedIdentifier {
    return @"com.pubg.korea";
}

@end

// ==========================================
// 2. Lifecycle & Scene Compliance
// ==========================================
@interface SovereignAppOrchestrator : NSObject
+ (void)startOrchestration;
@end

@implementation SovereignAppOrchestrator

+ (void)startOrchestration {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationDidFinishLaunchingNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *note) {
            [self synchronizeInterface];
        }];
    });
}

+ (void)synchronizeInterface {
    UIWindow *keyWindow = nil;

    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:[UIWindowScene class]]) {

                UIWindowScene *windowScene = (UIWindowScene *)scene;
                keyWindow = windowScene.windows.firstObject;
                break;
            }
        }
    } else {
        keyWindow = UIApplication.sharedApplication.keyWindow;
    }

    if (!keyWindow) return;

    UIViewController *rootVC = keyWindow.rootViewController;
    if (rootVC && !rootVC.presentedViewController) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"🛡️ SOVEREIGN ARCH"
                                            message:@"Architecture: Enterprise Level\nStatus: System Compliant"
                                     preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"ESTABLISH"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];

        [rootVC presentViewController:alert animated:YES completion:nil];

        NSLog(@"[Sovereign] Security Layer Deployed. ID: %@",
              [SovereignIdentityCoordinator sharedCoordinator].managedIdentifier);
    }
}

@end

// ==========================================
// 3. Entry Point
// ==========================================
__attribute__((constructor))
static void SovereignEntry(void) {
    [SovereignAppOrchestrator startOrchestration];
}
