TARGET := iphone:clang:16.5:16.0
ARCHS := arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = PilotAI

PilotAI_FILES = $(shell find PilotAI -name "*.swift")
PilotAI_FRAMEWORKS = UIKit SwiftUI SwiftData Foundation WebKit CoreGraphics
PilotAI_CODESIGN_FLAGS = -s -
PilotAI_SWIFTFLAGS = -I PilotAI -swift-version 5

include $(THEOS_MAKE_PATH)/application.mk
