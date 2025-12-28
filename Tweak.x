#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <string.h>
#import "fishhook.h"

// ============================================================================
// تعريفات لتحسين الأداء
// ============================================================================
// متغيرات لتخزين القائمة المرتبة للبحث السريع
static const char **sortedBlockedList = NULL;
static size_t sortedListSize = 0;

// ============================================================================
// القائمة الكاملة (تم دمج جميع النصوص من ملفك)
// ============================================================================
static const char *rawBlockedStrings[] = {
    // --- المصدر 1: القائمة الأساسية والمسارات ---
    "Jailbreak", "Cydia", "CydiaSubstrate", "MobileSubstrate", "Substrate",
    "TweakInject", "Choicy", "Shadow", "Spark", "HideJB", "Sileo", "Zebra",
    "Filza", "Iza", "iFile", "Liberty", "FlyJB", "KernBypass", "Unc0ver", "Checkra1n",
    "apt", "dpkg", "cydia", "fakesigned", "cycript", "substrate",
    "bin/sh", "usr/bin/sshd", "usr/sbin/sshd", "etc/apt",
    "(id)loadPendingCrashReportData", "(TimestamporEventTiming.", "9005_alert", "9010_alert:%s",
    "a:%d,r:%d", "a.MCMoveOnGroundSpeedThreshold", "a.MovingOnGroundSpeedThreshold", "ACH",

    // --- المصدر 2: تقارير الأنشطة وكشف الغش ---
    "ActivityEventReportData", "AIKill", "AIKillPlayerInfo", "AimCameraModeData", "Akamai",
    "anim.GProneMoveSpeedIgnoreRange", "AntiCheatDetailData", "AntiCheatMovementRawData",
    "AntiMoveCheatFlow", "AntiTampering", "AppAttestation", "AppVersion", "ASLR_enforcement",
    "AssetProtection", "AuthInfoKey", "authenticateConnection", "authenticateDevice",
    "authenticateLicenseKey", "authenticateSession", "authenticateUser", "authorizeAccess",
    "authorizeTransaction", "AutoAimingConfig", "AutoAimingRangeConfig", "AVHttpRequest",
    "BattlEye", "BeKilledOpenID", "blockInstantTravel", "blockRuntimeCheats", "blockWebAttacks",
    "BPCalFinalDamage", "BPDie", "BPNotifyStartDying", "BPOnMissPlayerDamageRecord",
    "BPReceiveDamage", "BPReceiveMeleeDamage", "BPReceivePointDamage", "BPReceiveRadialDamage",
    "BPTakeDamage", "BTLaunchMoveSpeedCurve", "Budget.AlwaysTickFalloffAggression",
    "Budget.BudgetPressureSmoothingSpeed", "Budget.WorkUnitSmoothingSpeed",
    "bRestrictSpeedToExpected", "calculateCRC32", "calculatePlayDuration", "CC_MD5state_st",
    "CDUnknownFunctionPointerType", "CFAbsoluteTimeGetCurrent", "checkActivationStatus",
    "checkCodeIntegrity", "checkCodeSignature", "checkDebuggerPresent", "checkFileModification",
    "checkFileSignature", "checkForPatches", "checkGameplayParticipation",

    // --- المصدر 3: التحقق من التكامل ---
    "checkImportTable", "checkIntegrity", "checkLicense", "checkMemorySignature", "checkModIntegrity",
    "checkPlayerActivity", "checkReceipt", "checkRegisteredCanOpenURLScheme",
    "checkResponseTime", "checkSectionPermissions", "checkServerCertificate",
    "checkServerSpeedOverLimit", "checkSHA256Signature", "checkSuspiciousModules",
    "checkSystemTime", "checkValidation", "ClientMoveSpeedCheck", "Client netspeed verification",
    "ClientTimeSpeedCheck", "Cloudflare", "codeSigning", "CONTROL_FLOW_MASTER", "crash logs",
    "crashReportDirectory", "CRITICAL: IMSDK offsets", "CuResFile", "data_encryption_layer",
    "dataReportUrl", "decryptNetworkData", "DeepLearningShotPrediction", "DEP_enforcement",
    "deriveEncryptionKey", "detectAndMitigateDDOS", "detectAFKPattern", "detectBotBehavior",
    "detectCheat", "detectCodeCaves", "detectCodeInjection", "detectDebuggerAttached",
    "detectEmulatorOrRoot", "detectIdlePlayer", "detectInactiveSession", "detectInlinePatches",
    "detectMITM", "detectMemoryTampering", "detectTampering", "detectTimeHacks", "DevEditor",
    "DiscardUnreachable", "DoSuddenStop", "drawDebugCollisionSegments", "DynamicBattleRankInfo",
    "EasyAntiCheat",

    // --- المصدر 4: الحماية والتشفير ---
    "emailProtection", "EmoteData", "Emulator", "EmulatorJailbreakRootDetection",
    "enableCrashReporter", "encryptNetworkData", "enforceActivityPolicy",
    "enforceEncryptionPolicy", "enforceGravityLimits", "enforceMinimumActivity", "EnergyEndLv",
    "EnergyEndTime", "EnergyItemUse", "EnergyLvTimeInfo", "EnergyRecoveryCount",
    "EnergyRecoveryLvTimeInfo", "EnergyRecoveryMax", "EnergyRecoveryMin", "EnergyRecoveryTotal",
    "EnergyRunFastTime", "EnergyStartLv", "EnergyStartTime", "EnemyInterphoneTime",
    "EquipedShootWeapon", "EquipedWeapon", "establishSecureChannel", "EVOFlag_FlyOver",
    "EVOFlag_JumpOver", "EVOFlag_None", "EVOFlag_Stop", "EVOFlag_VelocityUpdate",
    "Exception%@simplePing:didStartWithAddress:PingThreadGNLLogServiceGNLReportManager",
    "F5Networks", "FACEITAntiCheat", "FBSDKLoginEventLogging", "FClientMoveSpeedCheck",
    "FClientTimeSpeedCheck", "FIGHT_AttackerPawn", "FIGHT_FightingPawn", "FIGHT_IsBeAttacking",
    "FinishAvoidObstacle", "flagTampering", "FRealtimeMoveSpeedCheck",
    "FShovelAntiCheat::_VerifyShovelData: Avg speed verify failed", "function_prologue",
    "GameLuaDevEditorLuaFeatureUnitTestBasicPlayerCharacterComponent", "GameLuaMod",
    "GameLuaModLibraryGamePlayFeatureTeleportPawnFeature", "GameModePlayerBattleResultData",
    "GCloudVoice", "GCloudVoiceEngine",

    // --- المصدر 5: حماية الصوت والشبكة ---
    "GCloudVoiceEngine integrity", "GCloudVoiceHttp", "GCloudVoice network checks",
    "generateLiveReport", "generateSessionKey", "generateSignature", "GenerateSignature",
    "getenv", "gettimeofday", "ghost_report_blocker", "GrenadeDamageRecordItem",
    "GSDKInnerRealTimeDetect", "GSDKInGameBlockInvoke", "GSDKInGameSystem", "GSDKLoginEvent",
    "GSDKReportEvent", "GSDKUdpDetect", "GSDKUdpGetSendData", "GSDKUdpHeavy", "GSDKUdpSendV6",
    "GSDKUdpStartTest", "GSDKUdpStartTest2", "guardFunctionEntry", "guardFunctionExit",
    "hasPendingCrashReport", "HBCheck", "HeadShoot", "HeadShootCount", "heap_canary_check",
    "heapProtectionEnable", "hideStringsFromReverse", "hookEnable", "Hooked_ACH", "iAppVersion",
    "iCPUName", "iDevHwModel", "iDevIDFV", "iDevSysVer", "IFSArchiveInterface", "ignoreCommands",
    "IgnoreCommands", "ignoreSignature", "IgnoreSignature", "ilc_close_pipe", "ilc_open_pipe",
    "IMSDKAuthResult", "Imperva", "implementEndToEndEncryption", "implementPerfectForwardSecrecy",
    "InjuryParticleAttachOffset", "initWithApplicationIdentifier", "initWithBundle",
    "input_injection_detection", "integrityReport", "INTEGRITY_CORE", "internalEventLogger",

    // --- المصدر 6: المنطق الداخلي للعبة ---
    "internal.eventLogger", "iScreenCaptured:%d", "IsAttacked", "IsBlocked", "IsBlockedFront",
    "IsCastSkillBlocked", "IsDeath", "IsEmergency", "IsEquipResEnough", "IsGrenadeResEnough",
    "IsGunPartResEnough", "IsGunResEnough", "IsInBlueCircle", "IsInFightingState",
    "IsInHighestPriorityHoldState", "IsInWhiteCircle", "IsInWater", "IsMeleeResEnough",
    "IsMoveBlocked", "IsNearDeath", "IsNeedSuicide", "IsObstacleDetected", "IsOnSquare",
    "IsPathExist", "IsPrecipiceDetected", "IsReloading", "IsResEnough",
    "IsTargetNearBossContainer", "IsUnderGround", "iUUID", "JIT_protection", "Jump_Velocity",
    "KillerAIDisplayUID", "KillerType", "KillerWeaponID", "KillCount", "KniveDamage",
    "KniveDamageRecordItem", "KnockNumber", "KnockOutData", "lagcomp.CustomMoveScale",
    "lagcomp.FollowWalkScale", "lagcomp.highprecisionbasescaleH", "lagcomp.highprecisionbasescaleV",
    "lagcomp.highprecisionspeedscale_h", "lagcomp.highprecisionspeedscale_shakeMax",
    "lagcomp.highprecisionspeedscale_v", "lagcomp.highprecisionspeedscale_vshake",
    "lagcomp.HitBoxInVehicleScaleV", "lagcomp.MuzzleDeviationScaleVehicleSpeed",
    "LastAttackedMeActor", "LimbsShoot", "LimbsShootCount", "loadPendingCrashReportData",
    "logAIPerception", "logErrorQueues", "LogErrorQueues",

    // --- المصدر 7: Lua و المراقبة ---
    "logPathFollowing", "logReportUrl", "logSecurityEvents",
    "LuaActivityCommercializeGamePlayPetPetExhibitFeature",
    "LuaDevGMLuaFeaturePlayerCharacterFlyFeature",
    "LuaModBaseModGamePlayComponentWeatherComponent",
    "LuaModBaseModGamePlayFeatureCampPlayerCharacterCampFeature", "LuaModProtection",
    "LuaObfuscator", "LuaRuntime", "mach_absolute_time", "mach_wait_until",
    "measureEngagementTime", "memory_barrier", "memoryProtectionEnable", "memory_safe_execution",
    "MEMORY_SENTINEL", "methodSignatureForSelector", "Microsoft Commercial Code Signing",
    "Microsoft Individual Code Signing msCodeCom", "Microsoft Trust List Signing",
    "MissPlayerDamageRecord", "monitorCampPosition", "monitorEnvironmentMods", "monitorFileAccess",
    "monitorMalware", "monitorNetworkActivity", "monitorPlayerBehavior", "monitorSystemCalls",
    "monitorUserPresence", "MotorBikeDriverLeaningLowSpeedAnim", "MoveAntiCheat Strategy3",
    "MoveSpeedCurve", "MoveSpeedKMH", "MoveSpeedLimiterCheckFailed", "MoveSpeedParameter",
    "multi_layer_defense", "nanosleep", "NeuralNetworkShotPrediction", "NetMoveSpeedParameter",
    "NSDate", "NtGlobalFlag", "OnActorBump", "OnCharacterAimModeChanged", "OnListenerRegistered",
    "OnListenerUnregistered", "OnListenerUpdated",

    // --- المصدر 8: معالجة البيانات والتقارير ---
    "OnMissPlayerDamageRecord", "OnMoveCompleted", "overrideSignatureCheck", "PathExist",
    "PayloadProtection", "pattern_detection", "pattern_recognition_trigger", "PerformConditionCheck",
    "PerformConditionCheckAI", "performKernelScan", "PickupCount", "PLCrash integration",
    "PLCrashReporter", "PLCrashReporter init", "PLCrashReporter init (IMSDK integration)",
    "PlayerCar", "PlayerCarSpeedAvg", "PlayerCarSpeedMax", "PlayerCharacterComponent",
    "PlayerCreepMoveDis", "PlayerCreepMoveTime", "PlayerDriveMoveDis", "PlayerDriveMoveTime",
    "PlayerKillAI", "PlayerKillAIInfo", "PlayerMoveDis", "PlayerRunMoveDis", "PlayerRunMoveTime",
    "PlayerSpeedAvg", "PlayerSpeedMax", "PlayerSquatMoveDis", "PlayerSquatMoveTime",
    "pointer_authentication", "preventDebugging", "preventDuping", "preventIdleExploit",
    "preventReplayAttacks", "processCommands", "ProcessCommands", "ProductVersion",
    "profile_shield", "protectAssets", "protectFromDDOS", "protectLuaFeatures", "protectNetwork",
    "ptrace", "pthread_yield", "purgePendingCrashReport", "qos_cnt", "qos_filt", "qos_%d",
    "Radware", "randomness_analysis_aim", "RealtimeMoveSpeedCheck", "RecoveryCount", "RecoveryMax",

    // --- المصدر 9: الإبلاغ والتحقق ---
    "RecoveryMin", "RecoveryTotal", "remoteConfigUrl", "removeSingletonObjectForUnitTest",
    "RepVehicleAttachment", "ReportAimFlow", "ReportAttackFlow", "ReportCircleFlow",
    "ReportEventstopPing", "ReportGameBaseInfo", "ReportGameEndFlow", "ReportGameSetting",
    "ReportGameStartFlow", "ReportHurtFlow", "ReportJumpFlow", "ReportMrpcsFlow",
    "ReportPlayerKillFlow", "ReportSecAttackFlow", "ReportSpeedException", "ReportVerifyInfoFlow",
    "ReportVoiceTeamCreate", "ReportVoiceTeamQuit", "resetHandlers", "return_sequence",
    "RicochetAntiCheat", "root_alert:%s", "ROP_prevention", "runIntegrityTests",
    "RuntimeApplicationSelfProtection", "sandbox_enforcement", "SATANIC_STACK_GUARD",
    "scanAerialCheats", "scanMemoryForHooks", "scanTeleportAnomalies", "sched_yield", "sc_dlp",
    "sc_idle", "sc_protect", "secureHandshake", "secureKeyExchange", "secureSalt", "SecureSalt",
    "secureTraffic", "secureValidation", "SecureValidation", "self_healing_system",
    "ServerBulletSpeed", "server response", "setCrashCallbacks", "shadow_protection", "SHA256",
    "SHA256Hash", "sharedReporter", "sharedReporter (IMSDK crash telemetry)", "ShootDamageTipsStr",

    // --- المصدر 10: التوقيعات والأمان ---
    "signatureForGroupPro", "SignatureCheck", "signData", "singletonNameC", "sleep",
    "SpecialWeaponRecord", "SpeedUp", "SpeedUpParticle", "stack_canary_check", "stack_frame_setup",
    "stackProtectionEnable", "Stamping", "stat", "Sucuri", "SysVersion", "syscall_intercept",
    "sysctl", "tamperDetection", "TamperDetection", "TargetEnemyActor", "TargetEnemyIsAI",
    "TargetEnemyVehicle", "TargetLerpSpeedHorizontalCurve", "TargetLerpSpeedVerticalCurve",
    "target_lock_cheat_detection", "tcj_protect", "TeammateInterphoneTime", "TeammateList",
    "terminateIdleConnection", "ThrowCount", "timeStamping", "timestamping", "TPAT",
    "TPATErrorQueue", "trackResourceUsage", "trackUserInteraction", "triggerbot_detection",
    "ts2,r:%d", "UCreativeModeBlueprintLibrary::SetSpeedOverLimit",
    "ULagCompensationComponentBase::CustomMoveScale",
    "ULagCompensationComponentBase::EnableHighPrecisionBaseScaleH",
    "ULagCompensationComponentBase::EnableHighPrecisionBaseScaleV",
    "ULagCompensationComponentBase::EnableHighPrecisionSpeedHScale",
    "ULagCompensationComponentBase::EnableHighPrecisionSpeedShakeHScale",
    "ULagCompensationComponentBase::EnableHighPrecisionSpeedShakeMax",
    "ULagCompensationComponentBase::EnableHighPrecisionSpeedShakeVScale",
    "ULagCompensationComponentBase::EnableHighPrecisionSpeedVScale",
    "ULagCompensationComponentBase::FollowWalkScale",

    // --- المصدر 11: التحقق من التوافق ---
    "ULagCompensationComponentBase::HitBoxInVehicleScaleV",
    "ULagCompensationComponentBase::MuzzleDeviationScaleVehicleSpeed", "UniqueHitCount",
    "UUAESkillConditionMoveSpeed", "UUAESkillConditionMoveSpeedAxis", "UseCount", "usleep",
    "validateAndReturnError", "validateAppID", "validateAppLegitimacy", "validateBinaryIntegrity",
    "validateChecksum", "validateClientAccessToken", "validateContinuousPlay", "validateEnvironment",
    "validateExecutableHash", "validateExportTable", "validateFacebookReservedURLSchemes",
    "validateIdentifier", "validateImportTable", "validateLicense", "validateMemoryRegions",
    "validateMessageIntegrity", "validatePlayer", "validatePlayerActive", "validatePlayerMovement",
    "validateProtocolVersion", "validatePurchaseReceipt", "validateReceipt", "validateResourceFiles",
    "validateSessionToken", "validateSignature", "validateURLSchemes", "validateUserSource",
    "validateWithError", "validateWithOptions", "verifyAppLegitimacy", "verifyBinaryIntegrity",
    "verifyChecksum", "verifyDigitalSignature", "verifyFunctionHooks", "verifyIntegrity",
    "verifyLicenseKey", "verifyMessageIntegrity", "verifyPurchase", "verifyReceipt",
    "verifyResourceFiles", "verifyServerCertificate", "verifySignature", "VerifySignature",
    "VirtualBox", "VirtualMachine", "VNG", "VNGQueue", "VO_CacheVelocity",

    // --- المصدر 12: المقاييس المتقدمة ---
    "VO_Duration", "VO_ObstacleCenter", "VO_Obstacles", "VO_OriginLoc", "VO_Step", "VO_Velocity",
    "voice anti-hook", "Voice anti-hook", "voice engine", "voiceMessageUrl", "voiceReportUrl",
    "voiceTranslateUrl", "voiceUrl", "WeaponDamageRecord", "writeSectorChecksums",
    "_AntiCheatLuaCheck", "_EnableObfuscationScan", "_ErrorReportLua", "_FBSDKLoginEventLogging",
    "_ReportModTamper", "- DoSuddenStop", "- EVOFlag::EVOFlag_FlyOver",
    "- EVOFlag::EVOFlag_JumpOver", "- EVOFlag::EVOFlag_None", "- EVOFlag::EVOFlag_Stop",
    "- EVOFlag::EVOFlag_VelocityUpdate", "- FinishAvoidObstacle", "- IsMoveBlocked",
    "- IsObstacleDetected", "- IsPrecipiceDetected", "- Jump_Velocity", "- VO_CacheVelocity",
    "- VO_Duration", "- VO_ObstacleCenter", "- VO_Obstacles", "- VO_OriginLoc", "- VO_Step",
    "- VO_Velocity", "a:%d,r:%d", "cs_qa_stat", "hb_loop", "iScreenCaptured:%d",
    "msg_box_dismiss:sys:msg_box_id=%d|btn_id=%d", "msgbox:%d|%s|%s|%s|%s|%s|%d|%d",

    // --- المصدر 13: السجلات والتنسيقات ---
    "n:%s,t:%s,id:%s", "root_alert:%s", "sc_dlp", "sc_idle", "ts2,r:%d", "%s*** %d===%c",
    "%s*** GSDKReportEvent eventName:", "%s*** recv len failed, echotime:%d", "%s*** send===%d===",
    "GSDKUdpTest getSendData", "GSDKUdpTest Heavy",
    "GSDKUdpTest startUdpTest:Sport:Pcntx00:Frequenc",
    "GSDKUdpTest startUdpTest:Sport:Pcntx00:Frequency", "GSDKUdpTest sendV6Data:Data",
    "GSDKUdpDetect isUDPConnect:Port:", "anti_sp2s", "force_built_in_ip", "FightbackEnemyActor",
    "AllocateSectorChecksums", "AllocateSectorChecksumsForEntry", "WriteSectorChecksums",
    "DescriptionWithProjection", "DescriptionWithTrace", "inc_id:%d", "DeadCircleIndex",
    "anti_false_report", "anti_ghost_report", "report_cooldown", "report_scoring",
    "report_system_init", "report_validation", "player_report_handler", "prevent_scoli_report",
    "protect_my_profile", "ai_report_analyzer", "anomaly_detection", "behavioral_pattern",
    "integrity_checker", "tamper_detection", "self_healing_system", "quantum_protection",
    "temporal_shield", "neural_defense", "blockchain_validator", "antiDebugEnable",
    "antiTamperEnable",

    // --- المصدر 14: التحقق الأمني الأساسي ---
    "BeingDebugged", "monitoring", "detection", "checkPlayerActivity", "detectIdlePlayer",
    "verifyChecksum", "monitorNetworkActivity", "validateEnvironment", "enableCrashReporter",
    "generateLiveReport", "validateIdentifier", "verifyPurchase", "checkIntegrity",
    "detectTampering", "monitorSystemCalls", "authenticateSession", "stack_canary_check",
    "control_flow_integrity", "stack_frame_setup", "logSecurityEvents", "trackResourceUsage",
    "checkSystemTime", "generateSecurityLog", "memory_barrier", "return_sequence",
    "function_prologue", "checkFileModification", "encryptNetworkData", "preventDebugging",
    "validateBinaryIntegrity", "detectDebuggerAttached", "verifyDigitalSignature",
    "authenticateLicenseKey", "establishSecureChannel", "encryptNetworkData", "decryptNetworkData",
    "secureHandshake", "verifyServerCertificate", "validateSessionToken", "authenticateConnection",
    "generateSessionKey", "deriveEncryptionKey", "implementPerfectForwardSecrecy",
    "preventReplayAttacks", "detectMITM", "verifyMessageIntegrity", "signData", "verifySignature",
    "protectAgainstEavesdropping", "implementEndToEndEncryption", "secureKeyExchange",
    "validateProtocolVersion", "enforceEncryptionPolicy", "heap_canary_check",
    "control_flow_integrity", "pointer_authentication", "memory_safe_execution",

    // --- المصدر 15: حماية الذاكرة والعمليات ---
    "code_signing_verify", "runtime_integrity_check", "exception_handler_setup",
    "signal_handler_protect", "syscall_intercept", "API_hook_detect", "JIT_protection",
    "ROP_prevention", "ASLR_enforcement", "DEP_enforcement", "sandbox_enforcement",
    "verifyBinaryIntegrity", "checkFileModification", "detectTampering", "validateExecutableHash",
    "checkCodeSignature", "verifyResourceFiles", "detectDebuggerAttached", "checkDebuggerPresent",
    "preventDebugging", "checkSuspiciousModules", "scanMemoryForHooks", "detectInlinePatches",
    "checkFunctionHooks", "validateImportTable", "verifyExportTable", "checkSectionPermissions",
    "validateMemoryRegions", "detectCodeCaves", "checkForPatches", "verifyChecksum",
    "calculateCRC32", "validateMD5Hash", "checkSHA256Signature", "verifyDigitalSignature",
    "validateLicense", "checkActivationStatus", "verifyPurchaseReceipt", "authenticateLicenseKey",
    "checkPlayerActivity", "detectIdlePlayer", "monitorUserPresence", "verifyPlayerActive",
    "trackUserInteraction", "validatePlayerMovement", "checkGameplayParticipation",
    "detectInactiveSession", "terminateIdleConnection", "enforceActivityPolicy",
    "measureEngagementTime", "calculatePlayDuration", "validateContinuousPlay", "detectAFKPattern",
    "preventIdleExploit", "monitorInputFrequency", "checkResponseTime",

    // --- المصدر 16: التحقق من الوقت والاستجابة ---
    "verifyRealTimeAction", "enforceMinimumActivity", "detectBotBehavior", "enableCrashReporter",
    "generateLiveReport", "setCrashCallbacks", "hasPendingCrashReport",
    "loadPendingCrashReportData", "purgePendingCrashReport", "validateIdentifier", "validateAppID",
    "validateURLSchemes", "checkRegisteredCanOpenURLScheme", "validateFacebookReservedURLSchemes",
    "validateRequiredClientAccessToken", "validateAndReturnError", "validateWithError",
    "validateWithOptions", "verifyPurchase", "verifyReceipt", "validateReceipt", "checkReceipt",
    "detectMemoryTampering", "detectCodeInjection", "reportSuspiciousActivity", "reportPlayer",
    "monitorSystemCalls", "monitorFileAccess", "monitorNetworkActivity", "checkIntegrity",
    "checkFileSignature", "checkMemorySignature", "authenticateSession", "authenticateUser",
    "authenticateDevice", "authorizeTransaction", "authorizeAccess", "securityCheck",
    "protectionValidate", "guardFunctionEntry", "guardFunctionExit", "stackProtectionEnable",
    "heapProtectionEnable", "memoryProtectionEnable", "report_scoring", "pattern_detection",
    "credibility_check", "preventive_block", "rate_limiting", "challenge_system",
    "ai_report_analyzer", "behavioral_pattern", "anomaly_detection", "crypto_layer_1",
    "crypto_layer_2",

    // --- المصدر 17: أنظمة الحماية المتقدمة ---
    "crypto_layer_3", "integrity_checker", "tamper_detection", "self_healing_system",
    "quantum_protection", "temporal_shield", "neural_defense", "blockchain_validator",
    "click_capt", "PlayerNetStats، GameModeLikeResultData",
    "UBulletTrackComponent::CalculateRecoveryTarget_Tss_Failed_By_OwnerCharacter_Is_Null",
    "UBulletTrackComponent::CalcDeviationTarget_Tss_Return_By_OwnerCharacter_Is_Null",
    "UBulletTrackComponent::CalcDeviationTarget_Tss_Return_By_OwnerShootWeapon_Is_Null",
    "UBulletTrackComponent::CalcDeviationTarget_Tss_Return_By_PawnMovementComponent_Is_Null",
    "UBulletTrackComponent::CalcDeviationTarget_Tss_Return_By_Plc_Is_Null",
    "UBulletTrackComponent::CalcDeviationTarget_Tss_Return_By_PlcIsLocalControllerIsFalse",
    "UBulletTrackComponent::CalcDeviationTarget_Tss_Return_By_STPlc_Is_Null",
    "UBulletTrackComponent::HandleGetOwnerActor_Return_By_OwnerActor_IsNull",
    "UBulletTrackComponent::OnEquip_Return_By_OwnerShootWeapon_Is_Null",
    "UBulletTrackComponent::OnEquip_Return_By_OwnerShootWeapon_Is_Null_2",
    "UBulletTrackComponent::OnUpdate_Return_By_OwnerCharacter_Is_Null",
    "UBulletTrackComponent::OnUpdate_Return_By_OwnerPlayerController_Is_Null",
    "UBulletTrackComponent::OnUpdate_Return_By_OwnerShootWeapon_Is_Null",
    "UBulletTrackComponent::UpdateRecoilFactor_Tss_Failed_By_OwnerCharacter_Is_Null",
    "USpecialMoveBaseObj::SpecialMoveServerCheckClientError"
};

