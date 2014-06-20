//
//  rpmImagePrivacyOnView.m
//  rpmPadController
//
//  Created by Jason Wolkovitz on 2/20/14.
//
//

#import "rpmImagePrivacyOnView.h"
#import "rpmHeader.h"

@implementation rpmImagePrivacyOnView
{
    BOOL imageMainView;
}

- (id)initFrameForImageMainView:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        imageMainView = YES;
        [self setupSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSelf];
    }
    return self;
}

-(void) setupSelf
{
    [self setUserInteractionEnabled:NO];
    self.lockImage = [[UIImageView alloc]init];

    self.libLockedLabel = [[UILabel alloc]init];
    [self.libLockedLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [self.libLockedLabel setTextColor: [UIColor colorWithRed:131/255.0 green:135.0/255.0 blue:149.0/255.0 alpha:1.0]];
    [self.libLockedLabel setText:NSLocalizedString(@"This app does not have access to your photos.", @"photo lib locked")];
    self.libLockedLabel.numberOfLines = 0;
    self.libLockedLabel.textAlignment = NSTextAlignmentCenter;
    self.libLockedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.libLockedLabel.backgroundColor = [UIColor clearColor];
    
    self.privacySettingsLabel = [[UILabel alloc]init];
    [self.privacySettingsLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.privacySettingsLabel setTextColor:[UIColor colorWithRed:131/255.0 green:135.0/255.0 blue:149.0/255.0 alpha:1.0]];
    [self.privacySettingsLabel setText:NSLocalizedString(@"You can enable access in Privacy Settings.", @"photo lib locked")];
    self.privacySettingsLabel.numberOfLines = 0;
    self.privacySettingsLabel.textAlignment = NSTextAlignmentCenter;
    self.privacySettingsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.privacySettingsLabel.backgroundColor = [UIColor clearColor];

    [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self positionViewForOrientation];
    [self addViews];
}

-(void) positionViewForOrientation
{
    if (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) ||
        ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) || isPad)
    {
        NSString *lockImageName;
        lockImageName = @"PLLock-Portrait.png";
        [self.lockImage setImage:[UIImage imageNamed:lockImageName]];
        self.lockImage.clipsToBounds = YES;
        [self.lockImage sizeToFit];

        [self.lockImage setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height * ((isPad && imageMainView) ? 0.225 : 0.3))];
        [self.lockImage setFrame:CGRectMake(floorf(self.lockImage.frame.origin.x), floorf(self.lockImage.frame.origin.y), self.lockImage.frame.size.width, self.lockImage.frame.size.height)];
        
        [self.libLockedLabel sizeToFit];
        [self.libLockedLabel setCenter:CGPointMake(self.frame.size.width / 2,
                                                   self.frame.size.height * 0.3
                                                   + self.lockImage.frame.size.height / 2
                                                   + self.libLockedLabel.frame.size.height * 2)];
        [self.libLockedLabel setFrame:CGRectIntegral(CGRectMake(10, self.libLockedLabel.frame.origin.y, self.frame.size.width - 20, self.libLockedLabel.frame.size.height * 2))];
        
        [self.privacySettingsLabel sizeToFit];
        [self.privacySettingsLabel setCenter:CGPointMake(self.frame.size.width / 2, self.libLockedLabel.frame.origin.y + self.libLockedLabel.frame.size.height + self.privacySettingsLabel.frame.size.height)];
        [self.privacySettingsLabel setFrame:CGRectIntegral(CGRectMake(5, self.privacySettingsLabel.frame.origin.y, self.frame.size.width - 10, self.privacySettingsLabel.frame.size.height * 2))];
    }
    else
    {
        NSString *lockImageName;
        lockImageName = @"PLLock-Landscape.png";
        [self.lockImage setImage:[UIImage imageNamed:lockImageName]];
        [self.lockImage sizeToFit];
        self.lockImage.clipsToBounds = YES;

        [self.lockImage setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.25)];
        [self.lockImage setFrame:CGRectMake(floorf(self.lockImage.frame.origin.x), floorf(self.lockImage.frame.origin.y), self.lockImage.frame.size.width, self.lockImage.frame.size.height)];        [self addSubview:self.lockImage];

        [self.libLockedLabel setFrame:CGRectIntegral(CGRectMake(10, self.libLockedLabel.frame.origin.y, self.frame.size.width - 20, self.libLockedLabel.frame.size.height))];
        [self.libLockedLabel sizeToFit];
        [self.libLockedLabel setCenter:CGPointMake(self.frame.size.width / 2, self.lockImage.frame.origin.y - self.libLockedLabel.frame.size.height /2 + self.lockImage.frame.size.height + self.libLockedLabel.frame.size.height *  2)];
        [self.libLockedLabel setFrame:CGRectIntegral(CGRectMake(10, self.libLockedLabel.frame.origin.y, self.frame.size.width - 20, self.libLockedLabel.frame.size.height))];
        
        [self.privacySettingsLabel sizeToFit];
        [self.privacySettingsLabel setCenter:CGPointMake(self.frame.size.width / 2, self.libLockedLabel.frame.origin.y + self.libLockedLabel.frame.size.height + self.privacySettingsLabel.frame.size.height)];
        [self.privacySettingsLabel setFrame:CGRectIntegral(CGRectMake(5, self.privacySettingsLabel.frame.origin.y, self.frame.size.width - 10, self.privacySettingsLabel.frame.size.height * 2))];
    }
    if (self.blurView)
    {
        CGFloat screenPixel = 1 / [UIScreen mainScreen].scale;

        [self.blurView setFrame: CGRectIntegral(CGRectMake(0,
                                                           self.libLockedLabel.frame.origin.y - 10,
                                                           self.frame.size.width,
                                                           self.privacySettingsLabel.frame.origin.y +
                                                           self.privacySettingsLabel.frame.size.height +
                                                           -
                                                           (self.libLockedLabel.frame.origin.y - self.libLockedLabel.frame.size.height / 2)))];
        [self.lineView1 setFrame:CGRectMake(0,
                                            0,
                                            self.blurView.frame.size.width,
                                            screenPixel)];
        [self.lineView2 setFrame:CGRectMake(0,
                                            CGRectGetHeight(self.blurView.frame),
                                            self.blurView.frame.size.width,
                                            screenPixel)];
    }
}

