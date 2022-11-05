SYSROOT = $(THEOS)/sdks/iPhoneOS16.0.sdk/
ARCHS = arm64
TARGET = iphone:clang:latest:12.2

FINALPACKAGE = 1
DEBUG = 0
THEOS_LEAN_AND_MEAN = 1
FOR_RELEASE = 1
USING_JINX = 1

INSTALL_TARGET_PROCESSES = SpringBoard

LIBRARY_NAME = Satella
$(LIBRARY_NAME)_FILES = $(shell find Sources/$(LIBRARY_NAME) -name '*.swift') $(shell find Sources/$(LIBRARY_NAME)C -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
$(LIBRARY_NAME)_SWIFTFLAGS = -ISources/$(LIBRARY_NAME)C/include
$(LIBRARY_NAME)_CFLAGS = -fobjc-arc -ISources/$(LIBRARY_NAME)C/include
$(LIBRARY_NAME)_EXTRA_FRAMEWORKS = Cephei

BUNDLE_NAME = SatellaPrefs
$(BUNDLE_NAME)_FILES = $(shell find Sources/$(BUNDLE_NAME) -name '*.swift')
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc
$(BUNDLE_NAME)_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = AltList Cephei CepheiPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/library.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences"$(ECHO_END)
	$(ECHO_NOTHING)cp Resources/entry.plist "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist"$(ECHO_END)
