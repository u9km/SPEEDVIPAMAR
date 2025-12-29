THEOS_DEVICE_IP = localhost
ARCHS = arm64
TARGET = iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignArchitecture
SovereignArchitecture_FILES = Tweak.xm
SovereignArchitecture_CFLAGS = -fobjc-arc
SovereignArchitecture_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
