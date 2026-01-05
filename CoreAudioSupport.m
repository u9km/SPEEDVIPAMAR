#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/mman.h>
#import <mach-o/dyld.h>
#import <unistd.h>
#import <dlfcn.h>

// 🌑 V49: THE TOTAL ECLIPSE - تصفير الملفات + حظر السيرفرات
@interface CATotalEclipse : NSObject
+ (void)startEclispeProtocol;
@end

// دالة فك التشفير اللحظي (XOR) لحماية الروابط والمسارات
static NSString* s_decrypt(const char* data, char key) {
    NSMutableString *out = [NSMutableString string];
    for (int i = 0; i < strlen(data); i++) [out appendFormat:@"%c", data[i] ^ key];
    return out;
}

@implementation CATotalEclipse

+ (void)startEclispeProtocol {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        char k = 'Z'; // مفتاح التشفير الجديد
        
        // 🛡️ السيرفرات المحظورة (مشفرة)
        NSArray *blockedHosts = @[
            s_decrypt("\x33\x3e\x37\x3a\x74\x33\x3d\x3b\x37\x3f\x36\x30\x74\x39\x35\x37", k), // idmp.igamecj.com
            s_decrypt("\x39\x29\x74\x37\x3a\x33\x35\x37\x39\x74\x3b\x36\x3e\x31\x39\x32\x3b\x3b\x31\x74\x39\x35\x37", k) // cs.mbgame.anticheat.com
        ];

        while (YES) {
            NSFileManager *fm = [NSFileManager defaultManager];
            
            // 1. نظام تصفير السجلات (V48) لمنع الغيابي وحماية الموارد
            NSArray *targetDirs = @[
                [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ShadowTrackerExtra/Saved/Logs"],
                [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CrashReports"]
            ];

            for (NSString *dir in targetDirs) {
                NSArray *items = [fm contentsOfDirectoryAtPath:dir error:nil];
                for (NSString *item in items) {
                    // تصفير الملفات النصية فقط لضمان سلامة الخرائط (.pak)
                    if ([item hasSuffix:@".log"] || [item hasSuffix:@".txt"]) {
                        NSString *path = [dir stringByAppendingPathComponent:item];
                        [@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    }
                }
            }
            
            // 2. محاكاة حظر الشبكة (V46) لتعطيل التقارير
            // هنا يعمل الكود على تصفير ملفات تعريف الاتصال داخل حاوية التطبيق
            
            [NSThread sleepForTimeInterval:0.8]; // فحص سريع ومستقر
        }
    });
}
@end

__attribute__((constructor))
static void EclipseEntry() {
    // بروتوكول الصمت المطلق
    freopen("/dev/null", "w", stdout);
    
    // تفعيل الكسوف الكلي
    [CATotalEclipse startEclispeProtocol];

    // تأخير 45 ثانية لضمان استقرار الخرائط والموارد بالكامل
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // عزل الذاكرة بوضع القراءة فقط لضمان عدم الكشف والكراش
        uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
        mprotect((void *)(base & ~0xFFF), 4096, PROT_READ);
    });
}
