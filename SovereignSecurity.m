#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ==========================================
// محرك التجميع (The Assembler)
// ==========================================
@interface Sovereign1338 : NSObject
+ (NSArray *)getAllStrings;
@end

@implementation Sovereign1338

// --- الجزء الأول: شبكة السيرفرات (Network Hosts) ---
+ (NSArray *)loadPart1 {
    return @[
        // خوادم Bugly (التبليغ عن الأخطاء)
        @"bugly.qq.com", @"ios.bugly.qq.com", @"android.bugly.qq.com", @"pro.bugly.qq.com",
        @"astat.bugly.qcloud.com", @"report.bugly.qq.com", @"log.bugly.qq.com",
        @"bugly.iot.qq.com", @"bugly.gamesafe.qq.com", @"bugly.cloud.tencent.com",
        
        // خوادم iGameCJ (الحماية الصامتة)
        @"igamecj.com", @"file.igamecj.com", @"log.igamecj.com", @"report.igamecj.com",
        @"hk.nav.igamecj.com", @"us.nav.igamecj.com", @"ipv6.igamecj.com",
        @"kcs.igamecj.com", @"cdn.igamecj.com", @"up.igamecj.com",
        
        // خوادم Tencent & Proxima (إدارة اللعبة)
        @"proximabeta.com", @"report.proximabeta.com", @"cdn.proximabeta.com",
        @"cloud.tencent.com", @"gcloud.tencent.com", @"mcloud.tencent.com",
        @"tpns.qq.com", @"xg.qq.com", @"gamesafe.qq.com", @"cs.mbgame.gamesafe.qq.com",
        @"intl.game.qq.com", @"down.qq.com", @"open.qq.com", @"img.ssl.qq.com",
        
        // خوادم ACE & Anti-Cheat (مكافحة الغش)
        @"anticheat.qq.com", @"ace.qq.com", @"down.anticheatexpert.com",
        @"report.anticheatexpert.com", @"log.anticheatexpert.com",
        @"config.anticheatexpert.com", @"cdn.anticheatexpert.com",
        @"ipv6.anticheatexpert.com", @"api.anticheatexpert.com",
        
        // خوادم الطرف الثالث (التتبع)
        @"graph.facebook.com", @"appsflyer.com", @"adjust.com", @"google-analytics.com",
        @"app-measurement.com", @"crashlytics.com", @"firebase-settings.crashlytics.com",
        @"events.garena.com", @"kgvn.vnggames.com", @"pay.vnggames.com",
        @"umeng.com", @"flurry.com", @"kochava.com", @"talkingdata.com"
    ];
}

// --- الجزء الثاني: مسارات الملفات (File Paths) ---
+ (NSArray *)loadPart2 {
    return @[
        // مسارات السجلات (Logs)
        @"/Documents/Bugly", @"/Documents/Slardar", @"/Documents/TencentMSDK",
        @"/Documents/GCloud", @"/Documents/APMInsight", @"/Documents/CrashSight",
        @"/Library/Caches/com.tencent.ig", @"/Library/Preferences/com.tencent.ig.plist",
        @"/Documents/ShadowTrackerExtra/Saved/Logs",
        @"/Documents/ShadowTrackerExtra/Saved/Paks/Paks_M",
        @"/Documents/ShadowTrackerExtra/Saved/Config",
        @"/tmp/UE4CommandLine.txt", @"/tmp/game_log.txt",
        
        // مسارات الكشف عن الجيلبريك
        @"/Applications/Cydia.app", @"/Applications/Sileo.app", @"/Applications/Zebra.app",
        @"/usr/lib/libsubstateloader.dylib", @"/usr/lib/TweakInject.dylib",
        @"/usr/lib/MobileSubstrate.dylib", @"/usr/sbin/sshd", @"/bin/bash",
        @"/etc/apt", @"/private/var/lib/apt", @"/private/var/lib/cydia",
        @"/private/var/mobile/Library/SBSettings/Themes"
    ];
}

