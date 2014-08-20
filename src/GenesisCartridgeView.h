/*******************************************************************************
 * GenesisCartridgeView.h
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import <AppKit/AppKit.h>

#import "GenesisCartridgeController.h"

@interface GenesisCartridgeController (GenesisCartridgeView)

- (NSView *) viewForCartridgeIdentifier:(id) theIdentifier
                               inBounds:(CGRect) theBounds;

+ (NSView *) helpViewInBounds:(CGRect) theBounds;

@end

