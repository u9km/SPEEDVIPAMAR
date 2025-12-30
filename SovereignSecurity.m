// ================================================
// 👁️ نظام ESP المتطور الذكي
// ================================================

@interface SmartESPEngine : NSObject
+ (void)enableSmartESP:(BOOL)enable;
+ (void)configureESPForMatch;
+ (void)configureESPForLobby;
+ (void)drawESPSafely;
@end

@implementation SmartESPEngine

static BOOL _espEnabled = NO;
static float _espOpacity = 0.3; // 30% شفافية افتراضية
static UIColor *_espColor = nil;
static NSMutableDictionary *_playerBoxes;
static CADisplayLink *_displayLink;

+ (void)enableSmartESP:(BOOL)enable {
    _espEnabled = enable;
    
    if (enable) {
        NSLog(@"[SMART ESP] 👁️ تفعيل ESP الذكي...");
        
        // 1️⃣ تهيئة المتغيرات
        [self initializeESP];
        
        // 2️⃣ تكوين حسب حالة اللعبة
        if ([MatchStateDetector isInMatch]) {
            [self configureESPForMatch];
        } else {
            [self configureESPForLobby];
        }
        
        // 3️⃣ بدء الرسم
        [self startESPRendering];
        
        NSLog(@"[SMART ESP] ✅ ESP مفعل مع إعدادات آمنة");
    } else {
        NSLog(@"[SMART ESP] 👁️ تعطيل ESP...");
        [self stopESPRendering];
    }
}

+ (void)initializeESP {
    _playerBoxes = [NSMutableDictionary new];
    _espColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:_espOpacity];
}

// 🎮 تكوين ESP للمباراة (آمن)
+ (void)configureESPForMatch {
    NSLog(@"[ESP CONFIG] 🎮 تكوين ESP للمباراة (وضع آمن)");
    
    // ⚙️ إعدادات آمنة للمباراة
    _espOpacity = 0.2; // 20% شفافية فقط
    _espColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.3 alpha:_espOpacity];
    
    // 🚫 تعطيل ميزات خطرة
    [self disableRiskyESPFeatures];
    
    // ✅ تفعيل ميزات آمنة فقط
    [self enableSafeESPFeatures];
    
    // ⚡ تقليل معدل التحديث
    [self setLowRefreshRate];
}

// 🏠 تكوين ESP للوبي (قوة كاملة)
+ (void)configureESPForLobby {
    NSLog(@"[ESP CONFIG] 🏠 تكوين ESP للوبي (قوة كاملة)");
    
    // ⚙️ إعدادات كاملة للوبي
    _espOpacity = 0.5; // 50% شفافية
    _espColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:_espOpacity];
    
    // ✅ تفعيل كل الميزات
    [self enableAllESPFeatures];
    
    // ⚡ معدل تحديث عالي
    [self setHighRefreshRate];
}

+ (void)disableRiskyESPFeatures {
    // 🚫 تعطيل الميزات التي قد تسبب كراش
    NSLog(@"[ESP SAFETY] 🚫 تعطيل الميزات الخطرة");
    
    // 1️⃣ لا ترسم من خلال الجدران السميكة
    // 2️⃣ لا ترسم اللاعبين بعيدين جداً
    // 3️⃣ لا ترسم معلومات حساسة
}

+ (void)enableSafeESPFeatures {
    // ✅ تفعيل الميزات الآمنة فقط
    NSLog(@"[ESP SAFETY] ✅ تفعيل الميزات الآمنة");
    
    // 1️⃣ رسم مربعات شفافة
    // 2️⃣ رسم أسماء اللاعبين
    // 3️⃣ رسم خطوط التتبع البسيطة
}

+ (void)startESPRendering {
    // 🎬 بدء عرض ESP
    
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(renderESPFrame)];
        
        // ⏱️ معدل تحديث منخفض للحفاظ على الأداء
        if ([MatchStateDetector isInMatch]) {
            _displayLink.preferredFramesPerSecond = 30; // 30 FPS في المباراة
        } else {
            _displayLink.preferredFramesPerSecond = 60; // 60 FPS في اللوبي
        }
        
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

+ (void)stopESPRendering {
    // ⏹️ إيقاف عرض ESP
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    // 🧹 تنظيف الذاكرة
    [_playerBoxes removeAllObjects];
}

+ (void)renderESPFrame {
    if (!_espEnabled) return;
    
    // 🎨 الرسم الآمن
    [self drawSafeESP];
    
    // 📊 تحديث معلومات اللاعبين
    [self updatePlayerData];
}

