/*******************************************************************************
 * GenesisCartridgeView.m
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import "GenesisCartridgeView.h"

@implementation GenesisCartridgeController (GenesisCartridgeView)

- (NSView *) viewForCartridgeIdentifier:(id) theIdentifier
                                 inBounds:(CGRect) theBounds {
  CGRect      rect              = theBounds;
  NSView      *mainView         = [[NSView alloc] initWithFrame:rect];
              rect              = CGRectMake(0,
                                             CGRectGetHeight(theBounds)
                                             - (CGRectGetMidY(theBounds)),
                                             CGRectGetMidX(theBounds),
                                             CGRectGetMidY(theBounds));
  NSBox       *generalDetails   = [[NSBox alloc] initWithFrame:rect];
              rect              = CGRectMake(0,
                                             0,
                                             CGRectGetMidX(theBounds),
                                             CGRectGetMidY(theBounds));
  NSBox       *romDetails       = [[NSBox alloc] initWithFrame:rect];
              rect              = CGRectMake(CGRectGetMidX(theBounds),
                                             CGRectGetHeight(theBounds)
                                             - (CGRectGetMidY(theBounds)),
                                             CGRectGetMidX(theBounds),
                                             CGRectGetMidY(theBounds));
  NSBox       *productDetails   = [[NSBox alloc] initWithFrame:rect];
              rect              = CGRectMake(CGRectGetMidX(theBounds),
                                             0,
                                             CGRectGetMidX(theBounds),
                                             CGRectGetMidY(theBounds));
  NSBox       *memoDetails      = [[NSBox alloc] initWithFrame:rect];
              rect              = [generalDetails bounds];
              rect              = CGRectMake(0,
                                             0,
                                             CGRectGetWidth(rect),
                                             CGRectGetHeight(rect) - 24);
  NSText      *generalText      = [[NSText alloc] initWithFrame:rect];
  NSString    *generalString    = nil;
  NSString    *domesticName     = nil;
  NSString    *overseasName     = nil;
  NSString    *copyright        = nil;
              rect              = [productDetails bounds];
              rect              = CGRectMake(0,
                                             0,
                                             CGRectGetWidth(rect),
                                             CGRectGetHeight(rect) - 24);
  NSText      *productText      = [[NSText alloc] initWithFrame:rect];
  NSString    *productString    = nil;
  NSString    *country          = nil;
  NSString    *productCode      = nil;
  NSString    *productType      = nil;
  NSString    *ioSupport        = nil;
  NSString    *modemSupport     = nil;
              rect              = [romDetails bounds];
              rect              = CGRectMake(0,
                                             0,
                                             CGRectGetWidth(rect),
                                             CGRectGetHeight(rect) - 24);
  NSText      *romText          = [[NSText alloc] initWithFrame:rect];
  NSString    *romString        = nil;
  NSString    *checkSum         = nil;
  NSString    *romStart         = nil;
  NSString    *romEnd           = nil;
  NSString    *ramStart         = nil;
  NSString    *ramEnd           = nil;
              rect              = [memoDetails bounds];
              rect              = CGRectMake(0,
                                             0,
                                             CGRectGetWidth(rect),
                                             CGRectGetHeight(rect) - 24);
  NSText      *memoText         = [[NSText alloc] initWithFrame:rect];
  NSString    *memoString       = nil;
  NSString    *memo             = nil;

  domesticName  = [self domesticNameForCartridgeIdentifier:theIdentifier];
  overseasName  = [self overseasNameForCartridgeIdentifier:theIdentifier];
  copyright     = [self copyrightForCartridgeIdentifier:theIdentifier];
  generalString = [NSString stringWithFormat:@"\n%@ %@\n\n%@ %@\n\n%@",
                                             domesticName,
                                             @"(Domestic)",
                                             overseasName,
                                             @"(Overseas)",
                                             copyright];
  country       = [self countryForCartridgeIdentifier:theIdentifier];
  productCode   = [self productCodeForCartridgeIdentifier:theIdentifier];
  productType   = [self productTypeForCartridgeIdentifier:theIdentifier];
  ioSupport     = [self ioSupportForCartridgeIdentifier:theIdentifier];
  modemSupport  = [self modemSupportForCartridgeIdentifier:theIdentifier];
  productString = [NSString stringWithFormat:@"%@%@\n%@%@ %@\n%@%@\n%@%@",
                                             @"\nRelease country:\t",
                                             country,
                                             @"\nCode:\t\t\t",
                                             productCode,
                                             productType,
                                             @"\nIO support:\t\t",
                                             ioSupport,
                                             @"\nModem support:\t",
                                             modemSupport];
  checkSum      = [self checkSumForCartridgeIdentifier:theIdentifier];
  romStart      = [self romStartForCartridgeIdentifier:theIdentifier];
  romEnd        = [self romEndForCartridgeIdentifier:theIdentifier];
  ramStart      = [self ramStartForCartridgeIdentifier:theIdentifier];
  ramEnd        = [self ramEndForCartridgeIdentifier:theIdentifier];
  romString     = [NSString stringWithFormat:@"%@%@\n%@%@\n%@%@\n%@%@\n%@%@",
                                             @"\nCheck sum:\t",
                                             checkSum,
                                             @"\nROM start:\t",
                                             romStart,
                                             @"\nROM end:\t\t",
                                             romEnd,
                                             @"\nRAM start:\t",
                                             ramStart,
                                             @"\nRAM end:\t\t",
                                             ramEnd];
  memo          = [self memoForCartridgeIdentifier:theIdentifier];
  memoString    = [NSString stringWithFormat:@"\n%@",
                                             memo];

  [generalDetails setTitle:@"General details"];
  [productDetails setTitle:@"Product details"];
  [romDetails     setTitle:@"ROM details"];
  [memoDetails    setTitle:@"Memo"];
  [generalText    setString:generalString];
  [generalText    setVerticallyResizable:NO];
  [generalText    setBackgroundColor:[NSColor clearColor]];
  [generalText    setEditable:NO];
  [productText    setString:productString];
  [productText    setVerticallyResizable:NO];
  [productText    setBackgroundColor:[NSColor clearColor]];
  [productText    setEditable:NO];
  [romText        setString:romString];
  [romText        setVerticallyResizable:NO];
  [romText        setBackgroundColor:[NSColor clearColor]];
  [romText        setEditable:NO];
  [memoText       setString:memoString];
  [memoText       setVerticallyResizable:NO];
  [memoText       setBackgroundColor:[NSColor clearColor]];
  [memoText       setEditable:NO];

  [generalDetails setAutoresizingMask:NSViewMaxXMargin
                                      | NSViewMinYMargin
                                      | NSViewWidthSizable
                                      | NSViewHeightSizable];
  [productDetails setAutoresizingMask:NSViewMinXMargin
                                      | NSViewMinYMargin
                                      | NSViewWidthSizable
                                      | NSViewHeightSizable];
  [romDetails     setAutoresizingMask:NSViewMaxXMargin
                                      | NSViewMaxYMargin
                                      | NSViewWidthSizable
                                      | NSViewHeightSizable];
  [memoDetails    setAutoresizingMask:NSViewMinXMargin
                                      | NSViewMaxYMargin
                                      | NSViewWidthSizable
                                      | NSViewHeightSizable];
  [generalText    setAutoresizingMask:NSViewMinXMargin
                                      | NSViewMaxXMargin
                                      | NSViewMinYMargin
                                      | NSViewMaxYMargin
                                      | NSViewWidthSizable
                                      | NSViewHeightSizable];
  [productText    setAutoresizingMask:NSViewMinXMargin
                                      | NSViewMaxXMargin
                                      | NSViewMinYMargin
                                      | NSViewMaxYMargin
                                      | NSViewWidthSizable
                                      | NSViewHeightSizable];
  [romText        setAutoresizingMask:NSViewMinXMargin
                                      | NSViewMaxXMargin
                                      | NSViewMinYMargin
                                      | NSViewMaxYMargin
                                      | NSViewWidthSizable
                                      | NSViewHeightSizable];
  [memoText       setAutoresizingMask:NSViewMinXMargin
                                      | NSViewMaxXMargin
                                      | NSViewMinYMargin
                                      | NSViewMaxYMargin
                                      | NSViewWidthSizable
                                      | NSViewHeightSizable];

  [mainView       addSubview:generalDetails];
  [mainView       addSubview:romDetails];
  [mainView       addSubview:productDetails];
  [mainView       addSubview:memoDetails];
  [generalDetails addSubview:generalText];
  [productDetails addSubview:productText];
  [romDetails     addSubview:romText];
  [memoDetails    addSubview:memoText];
  
  [generalDetails release];
  [romDetails     release];
  [productDetails release];
  [memoDetails    release];
  [generalText    release];
  [productText    release];
  [romText        release];
  [memoText       release];
  [mainView       autorelease];

  return mainView;
}

+ (NSView *) helpViewInBounds:(CGRect) theBounds {
  NSBundle          *mainBundle = [NSBundle mainBundle];
  CGRect            rect        = theBounds;
  NSView            *help       = [[NSView alloc] initWithFrame:rect];
  NSScrollView      *scrollView = [[NSScrollView alloc] initWithFrame:rect];
  NSString          *filepath   = [mainBundle pathForResource:@"help"
                                                       ofType:@""];
  NSStringEncoding  encoding    = NSUTF8StringEncoding;
  NSString          *helpString = [NSString stringWithContentsOfFile:filepath
                                                            encoding:encoding
                                                               error:NULL];
                    rect        = CGRectMake(0,
                                             0,
                                             CGRectGetMidX(rect),
                                             0);
  NSText            *helpText   = [[NSText alloc] initWithFrame:rect];

  [scrollView setHasVerticalScroller:YES];
  [scrollView setHasHorizontalScroller:YES];
  [scrollView setAutohidesScrollers:YES];
  [scrollView setBackgroundColor:[NSColor clearColor]];
  [scrollView setDrawsBackground:NO];
  [scrollView setAutoresizingMask:NSViewMinXMargin
                                  | NSViewMaxXMargin
                                  | NSViewMinYMargin
                                  | NSViewMaxYMargin
                                  | NSViewWidthSizable
                                  | NSViewHeightSizable];
  [helpText   setString:helpString];
  [helpText   setBackgroundColor:[NSColor clearColor]];
  [helpText   setEditable:NO];

  [scrollView setDocumentView:helpText];
  [help       addSubview:scrollView];

  [helpText release];
  [help     autorelease];

  return help;
}

@end