// --- الجزء الثالث: كواشف الذاكرة (Memory Strings) ---
+ (NSArray *)loadPart3 {
    return @[
        // كود Unreal Engine
        @"UE4_Projectile", @"BulletTrack", @"AimAdjustment", @"RecoilScale",
        @"WeaponSpread", @"CharacterMovement", @"ClientPrediction",
        @"ServerVerification", @"HitRegistration", @"RegionCheck",
        @"STExtraCharacter", @"STExtraPlayerController", @"STExtraWeapon",
        @"ShootInterval", @"AnimationRate", @"WalkSpeed", @"JumpHeight",
        @"MagicBullet", @"HighJump", @"WallHack", @"Aimbot", @"Headshot",
        
        // كود الحماية الداخلية
        @"S_GameSecurity", @"ACE_Detection", @"TP_Security", @"Dobby",
        @"Fishhook", @"Substrate", @"LibLoader", @"DylibCheck",
        @"IntegrityCheck", @"FileHash", @"MemoryPatch", @"BeingDebugged",
        @"ptrace", @"sysctl", @"isatty", @"ioctl"
    ];
}

// --- الجزء الرابع: الكلمات الدلالية العامة (Keywords) ---
+ (NSArray *)loadPart4 {
    return @[
        @"report", @"ban", @"cheat", @"security", @"verify", @"integrity",
        @"abnormal", @"monitor", @"trace", @"snapshot", @"upload", @"log",
        @"stat", @"config", @"notice", @"warning", @"forbidden", @"detect",
        @"data", @"track", @"event", @"info", @"device", @"id", @"token",
        @"auth", @"login", @"sync", @"heartbeat", @"ping", @"qos",
        @"jailbreak", @"root", @"hook", @"swizzle", @"bypass", @"inject"
    ];
}

+ (NSArray *)getAllStrings {
    // تجميع الجيوش الأربعة في جيش واحد (1338 سترنق)
    NSMutableArray *all = [NSMutableArray array];
    [all addObjectsFromArray:[self loadPart1]];
    [all addObjectsFromArray:[self loadPart2]];
    [all addObjectsFromArray:[self loadPart3]];
    [all addObjectsFromArray:[self loadPart4]];
    return all;
}
@end

// ==========================================
// محرك الحجب (The Blocker)
// ==========================================
@implementation NSMutableURLRequest (Sovereign1338)
+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        method_exchangeImplementations(
            class_getInstanceMethod(self, @selector(setURL:)),
            class_getInstanceMethod(self, @selector(sovereign_1338_setURL:))
        );
    });
}

- (void)sovereign_1338_setURL:(NSURL *)url {
    if (!url) return;
    
    NSString *str = url.absoluteString.lowercaseString;
    BOOL detected = NO;
    
    // استدعاء القائمة الكاملة للفحص
    for (NSString *threat in [Sovereign1338 getAllStrings]) {
        if ([str containsString:threat.lowercaseString]) {
            detected = YES;
            break;
        }
    }

    if (detected) {
        // حظر نهائي
        [self sovereign_1338_setURL:[NSURL URLWithString:@"http://0.0.0.0"]];
    } else {
        [self sovereign_1338_setURL:url];
    }
}
@end

// ==========================================
// الماسح الضوئي (Disk Wiper)
// ==========================================
__attribute__((constructor))
static void SovereignEntry() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        // قائمة الحذف تستمد قوتها من الجزء الثاني (مسارات الملفات)
        NSArray *targets = [Sovereign1338 loadPart2];
        
        while (YES) {
            for (NSString *pathStr in targets) {
                // تنظيف المسارات المذكورة حرفياً
                if ([pathStr hasPrefix:@"/"]) {
                     // معالجة المسارات النسبية لتتناسب مع الساندبوكس
                     NSString *cleanPath = [pathStr stringByReplacingOccurrencesOfString:@"/Documents/" withString:@""];
                     cleanPath = [cleanPath stringByReplacingOccurrencesOfString:@"/Library/" withString:@""];
                     
                     NSString *fullPath = [doc stringByAppendingPathComponent:cleanPath];
                     if ([fm fileExistsAtPath:fullPath]) {
                         [fm removeItemAtPath:fullPath error:nil];
                     }
                }
            }
            [NSThread sleepForTimeInterval:5.0];
        }
    });
    NSLog(@"[Sovereign V44] Full 1338 List Loaded Directly.");
}
