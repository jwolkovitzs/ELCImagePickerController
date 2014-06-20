//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import "rpmHeader.h"

@implementation ELCImagePickerController

//Using auto synthesizers

- (id)initImagePicker
{
    ELCAlbumPickerController *albumPicker = [[ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    
    self = [super initWithRootViewController:albumPicker];
    if (self) {

        self.maximumImagesCount = 4;
        self.returnIndividualImages = NO;
        self.returnRefsOnly = NO;
        [albumPicker setParent:self];
        if (!isPad && floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0 &&
            [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait)
        {
            [self setNavigationBarHidden:YES];
        }
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.maximumImagesCount = 4;
    }
    return self;
}

- (void)cancelImagePicker
{
	if ([_imagePickerDelegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[_imagePickerDelegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    BOOL shouldSelect = previousCount < self.maximumImagesCount;
    return shouldSelect;
}

- (void)selectedAssets:(NSArray *)assets
{
    @autoreleasepool {        
        [_imagePickerDelegate elcImagePickerControllerDoneButtonHit:self selectedAssets:assets];
        if (self.returnRefsOnly)
        {
            return;
        }
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue,^{
            if (!self.returnRefsOnly)
            {
                for(ALAsset *asset in assets) {
                    @autoreleasepool {
                        id obj = [asset valueForProperty:ALAssetPropertyType];
                        if (!obj) {
                            continue;
                        }
                        NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
                        
                        CLLocation* wgs84Location = [asset valueForProperty:ALAssetPropertyLocation];
                        if (wgs84Location) {
                            [workingDictionary setObject:wgs84Location forKey:ALAssetPropertyLocation];
                        }
                        
                        [workingDictionary setObject:obj forKey:UIImagePickerControllerMediaType];
                        
                        //This method returns nil for assets from a shared photo stream that are not yet available locally. If the asset becomes available in the future, an ALAssetsLibraryChangedNotification notification is posted.
                        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                        
                        if(assetRep != nil) {
                            CGImageRef imgRef = nil;
                            //defaultRepresentation returns image as it appears in photo picker, rotated and sized,
                            //so use UIImageOrientationUp when creating our image below.
                            UIImageOrientation orientation = UIImageOrientationUp;
                            
                            if (_returnsOriginalImage) {
                                imgRef = [assetRep fullResolutionImage];
                                orientation = [assetRep orientation];
                            } else {
                                imgRef = [assetRep fullScreenImage];
                            }
                            UIImage *img = [UIImage imageWithCGImage:imgRef
                                                               scale:1.0f
                                                         orientation:orientation];
                            [workingDictionary setObject:img forKey:UIImagePickerControllerOriginalImage];
                            [workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:UIImagePickerControllerReferenceURL];
                            if (self.returnIndividualImages)
                            {
                                [self timeRelease:workingDictionary];
                                workingDictionary = nil;
                            }
                            else
                            {
                                [returnArray addObject:workingDictionary];
                            }
                        }
                        workingDictionary = nil;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_imagePickerDelegate != nil && [_imagePickerDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
                    [_imagePickerDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:returnArray];
                } else {
                    [self popToRootViewControllerAnimated:NO];
                }
            });
        });
    }
}

- (void)timeRelease:(NSDictionary*)workingDictionary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_imagePickerDelegate != nil && [_imagePickerDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithIndividualInfo:)]) {
            [_imagePickerDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithIndividualInfo:) withObject:self withObject:workingDictionary];
        }
    });
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger supportedOrientations = 0;
    
    if (!isPad)
    {
        supportedOrientations = UIInterfaceOrientationMaskPortrait;
    }
    else
    {
        supportedOrientations = UIInterfaceOrientationMaskAll;
    }
    
    return supportedOrientations;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    BOOL shouldAutorotate = YES;
    
    if (!isPad && toInterfaceOrientation != UIInterfaceOrientationPortrait)
    {
        shouldAutorotate = NO;
    }
    
    return shouldAutorotate;
}


@end
