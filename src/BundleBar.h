/*******************************************************************************
 * BundleBar.h
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

// actions
#define NOP_SELECTOR      @selector(nop)
#define ABOUT_SELECTOR    @selector(openAbout)
#define EXIT_SELECTOR     @selector(exit)
#define OPEN_SELECTOR     @selector(openCartridge)
#define CLOSE_SELECTOR    @selector(closeTab)
#define SAVE_SELECTOR     @selector(save)
#define SAVE_AS_SELECTOR  @selector(saveAs)
#define CHECK_SELECTOR    @selector(checkROM)
#define FIX_SELECTOR      @selector(fixROM)
#define HELP_SELECTOR     @selector(openHelp)

@interface BundleBar : NSObject {
  @private NSMenu     *_mainMenu;
  @private NSMenu     *_bundleMenu;
  @private NSMenu     *_fileMenu;
  @private NSMenu     *_toolMenu;
  @private NSMenu     *_helpMenu;
  @private NSMenuItem *_bundleItem;
  @private NSMenuItem *_aboutItem;
  @private NSMenuItem *_exitItem;
  @private NSMenuItem *_fileItem;
  @private NSMenuItem *_openItem;
  @private NSMenuItem *_closeItem;
  @private NSMenuItem *_saveItem;
  @private NSMenuItem *_saveAsItem;
  @private NSMenuItem *_toolItem;
  @private NSMenuItem *_checkItem;
  @private NSMenuItem *_fixItem;
  @private NSMenuItem *_helpItem;
  @private NSMenuItem *_bundleHelpItem;
}

- (id) initWithDelegate:(id) theDelegate;

- (void) setBundleBarVisible:(BOOL) flag;

- (void) enableCloseItem;

- (void) disableCloseItem;

- (void) enableToolItems;

- (void) disableToolItems;

- (void) enableSaveItems;

- (void) disableSaveItems;

@end

