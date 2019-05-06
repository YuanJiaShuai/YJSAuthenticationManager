//
//  AuthPopController.h
//  TestDemo
//
//  Created by yjs on 2019/4/30.
//  Copyright © 2019 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthPopController : UIPresentationController

@property (copy, nonatomic) void(^dismissBlock)(void);

@end

NS_ASSUME_NONNULL_END
