//
//  QRCodeView.m
//  security
//
//  Created by sen5labs on 15/9/30.
//  Copyright © 2015年 sen5. All rights reserved.
//  扫描

#import "QRCodeView.h"
#import <AVFoundation/AVFoundation.h>
#import "ORCodeAnimateView.h"

#define AnimationDuration 1.5

@interface QRCodeView () <AVCaptureMetadataOutputObjectsDelegate> {
    NSTimer * _timer;
}

@property (nonatomic, assign) BOOL isReading;



@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) ORCodeAnimateView * viewPreview;

@property (nonatomic, copy) CompleteBlock block;

@end

@implementation QRCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - public
- (BOOL)startReadingWithCompletBlock:(CompleteBlock)block {
    self.block = [block copy];
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    _captureSession = [[AVCaptureSession alloc] init];
    
    
    if (input) {
        NSLog(@"%@", [error localizedDescription]);
        [_captureSession addInput:input];
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_captureSession addOutput:captureMetadataOutput];
        
        
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("myQueue", NULL);
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    }
    //show to user what the camera of the device sees  using a AVCaptureVideoPreviewLayer
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.viewPreview.layer.bounds];
    [self.layer addSublayer:_videoPreviewLayer];
    
    [self bringSubviewToFront:self.viewPreview];
    
//    NSLog(@"%@ R%@",NSStringFromCGRect(self.viewPreview.bounds),NSStringFromCGRect(_videoPreviewLayer.bounds));
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)stopReading {
    [self stopMove];
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    [self.viewPreview removeFromSuperview];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.block(metadataObj.stringValue);
            });
            _isReading = NO;
        }
    }
}

#pragma mark - private
- (void)setupUI {
    
    [self addSubview:self.viewPreview];
}

- (void)stopMove {
    [_timer invalidate];
    _timer = nil;
}

- (UIView *)viewPreview {
    if (!_viewPreview) {
        ORCodeAnimateView *viewPreView = [[ORCodeAnimateView alloc] init];
        viewPreView.frame = self.bounds;
        _viewPreview = viewPreView;
    }
    return _viewPreview ;
}

-(void )setRecommands:(NSString *)recommands
{
   // [self.viewPreview setRecommands:recommands];
}

@end