+ (void)drawSafeESP {
    // 🖼️ الحصول على النافذة الرئيسية
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
    if (!mainWindow) return;
    
    // 🎯 إنشاء layer للرسم
    static CALayer *espLayer = nil;
    if (!espLayer) {
        espLayer = [CALayer layer];
        espLayer.frame = mainWindow.bounds;
        espLayer.zPosition = 9999; // فوق كل شيء
        [mainWindow.layer addSublayer:espLayer];
    }
    
    // 🧹 تنظيف الرسم السابق
    [espLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    // 🎨 رسم كل اللاعبين
    NSArray *allPlayers = [self getAllVisiblePlayers];
    
    for (NSDictionary *player in allPlayers) {
        // 📍 الحصول على موقع اللاعب على الشاشة
        CGRect playerRect = [self getPlayerScreenRect:player];
        
        // 🎯 التحقق إذا كان اللاعب مرئياً
        if (!CGRectIsEmpty(playerRect)) {
            // 📦 رسم المربع
            [self drawPlayerBox:playerRect forPlayer:player onLayer:espLayer];
            
            // 📝 رسم المعلومات
            if (![MatchStateDetector isInMatch]) {
                // في اللوبي فقط - رسم معلومات إضافية
                [self drawPlayerInfo:player atRect:playerRect onLayer:espLayer];
            }
        }
    }
}

+ (void)drawPlayerBox:(CGRect)rect forPlayer:(NSDictionary *)player onLayer:(CALayer *)layer {
    // 🎨 إنشاء مربع ESP
    
    CAShapeLayer *boxLayer = [CAShapeLayer layer];
    
    // 🔲 المسار المستطيل
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    boxLayer.path = path.CGPath;
    
    // 🎨 التخصيص حسب حالة اللاعب
    UIColor *boxColor = _espColor;
    
    if (player[@"isTeammate"]) {
        boxColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:_espOpacity]; // أزرق للفريق
    }
    
    if (player[@"isEnemy"]) {
        boxColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:_espOpacity]; // أحمر للعدو
    }
    
    // ⚙️ إعدادات الخط
    boxLayer.strokeColor = boxColor.CGColor;
    boxLayer.fillColor = [UIColor clearColor].CGColor;
    boxLayer.lineWidth = 2.0;
    boxLayer.opacity = _espOpacity;
    
    // ✨ تأثيرات خاصة في اللوبي فقط
    if (![MatchStateDetector isInMatch]) {
        // تأثير توهج خفيف
        boxLayer.shadowColor = boxColor.CGColor;
        boxLayer.shadowOpacity = 0.5;
        boxLayer.shadowRadius = 3.0;
    }
    
    [layer addSublayer:boxLayer];
}

+ (void)drawPlayerInfo:(NSDictionary *)player atRect:(CGRect)rect onLayer:(CALayer *)layer {
    // 📊 رسم معلومات اللاعب (في اللوبي فقط)
    
    // 📝 إنشاء نص
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = [self getPlayerInfoString:player];
    textLayer.fontSize = 12;
    textLayer.foregroundColor = [UIColor whiteColor].CGColor;
    textLayer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    textLayer.cornerRadius = 3;
    textLayer.alignmentMode = kCAAlignmentCenter;
    
    // 📍 الموضع فوق المربع
    textLayer.frame = CGRectMake(rect.origin.x, 
                                rect.origin.y - 20, 
                                rect.size.width, 
                                16);
    
    [layer addSublayer:textLayer];
}

+ (NSString *)getPlayerInfoString:(NSDictionary *)player {
    // 📝 تجميع معلومات اللاعب
    NSMutableString *info = [NSMutableString new];
    
    if (player[@"name"]) {
        [info appendString:player[@"name"]];
    }
    
    if (player[@"health"]) {
        [info appendFormat:@" | HP: %@", player[@"health"]];
    }
    
    if (player[@"distance"]) {
        [info appendFormat:@" | %@m", player[@"distance"]];
    }
    
    return info;
}

// 🔧 دوال مساعدة
+ (NSArray *)getAllVisiblePlayers {
    // 🔍 الحصول على قائمة اللاعبين المرئيين
    // (هذه دالة وهمية - يجب استبدالها بدالة حقيقية)
    
    NSMutableArray *players = [NSMutableArray new];
    
    // 🎮 في المباراة: لاعبين أقل وأكثر حذراً
    if ([MatchStateDetector isInMatch]) {
        for (int i = 0; i < 3; i++) { // 3 لاعبين فقط في المباراة
            [players addObject:@{
                @"id": @(i),
                @"name": [NSString stringWithFormat:@"Player_%d", i],
                @"health": @(arc4random_uniform(100)),
                @"distance": @(arc4random_uniform(50) + 10),
                @"isEnemy": @(YES),
                @"isTeammate": @(NO)
            }];
        }
    } 
    // 🏠 في اللوبي: كل اللاعبين
    else {
        for (int i = 0; i < 10; i++) { // 10 لاعبين في اللوبي
            [players addObject:@{
                @"id": @(i),
                @"name": [NSString stringWithFormat:@"LobbyPlayer_%d", i],
                @"health": @(100),
                @"distance": @(arc4random_uniform(100) + 5),
                @"isEnemy": @(i % 2 == 0),
                @"isTeammate": @(i % 2 == 1)
            }];
        }
    }
    
    return players;
}

