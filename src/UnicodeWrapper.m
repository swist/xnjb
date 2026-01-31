//
//  UnicodeWrapper.m
//  XNJB
//
//  Created by Richard Low on 17/09/2004.
//

#import "UnicodeWrapper.h"
#import <Foundation/Foundation.h>

@implementation UnicodeWrapper

+ (NSString *)stringFromUTF16:(unsigned short *)uni
{
	if (uni == NULL)
		return nil;

	// Calculate length of the UTF-16 string (null-terminated)
	int length = 0;
	while (uni[length] != 0) {
		length++;
	}

	// Use NSString's built-in UTF-16 support
	NSString *result = [[NSString alloc] initWithBytes:uni
	                                            length:length * sizeof(unsigned short)
	                                          encoding:NSUTF16LittleEndianStringEncoding];
	return result;
}

// the return must be freed using free()
// as of version 1.1.4 we don't do any endian swapping-just return the short as we should
+ (unsigned short *)UTF16FromString:(NSString *)str
{
	if (str == nil)
		return NULL;

	// Get the UTF-16 representation
	NSUInteger length = [str length];

	// Allocate buffer for UTF-16 string plus null terminator
	unsigned short *buffer = (unsigned short *)malloc((length + 1) * sizeof(unsigned short));
	if (buffer == NULL)
		return NULL;

	// Get the UTF-16 characters
	[str getCharacters:buffer range:NSMakeRange(0, length)];

	// Null terminate
	buffer[length] = 0;

	return buffer;
}

@end
