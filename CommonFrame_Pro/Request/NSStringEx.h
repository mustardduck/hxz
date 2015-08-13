//
//  NSStringEx.h
//  CommonFrame_Pro
//
//  Created by ionitech on 15/7/20.
//  Copyright (c) 2015年 ionitech. All rights reserved.
//

//
//  NSStringEx.h
//  NSStringEx
//
//  Created by Tang Qiao on 12-2-4.
//  Copyright (c) 2012年 blog.devtang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(NSStringEx)

/**
 * Return the char value at the specified index~
 */
-(unichar) charAt:(int)index;

/**
 * Compares two strings lexicographically.
 * the value 0 if the argument string is equal to this string;
 * a value less than 0 if this string is lexicographically less than the string argument;
 * and a value greater than 0 if this string is lexicographically greater than the string argument.
 */
-(int) compareTo:(NSString*) anotherString;

-(int) compareToIgnoreCase:(NSString*) str;

-(BOOL) contains:(NSString*) str;

-(BOOL) startsWith:(NSString*)prefix;

-(BOOL) endsWith:(NSString*)suffix;

-(BOOL) equals:(NSString*) anotherString;

-(BOOL) equalsIgnoreCase:(NSString*) anotherString;

-(int) indexOfChar:(unichar)ch;

-(int) indexOfChar:(unichar)ch fromIndex:(int)index;

- (int) indexOfString:(NSString*)str;

-(int) indexOfString:(NSString*)str fromIndex:(int)index;

-(int) lastIndexOfChar:(unichar)ch;

-(int) lastIndexOfChar:(unichar)ch fromIndex:(int)index;

-(int) lastIndexOfString:(NSString*)str;

-(int) lastIndexOfString:(NSString*)str fromIndex:(int)index;

-(NSString*) substringFromIndex:(int)beginIndex toIndex:(int)endIndex;

-(NSString*) toLowerCase;

-(NSString*) toUpperCase;

-(NSString*) trim;

-(NSString*) replaceAll:(NSString*)origin with:(NSString*)replacement;

-(NSArray*) split:(NSString*) separator;

@end