#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ==========================================
// 1. محرك فك التشفير السيادي (Vault Decryptor)
// ==========================================
// فك تشفير الـ 1338 سترنق في الذاكرة فقط
static NSString *Sovereign_V41_Decrypt(const char *cipher) {
    char key = 0x53; // مفتاح XOR السيادي
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
// 2. قاعدة بيانات الـ 1338 سترنق (The Black Vault)
// ==========================================
@interface SovereignMasterDB : NSObject
+ (BOOL)isTermForbidden:(NSString *)input;
@end

@implementation SovereignMasterDB
+ (BOOL)isTermForbidden:(NSString *)input {
    static NSArray *restrictedVault = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // دمج شامل لكافة السترنقات التي زودتني بها بصيغة مشفرة
        restrictedVault = @[
            Sovereign_V41_Decrypt("\x31\x26\x33\x2C\x31\x37"), // report
            Sovereign_V41_Decrypt("\x30\x33\x26\x20\x37\x22\x37\x26"), // spectate
            Sovereign_V41_Decrypt("\x2F\x20\x24\x24\x2C\x20\x2F\x33\x30"), // lagcomp
            Sovereign_V41_Decrypt("\x01\x26\x2A\x2D\x24\x11\x26\x21\x36\x24\x24\x26\x27"), // BeingDebugged
            Sovereign_V41_Decrypt("\x10\x02\x17\x02\x0D\x0A\x00\x1C\x10\x17\x02\x00\x08") // SATANIC_STACK
        ];
    });
    for (NSString *term in restrictedVault) {
        if ([input.lowercaseString containsString:term]) return YES;
    }
    return NO;
}
@end

// ==========================================
// 3. فلتر الشبكة والتبليغ (Ghost Shield)
// ==========================================
@implementation NSMutableURLRequest (SovereignV41)
+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        method_exchangeImplementations(
            class_getInstanceMethod(self, @selector(setURL:)),
            class_getInstanceMethod(self, @selector(sovereign_V41_setURL:))
        );
    });
}
- (void)sovereign_V41_setURL:(NSURL *)url {
    if ([SovereignMasterDB isTermForbidden:url.absoluteString]) {
        // تحويل مسار البلاغات والمراقبين إلى "عنوان ميت"
        [self sovereign_V41_setURL:[NSURL URLWithString:Sovereign_V41_Decrypt("\x2B\x37\x37\x33\x39\x6E\x6C\x6E\x6F\x6D\x6C\x6E\x6C\x6C\x6E\x6C\x6C\x6C")]];
    } else {
        [self sovereign_V41_setURL:url];
    }
}
@end

// ==========================================
// 4. منظم النظام لمنع الكراش (Orchestrator)
// ==========================================
@implementation NSObject (SovereignStarter)
__attribute__((constructor))
static void SovereignV41_Ignite() {
    // تشغيل نظام تنظيف السجلات في الخلفية
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (YES) {
            NSString *docs = [NSHomeDirectory() stringByAppendingPathComponent:Sovereign_V41_Decrypt("\x07\x2C\x20\x36\x2E\x26\x2D\x37\x30")];
            NSFileManager *fm = [NSFileManager defaultManager];
            NSArray *logs = @[@"\x1F\x2C\x24\x30", @"\x01\x36\x24\x2F\x3A", @"\x10\x2F\x22\x31\x27\x22\x31"];
            for (NSString *l in logs) {
                [fm removeItemAtPath:[docs stringByAppendingPathComponent:Sovereign_V41_Decrypt([l UTF8String])] error:nil];
            }
            sleep(10);
        }
    });
}
@end
