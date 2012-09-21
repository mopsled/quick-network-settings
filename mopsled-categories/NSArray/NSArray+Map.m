//
//  NSArray+Map.m
//  mopsled-categories
//
//  Created by Alec Geatches on 9/19/12.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

// This source is not original, and was found on StackOverflow at:
// http://stackoverflow.com/a/7248251/770938
// Thanks to Justin Anderson
- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}

@end