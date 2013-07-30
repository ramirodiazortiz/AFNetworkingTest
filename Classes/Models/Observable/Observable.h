//
//  Observable.h
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 05/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Observable : NSObject {
    NSMutableSet* collectionObservers;
}

- (BOOL) isObserver :(id) observer;
- (void) addCollectionObserver:(id) observer;
- (void) removeCollectionObserver:(id) observer;
- (void) removeAllCollectionObservers;
@end

