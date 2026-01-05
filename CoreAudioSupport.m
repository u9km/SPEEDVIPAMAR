#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/mman.h>
#import <mach-o/dyld.h>
#import <unistd.h>
#import <dlfcn.h>
#import <sys/stat.h> // ✅ هذا هو السطر الذي كان ناقصاً ويسبب المشكلة

// 🌍 V63.2: GLOBAL PHANTOM - إصلاح خطأ المكتبة
@interface CAGlobalPhantom : NSObject
+ (void)deployGlobalShield;
@end

static NSString* s_crypt(const char* data, char key) {
    NSMutableString *out = [NSMutableString string];
    for (int i = 0; i < strlen(data); i++) [out appendFormat:@"%c", data[i] ^ key];
    return out;
}

@implementation CAGlobalPhantom

+ (void)deployGlobalShield {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        char k = 'G'; // Global Key
        
        // المسارات العالمية الحساسة
        NSArray *globalPaths = @[
            [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ShadowTrackerExtra/Saved/Logs"],
            [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ShadowTrackerExtra/Saved/PufferData"], // بصمة الجهاز
            [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.tencent.ig"], 
            [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CrashReports"]
        ];

        while (YES) {
            NSFileManager *fm = [NSFileManager defaultManager];
            
            for (NSString *path in globalPaths) {
                if ([fm fileExistsAtPath:path]) {
                    NSArray *files = [fm contentsOfDirectoryAtPath:path error:nil];
                    for (NSString *file in files) {
                        NSString *fFull = [path stringByAppendingPathComponent:file];
                        
                        // 1. تصفير المحتوى
                        [@"" writeToFile:fFull atomically:YES encoding:NSUTF8StringEncoding error:nil];
                        
                        // 2. تزوير التاريخ لعام 1970 (الحل السحري للغيابي)
                        NSDictionary *attr = @{NSFileModificationDate: [NSDate dateWithTimeIntervalSince1970:0]};
                        [fm setAttributes:attr ofItemAtPath:fFull error:nil];
                        
                        // 3. قفل الملف (الآن سيعمل بنجاح بعد إضافة المكتبة)
                        chmod([fFull UTF8String], S_IRUSR | S_IRGRP | S_IROTH);
                    }
                }
            }
            
            // تنظيف وقائي لمجلد SrcCheck
            NSString *srcCheck = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ShadowTrackerExtra/Saved/SrcCheck"];
            if ([fm fileExistsAtPath:srcCheck]) {
                [fm removeItemAtPath:srcCheck error:nil];
            }

            [NSThread sleepForTimeInterval:1.0];
        }
    });
}
@end

__attribute__((constructor))
static void GlobalEntry() {
    freopen("/dev/null", "w", stdout);
    [CAGlobalPhantom deployGlobalShield];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
        mprotect((void *)(base & ~0xFFF), 4096, PROT_READ);
    });
}
