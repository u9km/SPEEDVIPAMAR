#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreML/CoreML.h>

// تعريفات الفئات كمؤشرات للمترجم
@interface PlayerData : NSObject @end
@interface AimData : NSObject @end
@interface MovementData : NSObject @end
@interface VisionData : NSObject @end
@interface PhysicsData : NSObject @end
@interface MoveConstraints : NSObject @end
@interface ShotData : NSObject @end
@interface ClientState : NSObject @end
@interface PlayerAction : NSObject @end
@interface ValidationResult : NSObject @end
@interface CheatDetection : NSObject @end
@interface SecurityAlert : NSObject @end
@interface CheatPrediction : NSObject @end
@interface VideoFrame : NSObject @end

@interface VulnerabilityAssessment : NSObject 
@property (assign) float successRate;
@property (assign) NSInteger attackType;
@end

@interface VulnerabilityAnalysis : NSObject 
- (void)findSecurityGaps:(NSDictionary *)data;
- (void)applyExploitAlgorithms;
- (float)calculateSuccessRate;
- (NSInteger)determineOptimalAttack;
- (id)generateDetailedAttackPlan;
- (float)calculateStealthLevel;
@end

@interface AttackPlan : NSObject @end
