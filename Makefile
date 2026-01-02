# اسم الأداة
TWEAK_NAME = SovereignUltimate

# الملفات المراد دمجها
SovereignUltimate_FILES = Sovereign_Ultimate.mm
SovereignUltimate_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

# المكتبات المطلوبة
SovereignUltimate_FRAMEWORKS = UIKit Foundation QuartzCore

# إعدادات المعالج (ARM64 ضروري لببجي)
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 ShadowTrackerExtra" # إعادة تشغيل اللعبة تلقائياً
