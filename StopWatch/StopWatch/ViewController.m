//
//  ViewController.m
//  StopWatchDemo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LSIStopWatch.h"


// KVO = Key Value Observing
// Lsiten for changes on a property
// Similar to Observer/Delegate patterns


void *KVOContext = &KVOContext; // pointer to this pointer's spot in memory
// void * = AnyObject (pointer to any class type)
// unique; only this file has access to it


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (nonatomic) LSIStopWatch *stopwatch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.stopwatch = [[LSIStopWatch alloc] init];
	[self.timeLabel
     setFont:[UIFont monospacedDigitSystemFontOfSize: self.timeLabel.font.pointSize
                                              weight:UIFontWeightMedium]];
}

- (IBAction)resetButtonPressed:(id)sender {
    [self.stopwatch reset];
}

- (IBAction)startStopButtonPressed:(id)sender {
    if (self.stopwatch.isRunning) {
        [self.stopwatch stop];
    } else {
        [self.stopwatch start];
    }
}

- (void)updateViews {
    if (self.stopwatch.isRunning) {
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    self.resetButton.enabled = self.stopwatch.elapsedTime > 0;
    
    self.timeLabel.text = [self stringFromTimeInterval:self.stopwatch.elapsedTime];
}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger timeIntervalAsInt = (NSInteger)interval;
    NSInteger tenths = (NSInteger)((interval - floor(interval)) * 10);
    NSInteger seconds = timeIntervalAsInt % 60;
    NSInteger minutes = (timeIntervalAsInt / 60) % 60;
    NSInteger hours = (timeIntervalAsInt / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%ld", (long)hours, (long)minutes, (long)seconds, (long)tenths];
}

- (void)setStopwatch:(LSIStopWatch *)stopwatch {
    if (stopwatch != _stopwatch) {
        
        // willSet
		// Cleanup KVO - Remove Observers

        [_stopwatch removeObserver:self
                        forKeyPath:@"running"
                           context:KVOContext];
        [_stopwatch removeObserver:self
                        forKeyPath:@"elapsedTime"
                           context:KVOContext];

        _stopwatch = stopwatch;
        
        // didSet
		// Setup KVO - Add Observers

        // context = who is listening (unique to our class)

        [_stopwatch addObserver:self
                     forKeyPath:@"running"
                        options:NSKeyValueObservingOptionInitial
                        context:KVOContext];
        [_stopwatch addObserver:self
                     forKeyPath:@"elapsedTime"
                        options:NSKeyValueObservingOptionInitial
                        context:KVOContext];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == KVOContext) {
        if ([keyPath isEqualToString:@"running"]) {
            NSLog(@"Update UI; running: %i", self.stopwatch.running);
            [self updateViews];
        } else if ([keyPath isEqualToString:@"elapsedTime"]) {
            [self updateViews];
            NSLog(@"update ui; elapsed time: %0.2f", self.stopwatch.elapsedTime);
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)dealloc {
    self.stopwatch = nil; // invokes methods
}

@end
