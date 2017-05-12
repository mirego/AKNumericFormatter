//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import "AKNumericFormatter.h"
#import "NSString+AKNumericFormatter.h"

@interface AKNumericFormatter()

@property(nonatomic, assign) AKNumericFormatterMode mode;
@property(nonatomic, copy) NSString* mask;
@property(nonatomic, assign) unichar placeholderCharacter;
@property(nonatomic, copy) NSCharacterSet* characterSet;

@end

@implementation AKNumericFormatter

+(NSString*)formatString:(NSString*)string
               usingMask:(NSString*)mask
    placeholderCharacter:(unichar)placeholderCharacter
                    mode:(AKNumericFormatterMode)mode
{
  return [[self formatterWithMask:mask placeholderCharacter:placeholderCharacter mode:mode] formatString:string];
}

+(NSString*)formatString:(NSString*)string
               usingMask:(NSString*)mask
    placeholderCharacter:(unichar)placeholderCharacter
{
  return [self formatString:string usingMask:mask placeholderCharacter:placeholderCharacter
                       mode:AKNumericFormatterStrict];
}

+(instancetype)formatterWithMask:(NSString *)mask
            placeholderCharacter:(unichar)placeholderCharacter
                            mode:(AKNumericFormatterMode)mode
                    characterSet:(NSCharacterSet *)characterSet
{
    return [[AKNumericFormatter alloc] initWithMask:mask placeholderCharacter:placeholderCharacter mode:mode characterSet:characterSet];
}
+(instancetype)formatterWithMask:(NSString*)mask
            placeholderCharacter:(unichar)placeholderCharacter
                            mode:(AKNumericFormatterMode)mode
{
  return [self formatterWithMask:mask placeholderCharacter:placeholderCharacter mode:mode characterSet:[NSCharacterSet decimalDigitCharacterSet]];
}

+(instancetype)formatterWithMask:(NSString*)mask placeholderCharacter:(unichar)placeholderCharacter
{
  return [self formatterWithMask:mask placeholderCharacter:placeholderCharacter mode:AKNumericFormatterStrict];
}


-(instancetype)initWithMask:(NSString*)mask placeholderCharacter:(unichar)placeholderCharacter mode:(AKNumericFormatterMode)mode characterSet:(NSCharacterSet *)characterSet
{
  NSParameterAssert(mask);
  self = [super init];
  if( !self ) {
    return nil;
  }
  self.mode = mode;
  self.mask = mask;
  self.placeholderCharacter = placeholderCharacter;
  self.characterSet = characterSet;
  return self;
}

-(NSUInteger)indexOfFirstDigitOrPlaceholderInMask
{
  const NSUInteger placeholderIndex = [self.mask indexOfCharacter:self.placeholderCharacter];
  const NSUInteger digitIndex = [self.mask rangeOfCharacterFromSet:self.characterSet].location;
  return MIN(placeholderIndex, digitIndex);
}

-(NSString*)formatString:(NSString*)string
{
  NSString* onlyDigitsString = [string stringContainingOnlyAllowedCharacters:self.characterSet];
  if( onlyDigitsString.length == 0 ) {
    return @"";
  }

  NSString *formattedString = @"";
  switch (self.mode) {
    case AKNumericFormatterFillIn:
      formattedString = [self fillInModeFormattedString:onlyDigitsString];
      break;
    case AKNumericFormatterMixed:
      formattedString = [self mixedModeFormattedString:onlyDigitsString];
      break;
    case AKNumericFormatterStrict:
    default:
      formattedString = [self strictModeFormattedString:onlyDigitsString];
      break;
  }

  if( [formattedString stringContainingOnlyAllowedCharacters:self.characterSet].length == 0 ) {
    return @"";
  }
  return formattedString;
}

-(BOOL)isFormatFulfilled:(NSString*)string
{
  return string.length == self.mask.length && [self isCorrespondingToFormat:string];
}

-(BOOL)isCorrespondingToFormat:(NSString*)string
{
  NSString* formattedString = [self formatString:string];
  return string.length <= formattedString.length && [[formattedString substringToIndex:string.length] isEqualToString:string];
}

