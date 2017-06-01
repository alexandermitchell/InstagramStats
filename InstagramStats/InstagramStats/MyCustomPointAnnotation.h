//
//  MyCustomPointAnnotation.h
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-30.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyCustomPointAnnotation : NSObject <MKAnnotation>

@property (nonatomic) UIImage *myImage;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *likesNum;
@property (nonatomic) NSString *commentsNum;

@end
