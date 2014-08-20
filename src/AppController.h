/*******************************************************************************
 * AppController.h
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "BundleBar.h"
#import "GenesisCartridgeController.h"

#define WINDOW_WIDTH      800
#define WINDOW_HEIGHT     600
#define WINDOW_MIN_WIDTH  640
#define WINDOW_MIN_HEIGHT 480

#define OPEN_TITLE  @"Open"
#define SAVE_TITLE  @"Save As..."

@interface AppController : NSObject <NSApplicationDelegate,
                                     NSOpenSavePanelDelegate> {
  @private NSWindow                   *_mainWindow;
  @private BundleBar                  *_bundleBar;
  @private NSTabView                  *_cartridgeInfos;
  @private NSTabViewItem              *_aboutTab;
  @private NSTabViewItem              *_helpTab;
  @private GenesisCartridgeController *_genesisCartridges;
}

- (void) saveSelectedCartridgeInFile:(NSString *) filename;

- (void) openAbout;

- (void) openCartridge;

- (void) closeTab;

- (void) save;

- (void) saveAs;

- (void) checkROM;

- (void) fixROM;

- (void) openHelp;

- (void) exit;

@end

