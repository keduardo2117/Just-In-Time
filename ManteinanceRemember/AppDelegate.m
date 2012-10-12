//
//  AppDelegate.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 08/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//



#import "AppDelegate.h"
#import "ListOfCompaniesController.h"
@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#define TESTING 1
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[UIDevice currentDevice].uniqueIdentifier];
#endif
    [TestFlight takeOff:@"3bcfb0fb2419921703e2aefe3b3eaf51_MTM3NzU1MjAxMi0wOS0zMCAwMTo1ODoxMi43NDIwODM"];
    UIImage *navBarImage = [UIImage imageNamed:@"ipad-menubar-right.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      UITextAttributeTextColor,
      [UIColor blackColor],
      UITextAttributeTextShadowColor,
      [UIFont systemFontOfSize:18],
      UITextAttributeFont,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      nil]];
    [[UIBarButtonItem appearance] setBackButtonBackgroundVerticalPositionAdjustment:1.0f forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundVerticalPositionAdjustment:1.0f forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -2) forBarMetrics:UIBarMetricsDefault];
    UIImage *barButton = [[UIImage imageNamed:@"ipad-menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor whiteColor],
                                                         UITextAttributeTextColor,
                                                         [UIColor blackColor],
                                                         UITextAttributeTextShadowColor,
                                                         [UIFont systemFontOfSize:14],
                                                         UITextAttributeFont,
                                                         [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                         UITextAttributeTextShadowOffset,
                                                          nil] forState:UIControlStateNormal];
    
    UIImage *backButton = [[UIImage imageNamed:@"ipad-back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    [DataManager isFirstTime];
    NSLog(@"Notificaciones guardadas: %d",[[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
        UINavigationController *masterNavigationController = [splitViewController.viewControllers objectAtIndex:0];
        
        ListOfCompaniesController *controller = (ListOfCompaniesController *)masterNavigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
    } else {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ipad-menubar-left.png"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ipad-menubar-right.png"] forBarMetrics:UIBarMetricsLandscapePhone];
        ListOfCompaniesController *controller = (ListOfCompaniesController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
    }
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[DataManager sharedInstance] createFirstTimeMarker];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ManteinanceRemember" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ManteinanceRemember.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
