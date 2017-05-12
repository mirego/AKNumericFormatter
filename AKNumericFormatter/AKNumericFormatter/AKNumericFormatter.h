//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

typedef NS_ENUM(NSUInteger, AKNumericFormatterMode) {
  AKNumericFormatterStrict,
  AKNumericFormatterFillIn,
  AKNumericFormatterMixed
};

@interface AKNumericFormatter : NSObject

+(NSString*)formatString:(NSString*)string
               usingMask:(NSString*)mask
    placeholderCharacter:(unichar)placeholderCharacter
                    mode:(AKNumericFormatterMode)mode;
// Uses AKNumericFormatterStrict mode
+(NSString*)formatString:(NSString*)string
               usingMask:(NSString*)mask
    placeholderCharacter:(unichar)placeholderCharacter;

+(instancetype)formatterWithMask:(NSString*)mask
            placeholderCharacter:(unichar)placeholderCharacter
                            mode:(AKNumericFormatterMode)mode
                    characterSet:(NSCharacterSet *)characterSet;
+(instancetype)formatterWithMask:(NSString*)mask
            placeholderCharacter:(unichar)placeholderCharacter
                            mode:(AKNumericFormatterMode)mode;
// Uses AKNumericFormatterStrict mode
+(instancetype)formatterWithMask:(NSString*)mask
            placeholderCharacter:(unichar)placeholderCharacter;


@property(nonatomic, readonly) AKNumericFormatterMode mode;
@property(nonatomic, readonly, copy) NSString* mask;
@property(nonatomic, readonly) unichar placeholderCharacter;
@property(nonatomic, readonly, copy) NSCharacterSet* characterSet;

-(NSUInteger)indexOfFirstDigitOrPlaceholderInMask;

// Returns empty string if input string has no decimal digits
-(NSString*)formatString:(NSString*)string;
-(BOOL)isFormatFulfilled:(NSString*)string;
-(BOOL)isCorrespondingToFormat:(NSString*)string;

// Returns nil if input string doesn't correspond to format
-(NSString*)unfixedDigits:(NSString*)string;
-(NSString*)fillInMaskWithDigits:(NSString*)digits;

@end
