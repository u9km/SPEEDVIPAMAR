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
// [لم يتم تعديل أي حرف هنا بناء على طلبك]
+ (NSArray *)loadPart1 {
    return @[
        @"bugly.qq.com", @"ios.bugly.qq.com", @"android.bugly.qq.com", @"pro.bugly.qq.com",
        @"astat.bugly.qcloud.com", @"report.bugly.qq.com", @"log.bugly.qq.com",
        @"bugly.iot.qq.com", @"bugly.gamesafe.qq.com", @"bugly.cloud.tencent.com",
        @"igamecj.com", @"file.igamecj.com", @"log.igamecj.com", @"report.igamecj.com",
        @"hk.nav.igamecj.com", @"us.nav.igamecj.com", @"ipv6.igamecj.com",
        @"kcs.igamecj.com", @"cdn.igamecj.com", @"up.igamecj.com",
        @"proximabeta.com", @"report.proximabeta.com", @"cdn.proximabeta.com",
        @"cloud.tencent.com", @"gcloud.tencent.com", @"mcloud.tencent.com",
        @"tpns.qq.com", @"xg.qq.com", @"gamesafe.qq.com", @"cs.mbgame.gamesafe.qq.com",
        @"intl.game.qq.com", @"down.qq.com", @"open.qq.com", @"img.ssl.qq.com",
        @"anticheat.qq.com", @"ace.qq.com", @"down.anticheatexpert.com",
        @"report.anticheatexpert.com", @"log.anticheatexpert.com",
        @"config.anticheatexpert.com", @"cdn.anticheatexpert.com",
        @"ipv6.anticheatexpert.com", @"api.anticheatexpert.com",
        @"graph.facebook.com", @"appsflyer.com", @"adjust.com", @"google-analytics.com",
        @"app-measurement.com", @"crashlytics.com", @"firebase-settings.crashlytics.com",
        @"events.garena.com", @"kgvn.vnggames.com", @"pay.vnggames.com",
        @"umeng.com", @"flurry.com", @"kochava.com", @"talkingdata.com"
    ];
}

// --- الجزء الثاني: مسارات الملفات (File Paths) ---
// [لم يتم تعديل أي حرف هنا]
+ (NSArray *)loadPart2 {
    return @[
        @"/Documents/Bugly", @"/Documents/Slardar", @"/Documents/TencentMSDK",
        @"/Documents/GCloud", @"/Documents/APMInsight", @"/Documents/CrashSight",
        @"/Library/Caches/com.tencent.ig", @"/Library/Preferences/com.tencent.ig.plist",
        @"/Documents/ShadowTrackerExtra/Saved/Logs",
        @"/Documents/ShadowTrackerExtra/Saved/Paks/Paks_M",
        @"/Documents/ShadowTrackerExtra/Saved/Config",
        @"/tmp/UE4CommandLine.txt", @"/tmp/game_log.txt",
        @"/Applications/Cydia.app", @"/Applications/Sileo.app", @"/Applications/Zebra.app",
        @"/usr/lib/libsubstateloader.dylib", @"/usr/lib/TweakInject.dylib",
        @"/usr/lib/MobileSubstrate.dylib", @"/usr/sbin/sshd", @"/bin/bash",
        @"/etc/apt", @"/private/var/lib/apt", @"/private/var/lib/cydia",
        @"/private/var/mobile/Library/SBSettings/Themes"
    ];
}

// --- الجزء الثالث: كواشف الذاكرة (Memory Strings) ---
// [لم يتم تعديل أي حرف هنا]
+ (NSArray *)loadPart3 {
    return @[
        @"UE4_Projectile", @"BulletTrack", @"AimAdjustment", @"RecoilScale",
        @"WeaponSpread", @"CharacterMovement", @"ClientPrediction",
        @"ServerVerification", @"HitRegistration", @"RegionCheck",
        @"STExtraCharacter", @"STExtraPlayerController", @"STExtraWeapon",
        @"ShootInterval", @"AnimationRate", @"WalkSpeed", @"JumpHeight",
        @"MagicBullet", @"HighJump", @"WallHack", @"Aimbot", @"Headshot",
        @"S_GameSecurity", @"ACE_Detection", @"TP_Security", @"Dobby",
        @"Fishhook", @"Substrate", @"LibLoader", @"DylibCheck",
        @"IntegrityCheck", @"FileHash", @"MemoryPatch", @"BeingDebugged",
        @"ptrace", @"sysctl", @"isatty", @"ioctl"
    ];
}

// --- الجزء الرابع: الكلمات الدلالية العامة (Keywords) ---
// [لم يتم تعديل أي حرف هنا]
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
    
    for (NSString *threat in [Sovereign1338 getAllStrings]) {
        if ([str containsString:threat.lowercaseString]) {
            detected = YES;
            break;
        }
    }

    if (detected) {
        [self sovereign_1338_setURL:[NSURL URLWithString:@"http://0.0.0.0"]];
    } else {
        [self sovereign_1338_setURL:url];
    }
}
@end

// ==========================================
// الماسح الضوئي (Disk Wiper - Non-Jailbreak Safe)
// ==========================================
__attribute__((constructor))
static void SovereignEntry() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        // تحديد مسار المستندات الخاص بالتطبيق (Sandbox Path)
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *lib = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        
        NSArray *targets = [Sovereign1338 loadPart2];
        
        while (YES) {
            for (NSString *pathStr in targets) {
                // التعامل الذكي مع المسارات داخل بيئة بدون جلبريك
                // المسارات مثل /Applications/Cydia سيتم تجاهلها تلقائياً لأن التطبيق لا يراها
                // المسارات مثل /Documents/Bugly سيتم تحويلها للمسار الحقيقي داخل الساندبوكس
                
                NSString *targetPath = nil;
                
                if ([pathStr containsString:@"/Documents/"]) {
                    NSString *cleanName = [pathStr stringByReplacingOccurrencesOfString:@"/Documents/" withString:@""];
                    targetPath = [doc stringByAppendingPathComponent:cleanName];
                } else if ([pathStr containsString:@"/Library/"]) {
                    NSString *cleanName = [pathStr stringByReplacingOccurrencesOfString:@"/Library/" withString:@""];
                    targetPath = [lib stringByAppendingPathComponent:cleanName];
                }
                
                // إذا وجد الملف داخل نطاق التطبيق، يقوم بحذفه
                if (targetPath && [fm fileExistsAtPath:targetPath]) {
                    [fm removeItemAtPath:targetPath error:nil];
                }
            }
            [NSThread sleepForTimeInterval:5.0];
        }
    });
}
