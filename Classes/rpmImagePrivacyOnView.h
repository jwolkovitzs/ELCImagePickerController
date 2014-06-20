//
//  rpmImagePrivacyOnView.h
//  rpmPadController
//
//  Created by Jason Wolkovitz on 2/20/14.
//
//

#import <UIKit/UIKit.h>

@interface rpmImagePrivacyOnView : UIView

@property (nonatomic, strong) UIImageView *lockImage;
@property (nonatomic, strong) UILabel *libLockedLabel;
@property (nonatomic, strong) UILabel *privacySettingsLabel;
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIView *lineView2;

- (id)initFrameForImageMainView:(CGRect)frame;
-(void) positionViewForOrientation;
-(void) setLockHiden:(BOOL)hide;
-(void) showLines;

@end
