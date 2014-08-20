/*******************************************************************************
 * BundleBar.m
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import "BundleBar.h"

@implementation BundleBar

- (id) initWithDelegate:(id) theDelegate {
  self = [super init];

  if(self) {
    NSBundle    *mainBundle       = [NSBundle mainBundle];
    NSString    *key              = @"CFBundleName";
    NSString    *bundleName       = [mainBundle objectForInfoDictionaryKey:key];
    NSString    *aboutString      = [NSString stringWithFormat:@"About %@",
                                                              bundleName];
    NSString    *quitString       = [NSString stringWithFormat:@"Quit %@",
                                                               bundleName];
    NSString    *fileString       = @"File";
    NSString    *toolString       = @"Tools";
    NSString    *helpString       = @"Help";
    NSString    *openString       = @"Open";
    NSString    *closeString      = @"Close Tab";
    NSString    *saveString       = @"Save";
    NSString    *saveAsString     = @"Save As...";
    NSString    *checkString      = @"Check the ROM";
    NSString    *fixString        = @"Fix the ROM";
    NSString    *bundleHelpString = [NSString stringWithFormat:@"%@ Help",
                                                               bundleName];

    _mainMenu       = [[NSMenu alloc] init];
    _bundleMenu     = [[NSMenu alloc] initWithTitle:bundleName];
    _fileMenu       = [[NSMenu alloc] initWithTitle:fileString];
    _toolMenu       = [[NSMenu alloc] initWithTitle:toolString];
    _helpMenu       = [[NSMenu alloc] initWithTitle:helpString];
    _bundleItem     = [[NSMenuItem alloc] initWithTitle:bundleName
                                                 action:nil
                                          keyEquivalent:@""];
    _aboutItem      = [[NSMenuItem alloc] initWithTitle:aboutString
                                                 action:ABOUT_SELECTOR
                                          keyEquivalent:@""];
    _exitItem       = [[NSMenuItem alloc] initWithTitle:quitString
                                                 action:EXIT_SELECTOR
                                          keyEquivalent:@"q"];
    _fileItem       = [[NSMenuItem alloc] initWithTitle:fileString
                                                 action:nil
                                          keyEquivalent:@""];
    _openItem       = [[NSMenuItem alloc] initWithTitle:openString
                                                 action:OPEN_SELECTOR
                                          keyEquivalent:@"o"];
    _closeItem      = [[NSMenuItem alloc] initWithTitle:closeString
                                                 action:CLOSE_SELECTOR
                                          keyEquivalent:@"w"];
    _saveItem       = [[NSMenuItem alloc] initWithTitle:saveString
                                                 action:SAVE_SELECTOR
                                          keyEquivalent:@"s"];
    _saveAsItem     = [[NSMenuItem alloc] initWithTitle:saveAsString
                                                 action:SAVE_AS_SELECTOR
                                          keyEquivalent:@"S"];
    _toolItem       = [[NSMenuItem alloc] initWithTitle:toolString
                                                 action:nil
                                          keyEquivalent:@""];
    _checkItem      = [[NSMenuItem alloc] initWithTitle:checkString
                                                 action:CHECK_SELECTOR
                                          keyEquivalent:@""];
    _fixItem        = [[NSMenuItem alloc] initWithTitle:fixString
                                                 action:FIX_SELECTOR
                                          keyEquivalent:@""];
    _helpItem       = [[NSMenuItem alloc] initWithTitle:helpString
                                                 action:nil
                                          keyEquivalent:@""];
    _bundleHelpItem = [[NSMenuItem alloc] initWithTitle:bundleHelpString
                                                 action:HELP_SELECTOR
                                          keyEquivalent:@"?"];

    [_aboutItem       setTarget:theDelegate];
    [_exitItem        setTarget:theDelegate];
    [_openItem        setTarget:theDelegate];
    [_closeItem       setTarget:theDelegate];
    [_saveItem        setTarget:theDelegate];
    [_saveAsItem      setTarget:theDelegate];
    [_checkItem       setTarget:theDelegate];
    [_fixItem         setTarget:theDelegate];
    [_bundleHelpItem  setTarget:theDelegate];

    [_bundleMenu  addItem:_aboutItem];
    [_bundleMenu  addItem:[NSMenuItem separatorItem]];
    [_bundleMenu  addItem:_exitItem];
    [_fileMenu    addItem:_openItem];
    [_fileMenu    addItem:[NSMenuItem separatorItem]];
    [_fileMenu    addItem:_closeItem];
    [_fileMenu    addItem:_saveItem];
    [_fileMenu    addItem:_saveAsItem];
    [_toolMenu    addItem:_checkItem];
    [_toolMenu    addItem:[NSMenuItem separatorItem]];
    [_toolMenu    addItem:_fixItem];
    [_helpMenu    addItem:_bundleHelpItem];
    [_mainMenu    addItem:_bundleItem];
    [_mainMenu    addItem:_fileItem];
    [_mainMenu    addItem:_toolItem];
    [_mainMenu    addItem:_helpItem];
    [_mainMenu    setSubmenu:_bundleMenu forItem:_bundleItem];
    [_mainMenu    setSubmenu:_fileMenu forItem:_fileItem];
    [_mainMenu    setSubmenu:_toolMenu forItem:_toolItem];
    [_mainMenu    setSubmenu:_helpMenu forItem:_helpItem];

    [[NSApplication sharedApplication] setMainMenu:_mainMenu];
  }

  return self;
}

- (void) dealloc {
  [_mainMenu        release];
  [_bundleMenu      release];
  [_fileMenu        release];
  [_toolMenu        release];
  [_helpItem        release];
  [_bundleItem      release];
  [_aboutItem       release];
  [_exitItem        release];
  [_fileItem        release];
  [_openItem        release];
  [_saveItem        release];
  [_saveAsItem      release];
  [_closeItem       release];
  [_checkItem       release];
  [_fixItem         release];
  [_helpItem        release];
  [_bundleHelpItem  release];
  [super            dealloc];
}

- (void) setBundleBarVisible:(BOOL) flag {
  [NSMenu setMenuBarVisible:flag];
}

- (void) enableCloseItem {
  [_closeItem setAction:CLOSE_SELECTOR];
}

- (void) disableCloseItem {
  [_closeItem setAction:NOP_SELECTOR];
}

- (void) enableToolItems {
  [_checkItem setAction:CHECK_SELECTOR];
  [_fixItem   setAction:FIX_SELECTOR];
}

- (void) disableToolItems {
  [_checkItem setAction:NOP_SELECTOR];
  [_fixItem   setAction:NOP_SELECTOR];
}

- (void) enableSaveItems {
  [_saveItem    setAction:SAVE_SELECTOR];
  [_saveAsItem  setAction:SAVE_AS_SELECTOR];
}

- (void) disableSaveItems {
  [_saveItem    setAction:NOP_SELECTOR];
  [_saveAsItem  setAction:NOP_SELECTOR];
}

@end

