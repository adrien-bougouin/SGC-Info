/*******************************************************************************
 * GenesisCartridgeController.h
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import <Foundation/Foundation.h>

// genesis cartridge mapping
#define CONSOLE_NAME_BYTES        NSMakeRange(0x100, 0x110 - 0x100)
#define COPYRIGHT_BYTES           NSMakeRange(0x110, 0x120 - 0x110)
#define DOMESTIC_NAME_BYTES       NSMakeRange(0x120, 0x150 - 0x120)
#define OVERSEAS_NAME_BYTES       NSMakeRange(0x150, 0x180 - 0x150)
#define PRODUCT_CODE_BYTES        NSMakeRange(0x180, 0x182 - 0x180)
#define PRODUCT_TYPE_BYTES        NSMakeRange(0x183, 0x18e - 0x183)
#define CHECK_SUM_BYTES           NSMakeRange(0x18e, 0x190 - 0x18e)
#define IO_SUPPORT_BYTES          NSMakeRange(0x190, 0x1a0 - 0x190)
#define ROM_START_BYTES           NSMakeRange(0x1a0, 0x1a4 - 0x1a0)
#define ROM_END_BYTES             NSMakeRange(0x1a4, 0x1a8 - 0x1a4)
#define RAM_START_BYTES           NSMakeRange(0x1a8, 0x1ac - 0x1a8)
#define RAM_END_BYTES             NSMakeRange(0x1ac, 0x1b0 - 0x1ac)
#define EXTERNAL_RAM_TYPE_BYTES   NSMakeRange(0x1b0, 0x1b4 - 0x1b0)
#define EXTERNAL_RAM_START_BYTES  NSMakeRange(0x1b4, 0x1b8 - 0x1b4)
#define EXTERNAL_RAM_END_BYTES    NSMakeRange(0x1b8, 0x1bc - 0x1b8)
#define MODEM_SUPPORT_BYTES       NSMakeRange(0x1bc, 0x1c8 - 0x1bc)
#define MEMO_BYTES                NSMakeRange(0x1c8, 0x1f0 - 0x1c8)
#define COUNTRY_BYTES             NSMakeRange(0x1f0, 0x200 - 0x1f0)

#define STRING_ENCODING           NSShiftJISStringEncoding
#define BYTE_ENCODING             NSASCIIStringEncoding

typedef enum {
  GENESIS_CARTRIDGE_ADDED,
  GENESIS_CARTRIDGE_ALREADY_ADDED,
  NOT_A_GENESIS_CARTRIDGE
} GCCAddingResponse;

@interface GenesisCartridgeController : NSObject {
  @private NSMutableDictionary *_genesisCartridges;
}

- (id) initWithNumberOfCartridgeToContains:(NSUInteger) aNumber;

- (GCCAddingResponse) addCartridgeFromFile:(NSString *)  filename
                            withIdentifier:(id)          theIdentifier;

- (void) removeCartridgeWithIdentifier:(id) theIdentifier;

- (NSData *) cartridgeDataForIdentifier:(id) theIdentifier;

- (NSString *) consoleNameForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) copyrightForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) domesticNameForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) overseasNameForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) productCodeForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) productTypeForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) checkSumForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) ioSupportForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) romStartForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) romEndForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) ramStartForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) ramEndForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) modemSupportForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) memoForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) countryForCartridgeIdentifier:(id) theIdentifier;

- (BOOL) isCorruptedCartridgeOfIdentifier:(id) theIdentifier;

- (BOOL) fixCartridgeOfIdentifier:(id) Identifier;

+ (BOOL) isGenesisCartridgeFile:(NSString *) filename;

@end

