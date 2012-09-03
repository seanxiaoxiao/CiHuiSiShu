//
//  TipsBubble.h
//  GT's Doraemon
//
//  Created by So Gavin on 12/4/11.
//  Copyright (c) 2011 GeFo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	tipsBubblePopupFromUpperLeft,
	tipsBubblePopupFromUpperCenter,
	tipsBubblePopupFromUpperRight,
	tipsBubblePopupFromLowerLeft,
	tipsBubblePopupFromLowerCenter,
	tipsBubblePopupFromLowerRight,
	tipsBubblePopupFromLeftTop,
	tipsBubblePopupFromLeftMiddle,
	tipsBubblePopupFromLeftBottom,
	tipsBubblePopupFromRightTop,
	tipsBubblePopupFromRightMiddle,
	tipsBubblePopupFromRightBottom
} TipsBubblePopupPlace;

@interface TipsBubble : UIView

- ( id ) initWithTips: ( NSString * ) tips width: ( CGFloat ) width popupFrom: ( TipsBubblePopupPlace ) place;


@end
