#import <Orion/Orion.h>

__attribute__((constructor)) static void init() {
	if (![NSProcessInfo processInfo] || [[[NSBundle mainBundle] bundleIdentifier] hasPrefix:@"com.apple."] || ![[[NSProcessInfo processInfo] arguments][0] containsString:@"/Application/"]) return;
	
	orion_init();
}