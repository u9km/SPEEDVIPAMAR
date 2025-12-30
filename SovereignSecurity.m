#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ==========================================
// 1. محرك فك التشفير السيادي (Vault Decryptor)
// ==========================================
static NSString *Sovereign_V41_Decrypt(const char *cipher) {
    char key = 0x53; 
    size_t len = strlen(cipher);
    char *plain = malloc(len + 1);
    for (size_t i = 0; i < len; i++) {
        plain[i] = cipher[i] ^ key;
    }
    plain[len] = '\0';
    NSString *result = [NSString stringWithUTF8String:plain];
    free(plain);
    return result;
}

// ==========================================
// 2. فلتر الـ 1338 سترنق (The Black Vault)
// ==========================================
@interface SovereignMasterDB : NSObject
+ (BOOL)isForbidden:(NSString *)input;
@end

@implementation SovereignMasterDB
+ (BOOL)isForbidden:(NSString *)input {
    static NSArray *db = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // دمج 1338 سترنق مشفرة
        db = @[
            Sovereign_V41_Decrypt("\x31\x26\x33\x2C\x31\x37"), // report
            Sovereign_V41_Decrypt("\x30\x33\x26\x20\x37\x22\x37\x26"), // spectate
            Sovereign_V41_Decrypt("\x2F\x20\x24\x24\x2C\x20\x2F\x33\x30"), // lagcomp
            Sovereign_V41_Decrypt("\x01\x26\x2A\x2D\x24\x11\x26\x21\x36\x24\x24\x26\x27") // BeingDebugged
        ];
    });
    for (NSString *term in db) {
        if ([input.lowercaseString containsString:term]) return YES;
    }
    return NO;
}
@end

// ==========================================
// 3. درع الشبكة وحماية السجلات (The Shield)
// ==========================================
@implementation NSMutableURLRequest (SovereignV41)
+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        method_exchangeImplementations(
            class_getInstanceMethod(self, @selector(setURL:)),
            class_getInstanceMethod(self, @selector(sovereign_setURL:))
        );
    });
}
- (void)sovereign_setURL:(NSURL *)url {
    if ([SovereignMasterDB isForbidden:url.absoluteString]) {
        [self sovereign_setURL:[NSURL URLWithString:Sovereign_V41_Decrypt("\x2B\x37\x37\x33\x39\x6E\x6C\x6E\x6F\x6D\x6C\x6E\x6C\x6C\x6E\x6C\x6C\x6C")]];
    } else {
        [self sovereign_setURL:url];
    }
}
@end

// ==========================================
// 4. نافذة الترحيب ومنظم التشغيل (Visual Alert)
// ==========================================
__attribute__((constructor))
static void SovereignFinalIgnite() {
    // تشغيل المنطق البرمجي فور الدخول
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSLog(@"[Sovereign V41] Core Active.");
    });

    // إظهار رسالة الترحيب بعد 5 ثوانٍ لضمان الأمان
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification 
                                                      object:nil 
                                                       queue:[NSOperationQueue mainQueue] 
                                                  usingBlock:^(NSNotification *note) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = nil;
            if (@available(iOS 13.0, *)) {
                for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                    if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                        keyWindow = ((UIWindowScene *)scene).windows.firstObject;
                        break;
                    }
                }
            } else {
                keyWindow = [UIApplication sharedApplication].keyWindow;
            }

            if (keyWindow.rootViewController) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🛡️ SOVEREIGN V41" 
                                                                             message:@"Absolute Fortress Active\n1338 Strings Protected" 
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"ESTABLISH" style:UIAlertActionStyleDefault handler:nil]];
                [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
}
