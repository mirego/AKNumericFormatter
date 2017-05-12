//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import "NSString+AKNumericFormatter.h"

@implementation NSString(AKNumericFormatter)

-(NSString*)filteredStringUsingBlock:(BOOL (^)(unichar character))filterBlock
{
  if( !filterBlock ) {
    return nil;
  }
  NSMutableString* result = [NSMutableString string];
  for( NSUInteger i = 0; i < self.length; ++i ) {
    const unichar currentCharacter = [self characterAtIndex:i];
    if( filterBlock(currentCharacter) ) {
      [result appendString:[NSString stringWithCharacters:&currentCharacter length:1]];
    }
  }
  return result;
}

-(NSString*)stringContainingOnlyAllowedCharacters:(NSCharacterSet *)characterSet
{
  return [self filteredStringUsingBlock:^BOOL(unichar character)
  {
    return [characterSet characterIsMember:character];
  }];
}

-(NSInteger)minPrefixLengthContainingCharsCount:(NSUInteger)charsCount satisfyingBlock:(BOOL (^)(unichar character))filterBlock
{
  if( !filterBlock ) {
    return -1;
  }
  NSUInteger result = 0;
  for( ; result < self.length && charsCount > 0; ++result ) {
    const unichar currentCharacter = [self characterAtIndex:result];
    if( filterBlock(currentCharacter) ) {
      --charsCount;
    }
  }
  if( charsCount != 0 ) {
    return -1;
  }
  return result;
}

-(NSInteger)minPrefixLengthContainingCharsCount:(NSUInteger)charsCount inSet:(NSCharacterSet *)characterSet
{
  return [self minPrefixLengthContainingCharsCount:charsCount
                                   satisfyingBlock:^BOOL(unichar character)
  {
    return [characterSet characterIsMember:character];
  }];
}

-(NSInteger)minSuffixLengthContainingCharsCount:(NSUInteger)charsCount satisfyingBlock:(BOOL (^)(unichar character))filterBlock
{
  if( !filterBlock ) {
    return -1;
  }
  NSUInteger result = 0;
  for( ; result < self.length && charsCount > 0; ++result ) {
    const unichar currentCharacter = [self characterAtIndex:self.length - 1 - result];
    if( filterBlock(currentCharacter) ) {
      --charsCount;
    }
  }
  if( charsCount != 0 ) {
    return -1;
  }
  return result;
}

-(NSInteger)minSuffixLengthContainingCharsCount:(NSUInteger)charsCount inSet:(NSCharacterSet *)characterSet
{
  return [self minSuffixLengthContainingCharsCount:charsCount
                                   satisfyingBlock:^BOOL(unichar character)
  {
    return [characterSet characterIsMember:character];
  }];
}

-(NSUInteger)countCharsSatisfyingBlock:(BOOL (^)(unichar character))filterBlock
{
  if( !filterBlock ) {
    return 0;
  }
  NSUInteger result = 0;
  for( NSUInteger i = 0; i < self.length; ++i ) {
    const unichar currentCharacter = [self characterAtIndex:i];
    if( filterBlock(currentCharacter) ) {
      ++result;
    }
  }
  return result;
}

-(NSUInteger)countAllowedCharacters:(NSCharacterSet *)characterSet
{
  return [self countCharsSatisfyingBlock:^BOOL(unichar character)
  {
    return [characterSet characterIsMember:character];
  }];
}

-(NSUInteger)indexOfCharacter:(unichar)character
{
  for( NSUInteger i = 0; i < self.length; ++i ) {
    if( [self characterAtIndex:i] == character ) {
      return i;
    }
  }
  return NSNotFound;
}

@end