// ============================================================================
// الدوال المساعدة (Helper Functions)
// ============================================================================

// دالة المقارنة لاستخدامها في الترتيب (qsort) والبحث (bsearch)
int compareStrings(const void *a, const void *b) {
    return strcmp(*(const char **)a, *(const char **)b);
}

// دالة البحث السريع (Binary Search)
// هذه الدالة سريعة جداً وتمنع الـ Lag في اللعبة
static BOOL isStringBlocked(const char *input) {
    if (!input || !sortedBlockedList) return NO;
    
    // استخدام bsearch للبحث السريع (O(log n))
    void *result = bsearch(&input, sortedBlockedList, sortedListSize, sizeof(char *), compareStrings);
    return (result != NULL);
}

// ============================================================================
// تعريف الدوال الأصلية
// ============================================================================
static int (*orig_strcmp)(const char *, const char *);
static char* (*orig_strstr)(const char *, const char *);

// ============================================================================
// الهوك (Hooks)
// ============================================================================

// هوك دالة strcmp: تستخدم عندما يتحقق التطبيق من تطابق نص كامل
int hooked_strcmp(const char *s1, const char *s2) {
    // 1. الحماية من المؤشرات الفارغة (منع الكراش)
    if (!orig_strcmp) return 0;
    if (!s1 || !s2) return orig_strcmp(s1, s2);
    
    // 2. التحقق من القائمة المحظورة
    // إذا كان s1 هو "Cydia" واللعبة تقارنه بـ "Cydia"، سنرجع 1 (غير متطابق)
    if (isStringBlocked(s1) || isStringBlocked(s2)) {
        // نرجع -1 (أو أي رقم غير الصفر) لنقول للعبة: "النصان غير متطابقين"
        return -1;
    }
    
    return orig_strcmp(s1, s2);
}

