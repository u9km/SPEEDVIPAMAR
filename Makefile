TARGET = iphone:clang:latest:14.0
ARCHS = arm64
include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = CoreAudioSupport
CoreAudioSupport_FILES = CoreAudioSupport.m
CoreAudioSupport_INSTALL_PATH = /Library/Frameworks
CoreAudioSupport_CFLAGS = -fobjc-arc
CoreAudioSupport_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/framework.mk
