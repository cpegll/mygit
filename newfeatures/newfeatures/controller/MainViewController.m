//
//  MainViewController.m
//  newfeatures
//
//  Created by admin on 2014/2/6.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController


#pragma mark -
#pragma mark main

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.view.backgroundColor = [UIColor grayColor];
    
    //_label.text = @"New Features!!";
    [self fbLoginButtonInit];
    [self initLocation];
    [self setupLocation];
    [self setupLocationRegion];
    [self setupLocationBeacons];
    
}

/*
-(void)viewDidUnload
{
    //_profilePic = nil;
    [super viewDidUnload];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark location function

-(void)initLocation
{
    _locManager = [[CLLocationManager alloc] init];
    _locManager.delegate = self;
}

-(void)setupLocation
{
    [_locManager startUpdatingLocation];
}

-(void)setupLocationRegion
{
   /*
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"C2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    //raspberry pi:E2C56DB5-DFFB-48D2-B060-D0F5A71096E0
    //estimote:B9407F30-F5F8-466E-AFF9-25556B57FE6D
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    _BeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"newfeaturesBeacons"];
    
    
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    
    _BeaconRegion.notifyEntryStateOnDisplay = YES;
    
    // Tell location manager to start monitoring for the beacon region
    [_locManager startMonitoringForRegion:_BeaconRegion];
    [_locManager startRangingBeaconsInRegion:_BeaconRegion];
    */
    
    _BeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"] major: 1 minor: 1 identifier: @"region1"];
    _BeaconRegion.notifyEntryStateOnDisplay = YES;
    [_locManager startMonitoringForRegion:_BeaconRegion];
    //[_locManager stopRangingBeaconsInRegion:_BeaconRegion];
    [_locManager startRangingBeaconsInRegion:_BeaconRegion];
    
    
    
    _BeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"] major: 1 minor: 2 identifier: @"region2"];
    _BeaconRegion.notifyEntryStateOnDisplay = YES;
    [_locManager startMonitoringForRegion:_BeaconRegion];
    //[_locManager stopRangingBeaconsInRegion:_BeaconRegion];
    [_locManager startRangingBeaconsInRegion:_BeaconRegion];
    
    
    
}

-(void)setupLocationBeacons
{
    //[_locManager startRangingBeaconsInRegion:<#(CLBeaconRegion *)#>];
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = location = (CLLocation *)[locations objectAtIndex:[locations count] - 1];
    
    
    
    _labelLoc.text = [NSString stringWithFormat:@"didUpdateLocations\n%.6f, %.6f", [location coordinate].latitude, [location coordinate].longitude];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    _labelRegion.text = @"didEnterRegion";
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    _labelRegion.text = @"didExitRegion";
}


-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    _labelBeacons.text = @"didRangeBeacons";
    
    for (int i = 0; i < [beacons count]; i++)
    {
        //CLBeacon *beacon = [beacons objectAtIndex:i];
        
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside) {
        NSLog(@"locationManager didDetermineState INSIDE for %@", region.identifier);
        _labelBeacons.text = [NSString stringWithFormat:@"locationManager didDetermineState INSIDE for %@", region.identifier];
    }
    else if(state == CLRegionStateOutside) {
        NSLog(@"locationManager didDetermineState OUTSIDE for %@", region.identifier);
        _labelBeacons.text = [NSString stringWithFormat:@"locationManager didDetermineState OUTSIDE for %@", region.identifier];
    }
    else {
        NSLog(@"locationManager didDetermineState OTHER for %@", region.identifier);
        _labelBeacons.text = [NSString stringWithFormat:@"locationManager didDetermineState OTHER for %@", region.identifier];
    }
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    _labelBeacons.text = @"monitoringDidFailForRegion";
}


#pragma mark -
#pragma mark fb delegate



// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void)performPublishAction:(void(^)(void))action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
    
}


// Post Status Update button handler; will attempt different approaches depending upon configuration.
- (IBAction)postStatusUpdateClick:(UIButton *)sender {
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    
    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.
    
    // If it is available, we will first try to post using the share dialog in the Facebook app
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
                                                          name:@"Hello Facebook"
                                                       caption:nil
                                                   description:@"The 'Hello Facebook' sample application showcases simple Facebook integration."
                                                       picture:nil
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                           if (error) {
                                                               NSLog(@"Error: %@", error.description);
                                                           } else {
                                                               NSLog(@"Success!");
                                                           }
                                                       }];
    
    if (!appCall) {
        // Next try to post using Facebook's iOS6 integration
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                              initialText:nil
                                                                                    image:nil
                                                                                      url:urlToShare
                                                                                  handler:nil];
        
        if (!displayedNativeDialog) {
            // Lastly, fall back on a request for permissions and a direct post using the Graph API
            [self performPublishAction:^{
                
                //NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", self.loggedInUser.first_name, [NSDate date]];
                
                NSString *message = @"fb post message";
                
                FBRequestConnection *connection = [[FBRequestConnection alloc] init];
                
                connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
                | FBRequestConnectionErrorBehaviorAlertUser
                | FBRequestConnectionErrorBehaviorRetry;
                
                [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                     completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                         [self showAlert:message result:result error:error];
                         //self.buttonPostStatus.enabled = YES;
                     }];
                [connection start];
                
                //self.buttonPostStatus.enabled = NO;
            }];
        }
    }
}

