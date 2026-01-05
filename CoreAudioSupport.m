#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

// 🛡️ V44: Safe Guard - استقرار تام بدون كراش
@interface CASystemOptimizer : NSObject
+ (instancetype)shared;
- (void)startSafeLogCleaner;
@end

@implementation CASystemOptimizer
+ (instancetype)shared {
    static CASystemOptimizer *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ inst = [[self alloc] init]; });
    return inst;
}

- (void)startSafeLogCleaner {
    // تشغيل في الخلفية (أولوية منخفضة لعدم التأثير على اللعب)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // قائمة المجلدات المستهدفة
        NSArray *logFolders = @[
            [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ShadowTrackerExtra/Saved/Logs"],
            [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ShadowTrackerExtra/Saved/Paks"],
            [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CrashReports"],
            [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
        ];

        while (YES) {
            NSFileManager *fm = [NSFileManager defaultManager];
            
            for (NSString *folderPath in logFolders) {
                // بدلاً من حذف المجلد (الذي يسبب كراش)، سنحذف الملفات بداخله فقط
                NSArray *files = [fm contentsOfDirectoryAtPath:folderPath error:nil];
                for (NSString *file in files) {
                    NSString *fullPath = [folderPath stringByAppendingPathComponent:file];
                    // حذف الملف بصمت
                    [fm removeItemAtPath:fullPath error:nil];
                }
            }
            
            // تكرار العملية كل ثانية (كافية جداً وآمنة)
            [NSThread sleepForTimeInterval:1.0];
        }
    });
}
@end

// نقطة البداية الآمنة
__attribute__((constructor))
static void SafeEntry() {
    // 1. قتل المخرجات (آمن ولا يسبب كراش)
    freopen("/dev/null", "w", stdout);
    freopen("/dev/null", "w", stderr);

    // 2. تشغيل منظف السجلات الآمن
    [[CASystemOptimizer shared] startSafeLogCleaner];
    
    // ⚠️ ملاحظة: تم حذف mprotect و symlink تماماً لأنها سبب الكراش
}
