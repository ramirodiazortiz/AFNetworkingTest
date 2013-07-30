//
//  Observable.m
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 05/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import "Observable.h"

@implementation Observable

- (void) addCollectionObserver:(id) observer {
    if (observer != nil) {
        [collectionObservers addObject:observer];
    }
}

- (void) removeCollectionObserver:(id) observer {
    [collectionObservers removeObject:observer];
}

- (void) removeAllCollectionObservers {
    [collectionObservers removeAllObjects];
}

- (BOOL) isObserver :(id) observer {
    return [collectionObservers containsObject: observer];
}

@end
