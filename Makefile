TARGET := iphone:clang:latest:12.0
ARCHS = arm64 arm64e
GO_EASY_ON_ME = 1
CODE_SIGNING_REQUIRED = NO

include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = GCloudCore

GCloudCore_FILES = Tweak.x fishhook.c
GCloudCore_CFLAGS = -fobjc-arc -O2 -Wno-deprecated-declarations
GCloudCore_LDFLAGS = -Wl,-undefined,dynamic_lookup
GCloudCore_INSTALL_PATH = /Library/Frameworks
GCloudCore_FRAMEWORKS = UIKit ReplayKit Foundation Security

include $(THEOS_MAKE_PATH)/framework.mk
