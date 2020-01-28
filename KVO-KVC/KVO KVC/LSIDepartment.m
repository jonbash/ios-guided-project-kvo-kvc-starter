//
//  LSIDepartment.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "LSIDepartment.h"

@interface LSIDepartment ()

@property (nonatomic) NSMutableArray<LSIEmployee *> *internalEmployees;

@end

@implementation LSIDepartment

- (instancetype)init {
    self = [super init];
    if (self) {
        _internalEmployees = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)addEmployee:(LSIEmployee *)employee {
    [self.internalEmployees addObject:employee];
}

- (NSArray<LSIEmployee *> *)employees {
    return [self.internalEmployees arrayByAddingObject:self.manager];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Department: %@\n\tManager: %@\n\tEmployees: %@", self.name, self.manager, self.employees];
}

@end
