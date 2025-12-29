TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = GCloudCore

# --- الإصلاح هنا: أضفنا fishhook.c ليتم تجميعه ---
GCloudCore_FILES = Tweak.x fishhook.c

GCloudCore_INSTALL_PATH = /Library/Frameworks
GCloudCore_CFLAGS = -fobjc-arc
GCloudCore_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/framework.mk

# أمر الدمج التلقائي
after-stage::
	@mkdir -p $(THEOS_STAGING_DIR)/Library/Frameworks/GCloudCore.framework/Resources
	@cp CoreData.dylib $(THEOS_STAGING_DIR)/Library/Frameworks/GCloudCore.framework/Resources/CoreData.dylib
