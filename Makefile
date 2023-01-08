# Basic environment configuration

SYSROOT = $(THEOS)/sdks/iPhoneOS16.0.sdk/
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:12.2

# Theos optimisations

FINALPACKAGE = 1
DEBUG = 0
THEOS_LEAN_AND_MEAN = 1
USING_JINX = 1

# Processes die if they are killed

INSTALL_TARGET_PROCESSES = adorablehome

# SPM compatibility layer

XCDD_TOP = $(HOME)/Library/Developer/Xcode/DerivedData/
XCDD_MID = $(shell basename $(XCDD_TOP)/$(PWD)*)
XCDD_BOT = /SourcePackages/checkouts/Jinx/Sources/Jinx
JINX_LOC = $(XCDD_TOP)$(XCDD_MID)$(XCDD_BOT)

# Define included files, imported frameworks, etc.

LIBRARY_NAME = Satella
$(LIBRARY_NAME)_FILES = Sources/load.s $(shell find Sources/$(LIBRARY_NAME) -name '*.swift') $(shell find $(JINX_LOC) -name '*.swift')
$(LIBRARY_NAME)_LIBRARIES = mryipc

BUNDLE_NAME = SatellaPrefs
$(BUNDLE_NAME)_FILES = $(shell find Sources/$(BUNDLE_NAME) -name '*.swift')
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = AltList Cephei CepheiPrefs

# Theos makefiles to include

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/library.mk

# Add the preferences to PreferenceLoader

internal-stage::
	$(ECHO_NOTHING)mkdir -p "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences"$(ECHO_END)
	$(ECHO_NOTHING)cp Resources/entry.plist "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist"$(ECHO_END)
