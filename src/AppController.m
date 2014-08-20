/*******************************************************************************
 * AppController.m
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import "AppController.h"
#import "AboutBundleView.h"
#import "GenesisCartridgeView.h"

@implementation AppController

- (id) init {
  self = [super init];

  [NSFont setUserFont:[NSFont userFixedPitchFontOfSize:10]];

  if(self) {
    CGRect      contentRect = CGRectMake(100, 100, WINDOW_WIDTH, WINDOW_HEIGHT);
    NSUInteger  styleMask   = NSMiniaturizableWindowMask
                              | NSResizableWindowMask
                              | NSClosableWindowMask
                              | NSTitledWindowMask;
    NSUInteger  backingMask = NSBackingStoreBuffered;

    _mainWindow         = [[NSWindow alloc] initWithContentRect:contentRect
                                                      styleMask:styleMask
                                                        backing:backingMask
                                                          defer:NO];
    _bundleBar          = [[BundleBar alloc] initWithDelegate:self];
    _cartridgeInfos     = [[NSTabView alloc] initWithFrame:contentRect];
    _aboutTab           = nil;
    _helpTab            = nil;
    _genesisCartridges  = [[GenesisCartridgeController alloc] init];

    [_mainWindow      setTitle:@"Sega Genesis Cartridge Informations"];
    [_mainWindow      setMinSize:CGSizeMake(WINDOW_MIN_WIDTH,
                                            WINDOW_MIN_HEIGHT)];
    [_bundleBar       disableCloseItem];
    [_bundleBar       disableToolItems];
    [_bundleBar       disableSaveItems];
    [_cartridgeInfos  setAllowsTruncatedLabels:YES];

    [_mainWindow setContentView:_cartridgeInfos];
  }

  return self;
}

- (void) applicationDidFinishLaunching:(NSNotification *) aNotification {
  [_mainWindow  orderFront:self];
  [_bundleBar setBundleBarVisible:YES];
}

- (void) applicationWillTerminate:(NSNotification *) aNotification {
  [_mainWindow        release];
  [_bundleBar         release];
  [_cartridgeInfos    release];
  [_aboutTab          release];
  [_helpTab           release];
  [_genesisCartridges release];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *) sender {
  return YES;
}

- (BOOL) application:(NSApplication *) theApplication
            openFile:(NSString *) filename {
  switch([_genesisCartridges addCartridgeFromFile:filename
                                   withIdentifier:filename]) {
    case GENESIS_CARTRIDGE_ADDED :
      ;
      NSTabViewItem     *newTab;
      CGRect            tabBounds = [_cartridgeInfos bounds];

      newTab    = [[NSTabViewItem alloc] initWithIdentifier:filename];

      [newTab setLabel:[filename lastPathComponent]];
      [newTab setView:[_genesisCartridges viewForCartridgeIdentifier:filename
                                                            inBounds:tabBounds]];
      [_cartridgeInfos  addTabViewItem:newTab];
      [_cartridgeInfos  selectTabViewItem:newTab];
      [_bundleBar       enableCloseItem];
      [_bundleBar       enableToolItems];
      [_bundleBar       enableSaveItems];

      [newTab     release];
    break;

    case GENESIS_CARTRIDGE_ALREADY_ADDED:
      ;
      NSInteger tabIndex;
      
      tabIndex = [_cartridgeInfos indexOfTabViewItemWithIdentifier:filename];

      [_cartridgeInfos  selectTabViewItemAtIndex:tabIndex];
      [_bundleBar       enableCloseItem];
    break;

    default:
      [[NSAlert alertWithMessageText:@"Wrong file"
                       defaultButton:nil
                     alternateButton:nil
                         otherButton:nil
           informativeTextWithFormat:@"%@ doesn't contains a Genesis cartridge.",
                                     filename] runModal];
    break;
  }

  return YES;
}

- (void) saveSelectedCartridgeInFile:(NSString *) filename {
  NSTabViewItem *item       = [_cartridgeInfos selectedTabViewItem];
  NSString      *identifier = [item identifier];
  NSData        *cartridge;

  cartridge = [_genesisCartridges cartridgeDataForIdentifier:identifier];

  if(filename == nil) {
    [cartridge  writeToFile:identifier atomically:YES];
    [item       setLabel:[identifier lastPathComponent]];
  } else {
    [cartridge          writeToFile:filename atomically:YES];
    [_genesisCartridges removeCartridgeWithIdentifier:identifier];
    [_cartridgeInfos    removeTabViewItem:item];
    [self               application:[NSApplication sharedApplication]
                           openFile:filename];
  }
}

- (BOOL) panel:(id) sender
   validateURL:(NSURL *) url
         error:(NSError **) outError {
  if([[sender title] isEqual:OPEN_TITLE]) {
    [self application:[NSApplication sharedApplication] openFile:[url path]];
  } else if([[sender title] isEqual:SAVE_TITLE]){
    NSString *filename = [url path];

    [self saveSelectedCartridgeInFile:filename];
  }

  return YES;
}

- (void) openAbout {
  if(!_aboutTab) {
    CGRect tabBounds = [_cartridgeInfos bounds];

    _aboutTab = [[NSTabViewItem alloc] init];

    [_aboutTab setLabel:@"About"];
    [_aboutTab setView:[NSView aboutBundleViewWithFrame:tabBounds]];
  }

  if(![[_cartridgeInfos tabViewItems] containsObject:_aboutTab]) {
    [_cartridgeInfos  addTabViewItem:_aboutTab];
  }

  [_cartridgeInfos selectTabViewItem:_aboutTab];
  [_bundleBar      enableCloseItem];
  [_bundleBar      disableToolItems];
  [_bundleBar      disableSaveItems];
}

- (void) openCartridge {
  NSOpenPanel *openPanel      = [NSOpenPanel openPanel];

  [openPanel setTitle:OPEN_TITLE];
  [openPanel setDelegate:self];
  [openPanel setAllowsMultipleSelection:YES];

  [openPanel runModal];
}

- (void) closeTab {
  id identifier = [[_cartridgeInfos selectedTabViewItem] identifier];

  if(identifier) {
    [_genesisCartridges removeCartridgeWithIdentifier:identifier];
  }
  [_cartridgeInfos    removeTabViewItem:[_cartridgeInfos selectedTabViewItem]];

  if([_cartridgeInfos numberOfTabViewItems] == 0) {
    [_bundleBar disableCloseItem];
    [_bundleBar disableToolItems];
    [_bundleBar disableSaveItems];
  } else {
    if(![[_cartridgeInfos selectedTabViewItem] identifier]) {
      [_bundleBar disableToolItems];
      [_bundleBar disableSaveItems];
    } else {
      [_bundleBar enableToolItems];
      [_bundleBar enableSaveItems];
    }
  }
}

- (void) save {
  [self saveSelectedCartridgeInFile:nil];
}

- (void) saveAs {
  NSSavePanel *savePanel    = [NSSavePanel savePanel];
  NSArray     *allowedFiles = [NSArray arrayWithObjects:@"bin", @"gen", nil];

  [savePanel setTitle:SAVE_TITLE];
  [savePanel setDelegate:self];
  [savePanel setAllowedFileTypes:allowedFiles];

  [savePanel runModal];
}

- (void) checkROM {
  NSString *identifier = [[_cartridgeInfos selectedTabViewItem] identifier];

  if(![_genesisCartridges isCorruptedCartridgeOfIdentifier:identifier]) {
    [[NSAlert alertWithMessageText:@"Good ROM"
                     defaultButton:nil
                   alternateButton:nil
                       otherButton:nil
         informativeTextWithFormat:@"%@ has the same check sum as %@",
                                   [identifier lastPathComponent],
                                   @"indicated in the ROM details."] runModal];
  } else {
    [[NSAlert alertWithMessageText:@"Bad ROM"
                     defaultButton:nil
                   alternateButton:nil
                       otherButton:nil
         informativeTextWithFormat:@"%@ hasn't the same check sum as %@",
                                   [identifier lastPathComponent],
                                   @"indicated in the ROM details."] runModal];
  }
}

- (void) fixROM {
  NSTabViewItem *item       = [_cartridgeInfos selectedTabViewItem];
  NSString      *identifier = [item identifier];

  if([_genesisCartridges fixCartridgeOfIdentifier:identifier]) {
    CGRect  bounds      = [_cartridgeInfos bounds];

    [item setLabel:[NSString stringWithFormat:@"*%@",
                                              [item label]]];
    [item setView:[_genesisCartridges viewForCartridgeIdentifier:identifier
                                                        inBounds:bounds]];
  }
}

- (void) openHelp {
  if(!_helpTab) {
    CGRect tabBounds = [_cartridgeInfos bounds];

    _helpTab = [[NSTabViewItem alloc] init];

    [_helpTab setLabel:@"Help"];
    [_helpTab setView:[GenesisCartridgeController helpViewInBounds:tabBounds]];
  }

  if(![[_cartridgeInfos tabViewItems] containsObject:_helpTab]) {
    [_cartridgeInfos  addTabViewItem:_helpTab];
  }

  [_cartridgeInfos selectTabViewItem:_helpTab];
  [_bundleBar      enableCloseItem];
  [_bundleBar      disableToolItems];
  [_bundleBar      disableSaveItems];
}

- (void) exit {
  [[NSApplication sharedApplication] terminate:self];
}

@end

