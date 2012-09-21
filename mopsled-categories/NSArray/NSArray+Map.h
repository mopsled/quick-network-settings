//
//  NSArray+Map.h
//  mopsled-categories
//
//  Created by Alec Geatches on 9/19/12.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;

@end
