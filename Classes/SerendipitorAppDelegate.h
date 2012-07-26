//
//  SerendipitorAppDelegate.h
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SerendipitorViewController;

@interface SerendipitorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SerendipitorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SerendipitorViewController *viewController;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@end