-(NSString*)unfixedDigits:(NSString*)string
{
  if( ![self isCorrespondingToFormat:string] ) {
    return nil;
  }
  NSMutableString* result = [NSMutableString string];
  NSString* filteredMask = [self.mask filteredStringUsingBlock:^BOOL(unichar character)
  {
    return character == self.placeholderCharacter || [self.characterSet characterIsMember:character];
  }];
  NSString* filteredValue = [string stringContainingOnlyAllowedCharacters:self.characterSet];
  for( NSUInteger i = 0; i < filteredValue.length && i < filteredMask.length; ++i ) {
    if( [filteredMask characterAtIndex:i] == self.placeholderCharacter ) {
      [result appendString:[filteredValue substringWithRange:NSMakeRange(i, 1)]];
    }
  }
  return result;
}

-(NSString*)fillInMaskWithDigits:(NSString*)digits
{
  return [AKNumericFormatter formatString:digits
                                usingMask:self.mask
                     placeholderCharacter:self.placeholderCharacter
                                     mode:AKNumericFormatterFillIn];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

-(NSString*)strictModeFormattedString:(NSString*)onlyDigitsString
{
  NSMutableString* formattedString = [NSMutableString string];
  for( NSUInteger maskIndex = 0, digitIndex = 0; maskIndex < self.mask.length; ++maskIndex ) {
    const unichar maskCharacter = [self.mask characterAtIndex:maskIndex];
    if( maskCharacter == self.placeholderCharacter ) {
      if( digitIndex < onlyDigitsString.length ) {
        [formattedString appendString:[onlyDigitsString substringWithRange:NSMakeRange(digitIndex, 1)]];
        ++digitIndex;
      } else {
        break;
      }
    } else if( [self.characterSet characterIsMember:maskCharacter] ) {
      if( digitIndex < onlyDigitsString.length && maskCharacter == [onlyDigitsString characterAtIndex:digitIndex] ) {
        [formattedString appendString:[NSString stringWithCharacters:&maskCharacter length:1]];
        ++digitIndex;
      } else {
        break;
      }
    } else if (digitIndex < onlyDigitsString.length) {
      [formattedString appendString:[NSString stringWithCharacters:&maskCharacter length:1]];
    }
  }
  return formattedString;
}

-(NSString*)fillInModeFormattedString:(NSString*)onlyDigitsString
{
  NSMutableString* formattedString = [NSMutableString string];
  for( NSUInteger maskIndex = 0, digitIndex = 0; maskIndex < self.mask.length; ++maskIndex ) {
    const unichar maskCharacter = [self.mask characterAtIndex:maskIndex];
    if( maskCharacter == self.placeholderCharacter ) {
      if( digitIndex < onlyDigitsString.length ) {
        [formattedString appendString:[onlyDigitsString substringWithRange:NSMakeRange(digitIndex, 1)]];
        ++digitIndex;
      } else {
        break;
      }
    } else if (digitIndex < onlyDigitsString.length) {
      [formattedString appendString:[NSString stringWithCharacters:&maskCharacter length:1]];
    }
  }
  return formattedString;
}

-(NSString*)mixedModeFormattedString:(NSString*)onlyDigitsString
{
  NSMutableString* formattedString = [NSMutableString string];
  for( NSUInteger maskIndex = 0, digitIndex = 0; maskIndex < self.mask.length; ++maskIndex ) {
    const unichar maskCharacter = [self.mask characterAtIndex:maskIndex];
    if( maskCharacter == self.placeholderCharacter ) {
      if( digitIndex < onlyDigitsString.length ) {
        [formattedString appendString:[onlyDigitsString substringWithRange:NSMakeRange(digitIndex, 1)]];
        ++digitIndex;
      } else {
        break;
      }
    } else if( [self.characterSet characterIsMember:maskCharacter] ) {
      if( digitIndex < onlyDigitsString.length && maskCharacter == [onlyDigitsString characterAtIndex:digitIndex] ) {
        [formattedString appendString:[NSString stringWithCharacters:&maskCharacter length:1]];
        ++digitIndex;
      } else if( digitIndex < onlyDigitsString.length && maskCharacter != [onlyDigitsString characterAtIndex:digitIndex] ) {
        [formattedString appendString:[NSString stringWithCharacters:&maskCharacter length:1]];
      } else {
        break;
      }
    } else if (digitIndex < onlyDigitsString.length) {
      [formattedString appendString:[NSString stringWithCharacters:&maskCharacter length:1]];
    }
  }
  return formattedString;
}

@end
