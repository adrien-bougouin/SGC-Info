/*******************************************************************************
 * AboutBundleView.m
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import "AboutBundleView.h"

@implementation NSView (AboutBundleView)

+ (NSView *) aboutBundleViewWithFrame:(CGRect) theFrame {
  NSBundle    *mainBundle = [NSBundle mainBundle];
  NSString    *nameKey    = @"CFBundleName";
  NSString    *versionKey = @"CFBundleVersion";
  NSString    *iconKey    = @"CFBundleIconFile";
  NSString    *name       = [mainBundle objectForInfoDictionaryKey:nameKey];
  NSString    *version    = [mainBundle objectForInfoDictionaryKey:versionKey];
  NSString    *icon       = [mainBundle objectForInfoDictionaryKey:iconKey];
  NSString    *iconFile   = [mainBundle pathForResource:icon ofType:@"icns"];
  NSView      *aboutView  = [[NSView alloc] initWithFrame:theFrame];
  NSImage     *image      = [[NSImage alloc] initWithContentsOfFile:iconFile];
  NSInteger   iconSize    = CGRectGetMidY(theFrame) / 2;
  CGRect      rect        = CGRectMake(CGRectGetMidX(theFrame)
                                       - (iconSize / 2),
                                       ((CGRectGetMaxY(theFrame) / 4) * 3)
                                       - (iconSize / 4),
                                       iconSize,
                                       iconSize);
  NSImageView *iconView   = [[NSImageView alloc] initWithFrame:rect];
              rect        = CGRectMake(0,
                                       0,
                                       CGRectGetWidth(theFrame),
                                       CGRectGetHeight(theFrame)
                                       - (CGRectGetHeight(theFrame)
                                          - CGRectGetMinY(rect)));
  NSText      *aboutText  =[[NSText alloc] initWithFrame:rect];

  [iconView   setAutoresizingMask:NSViewMinXMargin
                                  | NSViewMaxXMargin
                                  | NSViewMinYMargin
                                  | NSViewNotSizable];
  [aboutText  setVerticallyResizable:NO];
  [aboutText  setString:[NSString stringWithFormat:@"%@\n%@ %@ %@\n%@\n<%@@%@>",
                                                   name,
                                                   @"Version",
                                                   version,
                                                   @"(GNU GPL v3)",
                                                   @"\nAdrien Bougouin",
                                                   @"adrien.bougouin",
                                                   @"gmail.com"]];
  [aboutText  setAlignment:NSCenterTextAlignment];
  [aboutText  setBackgroundColor:[NSColor clearColor]];
  [aboutText  setFont:[NSFont boldSystemFontOfSize:14]
                range:NSMakeRange(0, [name length])];
  [aboutText  setEditable:NO];
  [aboutText  setAutoresizingMask:NSViewMinYMargin
                                  | NSViewWidthSizable];

  [iconView   setImage:image];
  [aboutView  addSubview:iconView];
  [aboutView  addSubview:aboutText];

  [image      release];
  [iconView   release];
  [aboutText  release];
  [aboutView  autorelease];

 return aboutView;
}

@end

