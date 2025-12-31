#import "CommonTypes.h"

// إعلان مسبق للكلاسات لتجنب أخطاء التكرار
@class MemoryExploiter, BehaviorSpoofer, NetworkManipulator, AIEvader, ServerSpoofer, HardwareSpoofer;

@interface SovereignSecurity : NSObject

#pragma mark - الأنظمة المعكوسة
@property (strong, nonatomic) MemoryExploiter *memoryExploiter;
@property (strong, nonatomic) BehaviorSpoofer *behaviorSpoofer;
@property (strong, nonatomic) NetworkManipulator *networkManipulator;
@property (strong, nonatomic) AIEvader *aiEvader;
@property (strong, nonatomic) ServerSpoofer *serverSpoofer;
@property (strong, nonatomic) HardwareSpoofer *hardwareSpoofer;

#pragma mark - الدوال الأساسية
+ (instancetype)master;
- (void)initializeWithOverride:(NSDictionary *)config;
- (void)startExploitation;
- (void)monitorInRealTime;

@end
