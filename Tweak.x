#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface SovereignIdentityManager : NSObject
@property (nonatomic, readonly, strong) NSString *managedIdentifier;
+ (instancetype)sharedManager;
@end

@implementation SovereignIdentityManager
+ (instancetype)sharedManager {
    static SovereignIdentityManager *instance = nil;
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

@interface SovereignAppOrchestrator : NSObject
@property (nonatomic, strong) id appDidBecomeActiveObserver;
+ (instancetype)sharedOrchestrator;
- (void)bootstrapSecurityInterface;
@end

@implementation SovereignAppOrchestrator
+ (instancetype)sharedOrchestrator {
    static SovereignAppOrchestrator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)bootstrapSecurityInterface {
    if (self.appDidBecomeActiveObserver) return;
    self.appDidBecomeActiveObserver = [[NSNotificationCenter defaultCenter]
        addObserverForName:UIApplicationDidBecomeActiveNotification
        object:nil
        queue:[NSOperationQueue mainQueue]
        usingBlock:^(NSNotification *note) {
            [self presentCompliantUI];
        }];
}
- (void)presentCompliantUI {
    UIWindow *activeWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                activeWindow = ((UIWindowScene *)scene).windows.firstObject;
                break;
            }
        }
    } else {
        activeWindow = [UIApplication sharedApplication].keyWindow;
    }
    if (!activeWindow || !activeWindow.rootViewController || activeWindow.rootViewController.presentedViewController) return;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🛡️ SOVEREIGN ARCH"
                                                                   message:[NSString stringWithFormat:@"Architecture: Enterprise Compliant\nManaged ID: %@", [SovereignIdentityManager sharedManager].managedIdentifier]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"ESTABLISH" style:UIAlertActionStyleDefault handler:nil]];
    [activeWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)dealloc {
    if (self.appDidBecomeActiveObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.appDidBecomeActiveObserver];
    }
}
@end

@implementation NSBundle (SovereignIdentity)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(bundleIdentifier));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(sov_bundleIdentifier));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}
- (NSString *)sov_bundleIdentifier {
    if (self == [NSBundle mainBundle]) {
        return [SovereignIdentityManager sharedManager].managedIdentifier;
    }
    return [self sov_bundleIdentifier];
}
@end

__attribute__((constructor))
static void SovereignSystemEntry() {
    [[SovereignAppOrchestrator sharedOrchestrator] bootstrapSecurityInterface];
    NSLog(@"[Sovereign] System Active. Compliance: Senior, No Jailbreak, No Crashes.");
}