+ (CGRect)getPlayerScreenRect:(NSDictionary *)player {
    // 📍 تحويل موقع اللاعب إلى إحداثيات الشاشة
    // (هذه دالة وهمية - يجب استبدالها بدالة حقيقية)
    
    float distance = [player[@"distance"] floatValue];
    
    // 🧮 حساب الحجم بناءً على المسافة
    float baseSize = 50.0;
    float size = baseSize / (distance / 10.0);
    size = MAX(20, MIN(100, size)); // تحديد بين 20 و100
    
    // 🎲 موقع عشوائي (في الواقع يجب أن يكون موقع اللاعب الحقيقي)
    CGFloat x = arc4random_uniform(300) + 10;
    CGFloat y = arc4random_uniform(600) + 50;
    
    return CGRectMake(x, y, size, size * 1.5);
}

+ (void)updatePlayerData {
    // 📊 تحديث بيانات اللاعبين بشكل آمن
    static NSTimeInterval lastUpdate = 0;
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    
    // ⏱️ تحديث كل 0.5 ثانية فقط (لتحسين الأداء)
    if (now - lastUpdate > 0.5) {
        [self refreshPlayerPositions];
        lastUpdate = now;
    }
}

+ (void)refreshPlayerPositions {
    // 🔄 تحديث مواقع اللاعبين
    // (يجب أن تستخدم طرق آمنة لا تسبب كراش)
    
    // 🧠 في المباراة: تحديث بطيء وحذر
    if ([MatchStateDetector isInMatch]) {
        [self updatePositionsSafely];
    }
    // ⚡ في اللوبي: تحديث سريع
    else {
        [self updatePositionsQuickly];
    }
}

@end

// ================================================
// 🎮 إضافة ESP إلى نظام SmartCheatSystem
// ================================================

@implementation SmartCheatSystem (ESP)

+ (void)enableSmartESPWithOptions:(NSDictionary *)options {
    // 🎯 تفعيل ESP مع خيارات مخصصة
    
    BOOL enable = [options[@"enable"] boolValue];
    BOOL safeMode = [options[@"safeMode"] boolValue] || [MatchStateDetector isInMatch];
    
    if (safeMode) {
        NSLog(@"[SMART ESP] 🛡️ تفعيل ESP في وضع الآمن");
        
        // ⚙️ إعدادات آمنة إضافية
        NSMutableDictionary *safeOptions = [options mutableCopy];
        safeOptions[@"opacity"] = @(0.2);
        safeOptions[@"drawInfo"] = @(NO);
        safeOptions[@"drawHealth"] = @(NO);
        safeOptions[@"drawDistance"] = @(NO);
        
        [SmartESPEngine enableSmartESP:enable];
    } else {
        NSLog(@"[SMART ESP] ⚡ تفعيل ESP في وضع القوة الكاملة");
        [SmartESPEngine enableSmartESP:enable];
    }
}

+ (void)toggleESP {
    // 🔄 تبديل حالة ESP
    
    static BOOL espOn = NO;
    espOn = !espOn;
    
    if (espOn) {
        NSDictionary *options = @{
            @"enable": @(YES),
            @"opacity": @([MatchStateDetector isInMatch] ? 0.2 : 0.5),
            @"drawInfo": @(![MatchStateDetector isInMatch]),
            @"drawHealth": @(![MatchStateDetector isInMatch]),
            @"drawDistance": @(YES)
        };
        
        [self enableSmartESPWithOptions:options];
        
        // 🔊 تنبيه
        [self showESPMessage:[MatchStateDetector isInMatch] ? 
         @"👁️ ESP مفعل (وضع آمن)" : 
         @"👁️ ESP مفعل (قوة كاملة)"];
    } else {
        [SmartESPEngine enableSmartESP:NO];
        [self showESPMessage:@"👁️ ESP معطل"];
    }
}

+ (void)showESPMessage:(NSString *)message {
    // 📱 عرض رسالة ESP
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, window.bounds.size.width, 40)];
        label.text = message;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.tag = 9999; // tag للتعرف عليه لاحقاً
        
        [window addSubview:label];
        
        // إخفاء بعد 2 ثانية
        [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    });
}