-(void)addViews
{
    [self addSubview:self.lockImage];
    [self addSubview:self.libLockedLabel];
    [self addSubview:self.privacySettingsLabel];
}

-(void) setLockHiden:(BOOL)hide
{
    self.lockImage.hidden = hide;
}

-(void) showLines
{
    CGFloat screenPixel = 1 / [UIScreen mainScreen].scale;
    
    self.blurView = [[UIView alloc]initWithFrame:CGRectIntegral(CGRectMake(0,
                                                                           self.libLockedLabel.frame.origin.y - 10,
                                                                           self.frame.size.width,
                                                                           self.privacySettingsLabel.frame.origin.y +
                                                                           self.privacySettingsLabel.frame.size.height +
                                                                           -
                                                                           (self.libLockedLabel.frame.origin.y - self.libLockedLabel.frame.size.height / 2)))];
    [self.blurView setBackgroundColor:[UIColor whiteColor]];
    [self.blurView setAlpha:0.7];
    [self addSubview:self.blurView];
    [self sendSubviewToBack:self.blurView];
    
    self.lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                             0,
                                                             self.blurView.frame.size.width,
                                                             screenPixel)];
    [self.lineView1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.blurView addSubview:self.lineView1];
    self.lineView1.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    self.lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                             CGRectGetHeight(self.blurView.frame),
                                                             self.blurView.frame.size.width,
                                                             screenPixel)];
    [self.lineView2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.blurView addSubview:self.lineView2];
    self.lineView2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self bringSubviewToFront:self.privacySettingsLabel];
    [self bringSubviewToFront:self.libLockedLabel];
    [self bringSubviewToFront:self.lineView2];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