// Post Photo button handler
- (IBAction)postPhotoClick:(UIButton *)sender {
    // Just use the icon image from the application itself.  A real app would have a more
    // useful way to get an image.
    UIImage *img = [UIImage imageNamed:@"road.jpg"];
    
    [self performPublishAction:^{
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
        | FBRequestConnectionErrorBehaviorAlertUser
        | FBRequestConnectionErrorBehaviorRetry;
        
        [connection addRequest:[FBRequest requestForUploadPhoto:img]
             completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                 [self showAlert:@"Photo Post" result:result error:error];
                 if (FBSession.activeSession.isOpen) {
                     //self.buttonPostPhoto.enabled = YES;
                 }
             }];
        [connection start];
        
        //self.buttonPostPhoto.enabled = NO;
    }];
}

// Pick Friends button handler
- (IBAction)pickFriendsClick:(UIButton *)sender {
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         
         NSString *message;
         
         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {
             
             NSMutableString *text = [[NSMutableString alloc] init];
             
             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 if ([text length]) {
                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
             }
             message = text;
         }
         
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}


-(void)fbLoginButtonInit
{
    // Create Login View so that the app will be granted "status_update" permission.
    //FBLoginView *loginview = [[FBLoginView alloc] init];
    _loginview = [[FBLoginView alloc] init];
    
    _loginview.frame = CGRectOffset(_loginview.frame, 5, 60);
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        _loginview.frame = CGRectOffset(_loginview.frame, 5, 25);
    }
#endif
#endif
#endif
    _loginview.delegate = self;
    
    [self.view addSubview:_loginview];
    
    [_loginview sizeToFit];
    _loginview.center = CGPointMake(self.view.center.x, _loginview.center.y);
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    /*
    // first get the buttons set for login mode
    self.buttonPostPhoto.enabled = YES;
    self.buttonPostStatus.enabled = YES;
    self.buttonPickFriends.enabled = YES;
    self.buttonPickPlace.enabled = YES;
    */
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    //[self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
    _labelfb.text = @"Post Status Update (Logged On)";
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    //self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    _labelfb.text = [NSString stringWithFormat:@"fb status: Logged On. Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    
    _profilePic.profileID = user.id;
    //self.loggedInUser = user;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    
    //BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    //BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    
    /*
    self.buttonPostStatus.enabled = canShareFB || canShareiOS6;
    self.buttonPostPhoto.enabled = NO;
    self.buttonPickFriends.enabled = NO;
    self.buttonPickPlace.enabled = NO;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    [self.buttonPostStatus setTitle:@"Post Status Update (Logged Off)" forState:self.buttonPostStatus.state];
    */
    _profilePic.profileID = nil;
    /*
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
    */
    
    _labelfb.text = @"fb status: Logged Off";
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}




#pragma mark -
#pragma mark xib function


-(IBAction)shareImageClick:(id)sender
{
    [self shareImageOnOtherApps:[UIImage imageNamed:@"centamapmobile.png"]];
    //[self shareImageOnOtherApps:[self captureView:self.view]];
}

-(IBAction)shareTextClick:(id)sender
{
    [self shareTextToOtherApps:@"http://hk.centamap.com"];
}

-(IBAction)fbLoginClick:(id)sender
{
    
}


#pragma mark -
#pragma mark share


-(void)shareTextToOtherApps:(NSString*)shareText
{
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", shareText]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

-(void)shareImageOnOtherApps:(UIImage*)shareImage
{
    //Remember Image must be larger than 612x612 size if not resize it.
    
    NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://app"];
    
    NSLog(@"shareImageOnOtherApps 1");
    
    if([[UIApplication sharedApplication] canOpenURL:whatsappURL])
    {
        NSLog(@"shareImageOnOtherApps 2");
        NSString *documentDirectory=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //NSString *saveImagePath=[documentDirectory stringByAppendingPathComponent:@"Image.ig"];
        //NSString *saveImagePath=[documentDirectory stringByAppendingPathComponent:@"Image.wai"];
        
        NSString *saveImagePath=[documentDirectory stringByAppendingPathComponent:@"centamapmobile.png"];
        //NSString *saveImagePath=[documentDirectory stringByAppendingPathComponent:@"centamapmobile.ig"];
        
        
        NSData *imageData=UIImagePNGRepresentation(shareImage);
        [imageData writeToFile:saveImagePath atomically:YES];
        
        NSURL *imageURL=[NSURL fileURLWithPath:saveImagePath];
        
        UIDocumentInteractionController *docController=[[UIDocumentInteractionController alloc]init];
        docController.delegate=self;
        [docController retain];
        //docController.UTI=@"com.instagram.photo";
        //docController.annotation=[NSDictionary dictionaryWithObjectsAndKeys:@"Image Taken via @App",@"InstagramCaption", nil];
        
        [docController setURL:imageURL];
        //[docController presentOpenInMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];  //Here try which one is suitable for u to present the doc Controller. if crash occurs
        [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
        
    }
    else
    {
        NSLog (@"share app not found");
        
    }
    
}

#pragma mark -
#pragma copy image

-(UIImage *)captureView:(UIView *)view
{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	UIGraphicsBeginImageContext(screenRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext(); [[UIColor blackColor] set]; CGContextFillRect(ctx, screenRect);
	[view.layer renderInContext:ctx];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}


#pragma mark -
#pragma show alert


// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}





@end
