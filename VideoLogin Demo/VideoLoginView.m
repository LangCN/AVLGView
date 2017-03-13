//
//  VideoLoginView.m
//  VideoLogin Demo
//
//  Created by linchao on 16/3/13.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "VideoLoginView.h"

@implementation VideoLoginView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player
{
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [layer setPlayer:player];
}

@end
