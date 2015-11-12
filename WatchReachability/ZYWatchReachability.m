//
//  ZYWatchReachability.m
//  WatchReachability
//
//  Created by zy on 15/11/12.
//  Copyright © 2015年 zybug. All rights reserved.
//

#import "ZYWatchReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface ZYWatchReachability ()

@property (nonatomic, strong) Reachability *reachability;

@end


@implementation ZYWatchReachability


+ (void)load {
    [super load];
    static ZYWatchReachability *watch = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        watch = [[ZYWatchReachability alloc] init];
    });
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        self.reachability = [Reachability reachabilityForInternetConnection];
        [self.reachability startNotifier];
        [self updateInterfaceWithReachability:self.reachability];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == NotReachable) {
        NSLog(@"No Internet");
    }else if (status == ReachableViaWiFi) {
        NSLog(@"Reachable WiFi");
    }else if (status == ReachableViaWWAN) {
        NSLog(@"Reachable WWAN");
    }
}


@end
