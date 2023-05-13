# Theos optimisations

ARCHS = arm64 arm64e

ifeq ($(ROOTLESS),1)
	TARGET = iphone:clang:latest:15.0
endif

# Define included files, imported frameworks, etc.

BUNDLE_NAME = SatellaPrefs
$(BUNDLE_NAME)_FILES = $(shell find Sources/$(BUNDLE_NAME) -name '*.swift')
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = AltList

# Theos makefiles to include

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/bundle.mk

# Rootless support? with a question mark

ifeq ($(ROOTLESS),1)
internal-stage::
	@$(PRINT_FORMAT_MAKING) "Patching load commands for $(BUNDLE_NAME)"
	
	$(ECHO_NOTHING)for fw in $($(BUNDLE_NAME)_EXTRA_FRAMEWORKS); do \
		install_name_tool -change /Library/Frameworks/$$fw.framework/$$fw \
		/var/jb/Library/Frameworks/$$fw.framework/$$fw \
		"$(THEOS_STAGING_DIR)/Library/PreferenceBundles/$(BUNDLE_NAME).bundle/$(BUNDLE_NAME)" > /dev/null 2>&1 ; \
	done$(ECHO_END)
	$(ECHO_NOTHING)for lib in $($(BUNDLE_NAME)_LIBRARIES); do \
		install_name_tool -change /usr/lib/lib$$lib.dylib \
		/var/jb/usr/lib/lib$$lib.dylib \
		"$(THEOS_STAGING_DIR)/Library/PreferenceBundles/$(BUNDLE_NAME).bundle/$(BUNDLE_NAME)" > /dev/null 2>&1 ; \
	done$(ECHO_END)
	
	@$(PRINT_FORMAT_MAKING) "Re-signing $(BUNDLE_NAME)"
	$(ECHO_NOTHING)ldid -S "$(THEOS_STAGING_DIR)/Library/PreferenceBundles/$(BUNDLE_NAME).bundle/$(BUNDLE_NAME)"$(ECHO_END)
	
	@$(PRINT_FORMAT_MAKING) "Copying preferences to PreferenceLoader"
	$(ECHO_NOTHING)mkdir -p "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences"$(ECHO_END)
	$(ECHO_NOTHING)cp Resources/entry.plist "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist"$(ECHO_END)
else
internal-stage::
	@$(PRINT_FORMAT_MAKING) "Copying preferences to PreferenceLoader"
	$(ECHO_NOTHING)mkdir -p "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences"$(ECHO_END)
	$(ECHO_NOTHING)cp Resources/entry.plist "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist"$(ECHO_END)
endif
