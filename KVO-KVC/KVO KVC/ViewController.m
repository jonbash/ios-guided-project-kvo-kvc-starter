//
//  ViewController.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LSIDepartment.h"
#import "LSIEmployee.h"
#import "LSIHRController.h"


@interface ViewController ()

@property (nonatomic) LSIHRController *hrController;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    LSIDepartment *marketing = [[LSIDepartment alloc] init];
    marketing.name = @"Marketing";
    LSIEmployee * philSchiller = [[LSIEmployee alloc] init];
    philSchiller.name = @"Phil";
    philSchiller.jobTitle = @"VP of Marketing";
    philSchiller.salary = 10000000; 
    marketing.manager = philSchiller;

    
    LSIDepartment *engineering = [[LSIDepartment alloc] init];
    engineering.name = @"Engineering";
    LSIEmployee *craig = [[LSIEmployee alloc] init];
    craig.name = @"Craig";
    craig.salary = 9000000;
    craig.jobTitle = @"Head of Software";
    engineering.manager = craig;
    
    LSIEmployee *e1 = [[LSIEmployee alloc] init];
    e1.name = @"Chad";
    e1.jobTitle = @"Engineer";
    e1.salary = 200000;
    
    LSIEmployee *e2 = [[LSIEmployee alloc] init];
    e2.name = @"Lance";
    e2.jobTitle = @"Engineer";
    e2.salary = 250000;
    
    LSIEmployee *e3 = [[LSIEmployee alloc] init];
    e3.name = @"Joe";
    e3.jobTitle = @"Marketing Designer";
    e3.salary = 100000;
    
    [engineering addEmployee:e1];
    [engineering addEmployee:e2];
    [marketing addEmployee:e3];

    LSIHRController *controller = [[LSIHRController alloc] init];
    [controller addDepartment:engineering];
    [controller addDepartment:marketing];
    self.hrController = controller;
    
    NSLog(@"%@", self.hrController);
    
    // KEY VALUE CODING: KVC
    // * Core Data
    // * Cocoa Bindings (UI + Model = SwiftUI)

    // @property NSString *name; // Properties automatically KVC-compliant

    /*
     1. Accessor for a prop
        - (NSString *)name;
     2. setter for prop
        - (void)setName:(NSString *)name;
     3. Instance variable to set

     modify data using self.name syntax (not _name)
     1. init/dealloc always use: _name =
     2. normal methods always use self.name =
     */

    // property accessor
    NSString *name = [craig name]; // or craig.name
    // compile-time checking for valid properties
    // eg `[craig nameddd]` won't even compile
    NSLog(@"Name: %@", name);

    // dynamic method call - look up methods and call them via NSString name

    NSString *name2 = [craig valueForKey:@"name"];
    NSLog(@"Name 2: %@", name2); // works just like more typesafe property accessor

//    NSString *name3 = [craig valueForKey:@"firstName"];
//    NSLog(@"Name 3: %@", name3); // uh oh!! crash! not KVC-compliant
    NSString *name3 = [craig valueForKey:@"privateName"];
    NSLog(@"Name 3: %@", name3); // works; accesses a private property
}


@end
