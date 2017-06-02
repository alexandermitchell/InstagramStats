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
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [DataManager sharedManager];
    self.mapView.delegate = self;
    UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maxLikeButtonTapped)];
    
    UITapGestureRecognizer *commentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maxCommentButtonTapped)];
    
    [self.likeImage addGestureRecognizer:likeTap];
    
    [self.commentImage addGestureRecognizer:commentTap];
    
    //create annotations and add them to the map.
    for (Photo *photo in self.manager.currentUser.photos) {
        MyCustomPointAnnotation *point = [[MyCustomPointAnnotation alloc]init];
        point.coordinate = CLLocationCoordinate2DMake(photo.latitude, photo.longitude);
        point.myImage = [UIImage imageWithData:photo.image];
        point.likesNum = [NSString stringWithFormat:@"%hd",photo.likesNum];
        point.commentsNum = [NSString stringWithFormat:@"%hd",photo.commentsNum];
        [self.mapView addAnnotation:point];

    }
    
  //    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.466666666667, -0.375);
//    MKCoordinateSpan span = MKCoordinateSpanMake(2.5, 2.5);
//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    //[self.mapView setRegion:region animated:YES];
    
    self.mapView.showsUserLocation = NO;


}

- (void)maxLikeButtonTapped {
    double latitude = self.manager.currentUser.photos[0].latitude;
    double longitude = self.manager.currentUser.photos[0].longitude;
    int likesNum = (int)self.manager.currentUser.photos[0].likesNum;
    
    for (Photo *photo in self.manager.currentUser.photos) {
        if (photo.likesNum > likesNum) {
            latitude = photo.latitude;
            longitude = photo.longitude;
            likesNum = (int)photo.likesNum;
        }
    }
    
    //find max comment photo in manager.photos
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
        MKCoordinateSpan span = MKCoordinateSpanMake(2.5, 2.5);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [self.mapView setRegion:region animated:YES];
    
}

- (void)maxCommentButtonTapped {
    
    double latitude = self.manager.currentUser.photos[0].latitude;
    double longitude = self.manager.currentUser.photos[0].longitude;
    int commentsNum = (int)self.manager.currentUser.photos[0].commentsNum;
    
    for (Photo *photo in self.manager.currentUser.photos) {
        if (photo.commentsNum > commentsNum) {
            latitude = photo.latitude;
            longitude = photo.longitude;
            commentsNum = (int)photo.commentsNum;
        }
    }
    //find max comment photo in manager.photos
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
        MKCoordinateSpan span = MKCoordinateSpanMake(2.5, 2.5);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - MapView Delegate Methods

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
    
    //cast the annotation to your custom class so you can access its properties
    MyCustomPointAnnotation *customAnnotation = (MyCustomPointAnnotation *)view.annotation;
    //load customnib which holds the customCalloutView
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"CustomCalloutView" owner:nil options:nil];
    //there is only 1 view in the nib, grab the view item
    CustomCalloutView *calloutView = (CustomCalloutView *)views[0];
    
    //access the properties on your customAnnotation and use them to set the labels on the calloutView
    calloutView.likeLabel.text = customAnnotation.likesNum;
    calloutView.commentLabel.text = customAnnotation.commentsNum;
    
    //make rounded edges on the callout, because fancy stuff
    calloutView.layer.masksToBounds = YES;
    calloutView.layer.cornerRadius = 2.0;
    
    //center the callout to be over the annotationView
    calloutView.center = CGPointMake(view.bounds.size.width/2, -calloutView.bounds.size.height*0.52);
    [view addSubview:calloutView];
    
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
    
    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    if ([view isKindOfClass:[CustomMKAnnotationView class]]){
        
        for (UIView *subview in view.subviews) {
            
            [subview removeFromSuperview];
            
        }
        
        
    }
    
    
    //if view is kind of class - customMKAnnotationView) { for subview in view.subviews {subview removeFromSuperView}}}
}


@end