// هوك دالة strstr: تستخدم عندما يبحث التطبيق عن كلمة داخل نص طويل
char* hooked_strstr(const char *haystack, const char *needle) {
    // 1. الحماية من المؤشرات الفارغة
    if (!orig_strstr) return NULL;
    if (!haystack || !needle) return orig_strstr(haystack, needle);
    
    // 2. التحقق مما إذا كانت الكلمة المبحوث عنها (needle) محظورة
    if (isStringBlocked(needle)) {
        // إذا كانت اللعبة تبحث عن "Substrate" في قائمة الملفات، نرجع NULL
        // هذا يعني "لم يتم العثور على الكلمة"
        return NULL;
    }
    
    return orig_strstr(haystack, needle);
}

// ============================================================================
// دالة التشغيل الآمن (Constructor)
// ============================================================================
__attribute__((constructor))
static void SafeInit() {
    // استخدام dispatch_once لضمان التنفيذ مرة واحدة فقط بأمان تام
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"[Shield] 🛡️ Initializing Protection System...");

        // 1. إعداد القائمة للبحث السريع (Binary Search Setup)
        // نسخ القائمة الأصلية إلى مصفوفة قابلة للتعديل للترتيب
        sortedListSize = sizeof(rawBlockedStrings) / sizeof(char *);
        sortedBlockedList = malloc(sortedListSize * sizeof(char *));
        
        if (sortedBlockedList) {
            // نسخ البيانات
            memcpy(sortedBlockedList, rawBlockedStrings, sortedListSize * sizeof(char *));
            
            // ترتيب القائمة أبجدياً لتفعيل البحث الثنائي السريع
            qsort(sortedBlockedList, sortedListSize, sizeof(char *), compareStrings);
            NSLog(@"[Shield] ✅ Database loaded with %zu entries.", sortedListSize);
        }

        // 2. ربط الدوال (Hooking)
        struct rebinding rebinds[] = {
            {"strcmp", (void *)hooked_strcmp, (void **)&orig_strcmp},
            {"strstr", (void *)hooked_strstr, (void **)&orig_strstr}
        };

        int err = rebind_symbols(rebinds, 2);
        if (err == 0) {
            NSLog(@"[Shield] ✅ Hooks activated successfully (No-JB Mode).");
        } else {
            NSLog(@"[Shield] ❌ Failed to activate hooks (Error: %d).", err);
        }
    });
}
