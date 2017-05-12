//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

@interface NSString(AKNumericFormatter)

// Will return nil if filterBlock is nil
-(NSString*)filteredStringUsingBlock:(BOOL (^)(unichar character))filterBlock;
// Shortcut
-(NSString*)stringContainingOnlyAllowedCharacters:(NSCharacterSet *)characterSet;

// Will return -1 if filterBlock is nil or the whole string contains less characters passing filter than requested
-(NSInteger)minPrefixLengthContainingCharsCount:(NSUInteger)charsCount satisfyingBlock:(BOOL (^)(unichar character))filterBlock;
-(NSInteger)minSuffixLengthContainingCharsCount:(NSUInteger)charsCount satisfyingBlock:(BOOL (^)(unichar character))filterBlock;
// Shortcuts
-(NSInteger)minPrefixLengthContainingCharsCount:(NSUInteger)charsCount inSet:(NSCharacterSet *)characterSet;
-(NSInteger)minSuffixLengthContainingCharsCount:(NSUInteger)charsCount inSet:(NSCharacterSet *)characterSet;

-(NSUInteger)countCharsSatisfyingBlock:(BOOL (^)(unichar character))filterBlock;
// Shortcut
-(NSUInteger)countAllowedCharacters:(NSCharacterSet *)characterSet;

-(NSUInteger)indexOfCharacter:(unichar)character;

@end
