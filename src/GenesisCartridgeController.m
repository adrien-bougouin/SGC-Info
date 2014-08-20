/*******************************************************************************
 * GenesisCartridgeController.m
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import "GenesisCartridgeController.h"

@interface GenesisCartridgeController (PrivateMethods)

  - (unsigned short) calculateCheckSumForCartridgeIdentifier:(id) theIdentifier;

- (NSString *) stringInRange:(NSRange)  theRange
               forIdentifier:(id)       theIdentifier;

- (unichar *) bytesInRange:(NSRange)   theRange
                    length:(NSInteger) theLength
             forIdentifier:(id)        theIdentifier;

@end

@implementation GenesisCartridgeController

- (id) init {
  return [self initWithNumberOfCartridgeToContains:10];
}

- (id) initWithNumberOfCartridgeToContains:(NSUInteger) aNumber {
  self = [super init];

  if(self) {
    _genesisCartridges = [[NSMutableDictionary alloc] initWithCapacity:aNumber];
  }

  return self;
}

- (void) dealloc {
  [_genesisCartridges release];
  [super              dealloc];
}

- (GCCAddingResponse) addCartridgeFromFile:(NSString *)  filename
                            withIdentifier:(id)          theIdentifier {
  GCCAddingResponse response = GENESIS_CARTRIDGE_ADDED;

  if([GenesisCartridgeController isGenesisCartridgeFile:filename]) {
    if(![[_genesisCartridges allKeys] containsObject:theIdentifier]) {
      NSData *genesisCartridge = [NSData dataWithContentsOfFile:filename];

      [_genesisCartridges setObject:genesisCartridge forKey:theIdentifier];
    } else {
      response = GENESIS_CARTRIDGE_ALREADY_ADDED;
    }
  } else {
    response = NOT_A_GENESIS_CARTRIDGE;
  }

  return response;
}

- (void) removeCartridgeWithIdentifier:(id) theIdentifier {
  [_genesisCartridges removeObjectForKey:theIdentifier];
}

- (NSData *) cartridgeDataForIdentifier:(id) theIdentifier {
  return [_genesisCartridges objectForKey:theIdentifier];
}

- (NSString *) consoleNameForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:CONSOLE_NAME_BYTES forIdentifier:theIdentifier];
}

- (NSString *) copyrightForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:COPYRIGHT_BYTES forIdentifier:theIdentifier];
}

- (NSString *) domesticNameForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:DOMESTIC_NAME_BYTES forIdentifier:theIdentifier];
}

- (NSString *) overseasNameForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:OVERSEAS_NAME_BYTES forIdentifier:theIdentifier];
}

- (NSString *) productCodeForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:PRODUCT_CODE_BYTES forIdentifier:theIdentifier];
}

- (NSString *) productTypeForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:PRODUCT_TYPE_BYTES forIdentifier:theIdentifier];
}

- (NSString *) checkSumForCartridgeIdentifier:(id) theIdentifier {
  unichar   *buffer     = [self bytesInRange:CHECK_SUM_BYTES
                                      length:2
                               forIdentifier:theIdentifier];
  NSString  *stringVal  = [NSString stringWithFormat:@"0x%02X%02X",
                                                     buffer[0],
                                                     buffer[1]];

  free(buffer);

  return stringVal;
}

- (NSString *) ioSupportForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:IO_SUPPORT_BYTES forIdentifier:theIdentifier];
}

- (NSString *) romStartForCartridgeIdentifier:(id) theIdentifier {
  unichar   *buffer     = [self bytesInRange:ROM_START_BYTES
                                      length:4
                               forIdentifier:theIdentifier];
  NSString  *stringVal  = [NSString stringWithFormat:@"0x%02X%02X%02X%02X",
                                                     buffer[0],
                                                     buffer[1],
                                                     buffer[2],
                                                     buffer[3]];

  free(buffer);

  return stringVal;
}

- (NSString *) romEndForCartridgeIdentifier:(id) theIdentifier {
  unichar   *buffer     = [self bytesInRange:ROM_END_BYTES
                                      length:4
                               forIdentifier:theIdentifier];
  NSString  *stringVal  = [NSString stringWithFormat:@"0x%02X%02X%02X%02X",
                                                     buffer[0],
                                                     buffer[1],
                                                     buffer[2],
                                                     buffer[3]];

  free(buffer);

  return stringVal;
}

- (NSString *) ramStartForCartridgeIdentifier:(id) theIdentifier {
  unichar   *buffer     = [self bytesInRange:RAM_START_BYTES
                                      length:4
                               forIdentifier:theIdentifier];
  NSString  *stringVal  = [NSString stringWithFormat:@"0x%02X%02X%02X%02X",
                                                     buffer[0],
                                                     buffer[1],
                                                     buffer[2],
                                                     buffer[3]];

  free(buffer);

  return stringVal;
}

- (NSString *) ramEndForCartridgeIdentifier:(id) theIdentifier {
  unichar   *buffer     = [self bytesInRange:RAM_END_BYTES
                                      length:4
                                 forIdentifier:theIdentifier];
  NSString  *stringVal  = [NSString stringWithFormat:@"0x%02X%02X%02X%02X",
                                                     buffer[0],
                                                     buffer[1],
                                                     buffer[2],
                                                     buffer[3]];

  free(buffer);

  return stringVal;
}

- (NSString *) modemSupportForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:MODEM_SUPPORT_BYTES forIdentifier:theIdentifier];
}

- (NSString *) memoForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:MEMO_BYTES forIdentifier:theIdentifier];
}

- (NSString *) countryForCartridgeIdentifier:(id) theIdentifier {
  return [self stringInRange:COUNTRY_BYTES forIdentifier:theIdentifier];
}

- (BOOL) isCorruptedCartridgeOfIdentifier:(id) theIdentifier {
  unichar         *checkSumBytes  = [self bytesInRange:CHECK_SUM_BYTES
                                                length:2
                                         forIdentifier:theIdentifier];
  unsigned short  trueCheckSum;
  unsigned short  testCheckSum;

  trueCheckSum =  checkSumBytes[0] << 8;
  trueCheckSum += checkSumBytes[1];
  testCheckSum =  [self calculateCheckSumForCartridgeIdentifier:theIdentifier];

  free(checkSumBytes);

  return (trueCheckSum != testCheckSum);
}

- (BOOL) fixCartridgeOfIdentifier:(id) theIdentifier {
  BOOL response = NO;

  if([self isCorruptedCartridgeOfIdentifier:(id) theIdentifier]) {
    unsigned short  checkSum;
    unsigned short  bytes;
    NSData          *cartridge;
    NSMutableData   *newCartridge;

    checkSum      = [self calculateCheckSumForCartridgeIdentifier:theIdentifier];
    // change the byte ordering
    bytes         = (checkSum >> 8) + (checkSum << 8);
    cartridge     = [_genesisCartridges objectForKey:theIdentifier];
    newCartridge  = [[NSMutableData alloc] initWithCapacity:[cartridge length]];

    [newCartridge setData:cartridge];
    [newCartridge replaceBytesInRange:CHECK_SUM_BYTES withBytes:&bytes];

    [_genesisCartridges setObject:[NSData dataWithData:newCartridge]
                           forKey:theIdentifier];

    response = YES;
  }

  return response; // fix or not
}

+ (BOOL) isGenesisCartridgeFile:(NSString *) filename {
  NSData    *file;
  NSData    *subdata;
  NSString  *consoleName;
  BOOL      isGenesisCartridge;

  file        = [[NSData alloc] initWithContentsOfFile:filename];
  subdata     = [file subdataWithRange:CONSOLE_NAME_BYTES];
  consoleName = [[NSString alloc] initWithData:subdata
                                      encoding:STRING_ENCODING];
  isGenesisCartridge = ([consoleName hasPrefix:@"SEGA GENESIS"]
                        || [consoleName hasPrefix:@"SEGA MEGA DRIVE"]);

  return isGenesisCartridge;
}

@end

@implementation GenesisCartridgeController (PrivateMethods)

- (unsigned short) calculateCheckSumForCartridgeIdentifier:(id) theIdentifier {
  unsigned int  checkSum      = 0;
  NSData        *cartridge    = [_genesisCartridges objectForKey:theIdentifier];
  NSRange       testRange     = NSMakeRange(0x200,
                                            [cartridge length] - 0x200);
  NSData        *bytes        = [cartridge subdataWithRange:testRange];
  NSString      *stringBytes  = [[NSString alloc] initWithData:bytes
                                                      encoding:BYTE_ENCODING];

  NSUInteger i;
  for(i = 0; i < [stringBytes length] - 1; i += 2) {
    checkSum += [stringBytes characterAtIndex:i] << 8;
    checkSum += [stringBytes characterAtIndex:i + 1];
  }

  [stringBytes release];

  return checkSum;
}

- (NSString *) stringInRange:(NSRange) theRange
               forIdentifier:(id) theIdentifier {
  NSData    *cartridge  = [_genesisCartridges objectForKey:theIdentifier];
  NSData    *subData    = [cartridge subdataWithRange:theRange];
  NSString  *stringVal  = nil;
  
  stringVal = [[NSString alloc] initWithData:subData encoding:STRING_ENCODING];

  [stringVal autorelease];

  return stringVal;
}

- (unichar *) bytesInRange:(NSRange)   theRange
                    length:(NSInteger) theLength
             forIdentifier:(id)        theIdentifier {
  unichar   *buffer     = calloc(theLength, sizeof(unichar));
  NSData    *cartridge  = [_genesisCartridges objectForKey:theIdentifier];
  NSData    *subData    = [cartridge subdataWithRange:theRange];
  NSString  *stringVal  = nil;
  
  stringVal = [[NSString alloc] initWithData:subData encoding:BYTE_ENCODING];

  for(NSInteger i = 0; i < theLength; ++i) {
    buffer[i] = [stringVal characterAtIndex:i];
  }

  [stringVal release];

  // it's important to free buffer after the call of this method
  return buffer;
}

@end

