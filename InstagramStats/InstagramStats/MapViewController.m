//
//  MapViewController.m
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-30.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "MapViewController.h"
@import MapKit;
#import "DataManager.h"
#import "Photo+CoreDataProperties.h"
#import "User+CoreDataProperties.h"
#import "MyCustomPointAnnotation.h"
#import "CustomMKAnnotationView.h"
#import "CustomCalloutView.h"

@interface MapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) DataManager *manager;
@property (nonatomic) NSMutableArray <MyCustomPointAnnotation *> *annotations;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [DataManager sharedManager];
    self.mapView.delegate = self;
    self.annotations = [[NSMutableArray alloc]init];
    
    for (Photo *photo in self.manager.currentUser.photos) {
        MyCustomPointAnnotation *point = [[MyCustomPointAnnotation alloc]init];
        point.coordinate = CLLocationCoordinate2DMake(photo.latitude, photo.longitude);
        point.myImage = [UIImage imageWithData:photo.image];
        point.likesNum = [NSString stringWithFormat:@"%hd",photo.likesNum];
        point.commentsNum = [NSString stringWithFormat:@"%hd",photo.commentsNum];
        [self.mapView addAnnotation:point];
        [self.annotations addObject:point];
    }
    
    //zooms in on specific photo that is hardcoded below (since not every annotation has a valid coordinate at this point)
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.466666666667, -0.375);
//    MKCoordinateSpan span = MKCoordinateSpanMake(12.5, 12.5);
//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    self.mapView.showsUserLocation = NO;
    //[self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    CustomMKAnnotationView *pin = (CustomMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    
    if (pin == nil) {
        pin = [[CustomMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        pin.canShowCallout = NO;
    } else {
        pin.annotation = annotation;
    }
    
    MyCustomPointAnnotation *pointAnnotation = (MyCustomPointAnnotation *)annotation;

    //reduce image size to prevent MKAnnotationView's view from resizing to accomodate the full sized image
    UIImage *pinImage = pointAnnotation.myImage;
    CGSize size = CGSizeMake(50, 50);
    UIGraphicsBeginImageContext(size);
    [pinImage drawInRect:(CGRectMake(0, 0, size.width, size.height))];
    UIImage *resizedPin = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    pin.image = resizedPin;
    

    [self.mapView addSubview:pin];
    
    
    return pin;

}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
//    if (view.annotation isEqual:MKUserLocation) {
//        return
//    }
    
    MyCustomPointAnnotation *customAnnotation = (MyCustomPointAnnotation *)view.annotation;
    
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"CustomCalloutView" owner:nil options:nil];
    CustomCalloutView *calloutView = (CustomCalloutView *)views[0];
    if (customAnnotation.likesNum != nil) {
    calloutView.likeLabel.text = customAnnotation.likesNum;
    } else {
        calloutView.likeLabel.text = @"0";
    }
    calloutView.commentLabel.text = customAnnotation.commentsNum;
    calloutView.center = CGPointMake(view.bounds.size.width/2, calloutView.bounds.size.height);
    [view addSubview:calloutView];
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
    
    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    //if view is kind of class - customMKAnnotationView) { for subview in view.subviews {subview removeFromSuperView}}}
}


@end
