//
//  MainViewController.h
//  newfeatures
//
//  Created by admin on 2014/2/6.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MainViewController : UIViewController
<
UIDocumentInteractionControllerDelegate, CLLocationManagerDelegate, FBLoginViewDelegate
>

@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain) IBOutlet UILabel *labelfb;
@property (nonatomic, retain) IBOutlet UILabel *labelLoc;
@property (nonatomic, retain) IBOutlet UILabel *labelRegion;
@property (nonatomic, retain) IBOutlet UILabel *labelBeacons;
@property (nonatomic, retain) CLBeaconRegion *BeaconRegion;
@property (nonatomic, retain) FBLoginView *loginview;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;

@end
