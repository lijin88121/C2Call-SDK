//
//  SCBroadcastRecordingController.m
//  C2CallPhone
//
//  Created by Michael Knecht on 16/05/16.
//
//

#import "SCBroadcastRecordingController.h"
#import "SCBroadcastController.h"
#import "SCBroadcastStartController.h"
#import "SCBroadcastStatusController.h"
#import "C2CallPhone.h"
#import "SCMediaManager.h"

@interface SCBroadcastRecordingController () {
    BOOL        _toggleView;
}

@end

@implementation SCBroadcastRecordingController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.view.layer.sublayers count] == 0) {
        AVCaptureVideoPreviewLayer *preview = [SCMediaManager instance].previewLayer;
        
        if (preview) {
            preview.frame = self.view.bounds;
            [self.view.layer addSublayer:preview];
        }
    } else {
        AVCaptureVideoPreviewLayer *preview = (AVCaptureVideoPreviewLayer *)self.view.layer.sublayers[0];
        
        if (preview) {
            preview.frame = self.view.bounds;
        }
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SCBroadcastController class]]) {
        
        self.broadcastController = (SCBroadcastController *) segue.destinationViewController;
        if (_broadcastGroupId)
            self.broadcastController.broadcastGroupId = _broadcastGroupId;
        
    }
    if ([segue.destinationViewController isKindOfClass:[SCBroadcastStatusController class]]) {
        self.broadcastStatusController = (SCBroadcastStatusController *) segue.destinationViewController;
        self.broadcastStatusController.recordingController = self;
        self.broadcastStatusController.view.alpha = 0.;
    }
    
    if ([segue.destinationViewController isKindOfClass:[SCBroadcastStartController class]]) {
        self.broadcastStartController = (SCBroadcastStartController *) segue.destinationViewController;
        self.broadcastStartController.recordingController = self;
        self.broadcastStatusController.view.alpha = 1.;
    }
}

-(void) setBroadcastGroupId:(NSString *)broadcastGroupId
{
    _broadcastGroupId = broadcastGroupId;
    self.broadcastController.broadcastGroupId = _broadcastGroupId;
}

-(void) startBroadcasting
{
    [[C2CallPhone currentPhone] callVideo:self.broadcastGroupId groupCall:YES];
    self.broadcastStartController.view.alpha = 0.;
}

-(void) stopBroadcasting
{
    [[C2CallPhone currentPhone] hangUp];
    [self closeBroadcasting];
}

-(void) closeBroadcasting
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)toggleBroadcastStatusController:(id)sender
{
    if (_toggleView)
        return;
    
    _toggleView = YES;
    
    if (self.broadcastStatusController.view.alpha == 0.) {
        [UIView animateWithDuration:0.5 animations:^{
            self.broadcastStatusController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            _toggleView = NO;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.broadcastStatusController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            _toggleView = NO;
        }];
    }
}

@end