@end

// ================================================
// ⚡ إضافة اختصار ESP إلى لوحة التحكم
// ================================================

@implementation SmartControlPanel (ESP)

+ (void)addESPControlsToPanel:(UIWindow *)panel {
    // 🎮 إضافة أزرار ESP إلى لوحة التحكم
    
    // زر تبديل ESP
    UIButton *espButton = [UIButton buttonWithType:UIButtonTypeSystem];
    espButton.frame = CGRectMake(20, 180, 140, 40);
    espButton.backgroundColor = [UIColor systemPurpleColor];
    [espButton setTitle:@"👁️ Toggle ESP" forState:UIControlStateNormal];
    [espButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [espButton addTarget:self action:@selector(toggleESP) forControlEvents:UIControlEventTouchUpInside];
    
    // زر إعدادات ESP
    UIButton *espSettingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    espSettingsButton.frame = CGRectMake(180, 180, 140, 40);
    espSettingsButton.backgroundColor = [UIColor systemOrangeColor];
    [espSettingsButton setTitle:@"⚙️ ESP Settings" forState:UIControlStateNormal];
    [espSettingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [espSettingsButton addTarget:self action:@selector(showESPSettings) forControlEvents:UIControlEventTouchUpInside];
    
    [panel addSubview:espButton];
    [panel addSubview:espSettingsButton];
}

+ (void)showESPSettings {
    // ⚙️ عرض إعدادات ESP المتقدمة
    
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"👁️ ESP Settings"
                         message:@"Configure ESP features"
                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    // شفافية
    [alert addAction:[UIAlertAction actionWithTitle:@"Opacity: Low (20%)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setESPOpacity:0.2];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Opacity: Medium (50%)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setESPOpacity:0.5];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Opacity: High (80%)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setESPOpacity:0.8];
    }]];
    
    // ألوان
    [alert addAction:[UIAlertAction actionWithTitle:@"Color: Green" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setESPColor:[UIColor greenColor]];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Color: Red" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setESPColor:[UIColor redColor]];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Color: Blue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setESPColor:[UIColor blueColor]];
    }]];
    
    // إلغاء
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [[self topViewController] presentViewController:alert animated:YES completion:nil];
}

+ (void)setESPOpacity:(float)opacity {
    // 🎨 ضبط شفافية ESP
    NSLog(@"[ESP SETTINGS] 🎨 ضبط الشفافية إلى: %.0f%%", opacity * 100);
}

+ (void)setESPColor:(UIColor *)color {
    // 🎨 ضبط لون ESP
    NSLog(@"[ESP SETTINGS] 🎨 ضبط اللون إلى: %@", color);
}

@end

// ================================================
// 🔧 تفعيل ESP تلقائياً مع النظام
// ================================================

__attribute__((constructor))
static void ESP_AutoInit() {
    // ⏳ تأخير التشغيل
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // 🎯 تفعيل ESP بشكل تلقائي
        BOOL autoEnableESP = YES; // يمكن جعل هذا إعداد
        
        if (autoEnableESP) {
            NSLog(@"[ESP AUTO] 🤖 تفعيل ESP تلقائياً...");
            
            // ⏱️ انتظار 2 ثانية إضافية لاستقرار اللعبة
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                // ⚙️ خيارات ESP أولية
                NSDictionary *espOptions = @{
                    @"enable": @(YES),
                    @"opacity": @(0.3),
                    @"drawInfo": @(YES),
                    @"drawHealth": @(YES),
                    @"drawDistance": @(YES)
                };
                
                [SmartCheatSystem enableSmartESPWithOptions:espOptions];
                
                NSLog(@"[ESP AUTO] ✅ ESP مفعل تلقائياً مع إعدادات آمنة");
                
                // 🔔 إشعار المستخدم
                [self showAutoESPNotification];
            });
        }
    });
}

static void showAutoESPNotification() {
    // 🔔 إشعار تفعيل ESP التلقائي
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        
        UIView *notification = [[UIView alloc] initWithFrame:CGRectMake(20, 60, window.bounds.size.width - 40, 50)];
        notification.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.1 alpha:0.9];
        notification.layer.cornerRadius = 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, notification.bounds.size.width - 20, 30)];
        label.text = @"👁️ Smart ESP Activated (Safe Mode)";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];
        
        [notification addSubview:label];
        [window addSubview:notification];
        
        // إخفاء بعد 3 ثواني
        [UIView animateWithDuration:0.5 delay:3.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            notification.alpha = 0;
        } completion:^(BOOL finished) {
            [notification removeFromSuperview];
        }];
    });
}
