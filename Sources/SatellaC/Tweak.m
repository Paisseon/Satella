#import <Foundation/Foundation.h>

void jinxInit(void);

__attribute__((constructor)) static void init(void) {
    // Limiting initialisation goes here, i.e., "Don't init if..."
    if (![NSProcessInfo processInfo] || [[[NSBundle mainBundle] bundleIdentifier] hasPrefix:@"com.apple."] || ![[[NSProcessInfo processInfo] arguments][0] hasPrefix:@"/var/containers/Bundle/Application"]) return;
    
    // Start the Swift code-- removing this line will break your tweak
    jinxInit();
    
    // Other initialisation goes here, i.e., "After initialising, do..."
}
