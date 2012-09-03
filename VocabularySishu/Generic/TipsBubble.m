//
//  TipsBubble.m
//  GT's Doraemon
//
//  Created by So Gavin on 12/4/11.
//  Copyright (c) 2011 GeFo Studio. All rights reserved.
//

#import "TipsBubble.h"
#import <QuartzCore/QuartzCore.h>

#define borderGap			( 5 )
#define bubbleCornerRadius	( 5 )
#define arrowWidth			( 12 )
#define arrowHeight			( 6 )


@implementation TipsBubble

- ( id ) initWithTips: ( NSString * ) tips width: ( CGFloat ) width popupFrom: ( TipsBubblePopupPlace ) place {
    if ( ( self = [ super init ] ) ) {
		self.backgroundColor = [ UIColor clearColor ];
		UILabel *tipsLabel = [ [ UILabel alloc ] initWithFrame: CGRectMake ( borderGap, borderGap, width - borderGap * 2, 0 ) ];
		tipsLabel.textColor = [ UIColor colorWithHue: 0 saturation: 0 brightness: 0.2 alpha: 1 ];
		tipsLabel.font = [ UIFont systemFontOfSize: [ UIFont smallSystemFontSize ] ];
		tipsLabel.backgroundColor = [ UIColor clearColor ];
		tipsLabel.numberOfLines = 0;
		tipsLabel.text = [ NSString stringWithFormat: @"%@ %@", @"\ue10f", tips ];
		[ tipsLabel sizeToFit ];
		
		CGSize size = CGSizeMake ( width, tipsLabel.frame.size.height + borderGap * 2 );
		CGMutablePathRef path = CGPathCreateMutable ();
		CGPathMoveToPoint ( path, NULL, bubbleCornerRadius, 0 );
		if ( place == tipsBubblePopupFromUpperLeft ) {
			CGPathAddLineToPoint ( path, NULL, bubbleCornerRadius + arrowWidth / 2, -arrowHeight );
			CGPathAddLineToPoint ( path, NULL, bubbleCornerRadius + arrowWidth, 0 );
		} else if ( place == tipsBubblePopupFromUpperCenter ) {
			CGPathAddLineToPoint ( path, NULL, size.width / 2 - arrowWidth / 2, 0 );
			CGPathAddLineToPoint ( path, NULL, size.width / 2, -arrowHeight );
			CGPathAddLineToPoint ( path, NULL, size.width / 2 + arrowWidth / 2, 0 );
		} else if ( place == tipsBubblePopupFromUpperRight ) {
			CGPathAddLineToPoint ( path, NULL, size.width - bubbleCornerRadius - arrowWidth, 0 );
			CGPathAddLineToPoint ( path, NULL, size.width - bubbleCornerRadius - arrowWidth / 2, -arrowHeight );
		}
		CGPathAddLineToPoint ( path, NULL, size.width - bubbleCornerRadius, 0 );
		CGPathAddArc ( path, NULL, size.width - bubbleCornerRadius, bubbleCornerRadius, bubbleCornerRadius, -M_PI_2, 0, NO );
		if ( place == tipsBubblePopupFromRightTop ) {
			CGPathAddLineToPoint ( path, NULL, size.width + arrowHeight, bubbleCornerRadius + arrowWidth / 2 );
			CGPathAddLineToPoint ( path, NULL, size.width, bubbleCornerRadius + arrowWidth );
		} else if ( place == tipsBubblePopupFromRightMiddle ) {
			CGPathAddLineToPoint ( path, NULL, size.width, size.height / 2 - arrowWidth / 2 );
			CGPathAddLineToPoint ( path, NULL, size.width + arrowHeight, size.height / 2 );
			CGPathAddLineToPoint ( path, NULL, size.width, size.height / 2 + arrowWidth / 2 );
		} else if ( place == tipsBubblePopupFromRightBottom ) {
			CGPathAddLineToPoint ( path, NULL, size.width, size.height - bubbleCornerRadius - arrowWidth );
			CGPathAddLineToPoint ( path, NULL, size.width + arrowHeight, size.height - bubbleCornerRadius - arrowWidth / 2 );
		}
		CGPathAddLineToPoint ( path, NULL, size.width, size.height - bubbleCornerRadius );
		CGPathAddArc ( path, NULL, size.width - bubbleCornerRadius, size.height - bubbleCornerRadius, bubbleCornerRadius, 0, M_PI_2, NO );
		if ( place == tipsBubblePopupFromLowerRight ) {
			CGPathAddLineToPoint ( path, NULL, size.width - bubbleCornerRadius - arrowWidth / 2, size.height + arrowHeight );
			CGPathAddLineToPoint ( path, NULL, size.width - bubbleCornerRadius - arrowWidth, size.height );
		} else if ( place == tipsBubblePopupFromLowerCenter ) {
			CGPathAddLineToPoint ( path, NULL, size.width / 2 + arrowWidth / 2, size.height );
			CGPathAddLineToPoint ( path, NULL, size.width / 2, size.height + arrowHeight );
			CGPathAddLineToPoint ( path, NULL, size.width / 2 - arrowWidth / 2, size.height );
		} else if ( place == tipsBubblePopupFromLowerLeft ) {
			CGPathAddLineToPoint ( path, NULL, bubbleCornerRadius + arrowWidth, size.height );
			CGPathAddLineToPoint ( path, NULL, bubbleCornerRadius + arrowWidth / 2, size.height + arrowHeight );
		}
		CGPathAddLineToPoint ( path, NULL, bubbleCornerRadius, size.height );
		CGPathAddArc ( path, NULL, bubbleCornerRadius, size.height - bubbleCornerRadius, bubbleCornerRadius, M_PI_2, M_PI, NO );
		if ( place == tipsBubblePopupFromLeftBottom ) {
			CGPathAddLineToPoint ( path, NULL, -arrowHeight, size.height - bubbleCornerRadius - arrowWidth / 2 );
			CGPathAddLineToPoint ( path, NULL, 0, size.height - bubbleCornerRadius - arrowWidth );
		} else if ( place == tipsBubblePopupFromLeftMiddle ) {
			CGPathAddLineToPoint ( path, NULL, 0, size.height / 2 + arrowWidth / 2 );
			CGPathAddLineToPoint ( path, NULL, -arrowHeight, size.height / 2 );
			CGPathAddLineToPoint ( path, NULL, 0, size.height / 2 - arrowWidth / 2 );
		} else if ( place == tipsBubblePopupFromLeftTop ) {
			CGPathAddLineToPoint ( path, NULL, 0, bubbleCornerRadius + arrowWidth );
			CGPathAddLineToPoint ( path, NULL, -arrowHeight, bubbleCornerRadius + arrowWidth / 2 );
		}
		CGPathAddLineToPoint ( path, NULL, 0, bubbleCornerRadius );
		CGPathAddArc ( path, NULL, bubbleCornerRadius, bubbleCornerRadius, bubbleCornerRadius, M_PI, -M_PI_2, NO );
		
		CAShapeLayer *bubble = [ CAShapeLayer layer ];
		bubble.strokeColor = [ UIColor colorWithHue: 0 saturation: 0 brightness: 0.4 alpha: 1 ].CGColor;
		bubble.fillColor = [ UIColor colorWithRed: 0.98 green: 0.98 blue: 0.78 alpha: 0.7 ].CGColor;
		bubble.lineWidth = 1;
		bubble.path = path;
		CGPathRelease ( path );
		
		[ self.layer addSublayer: bubble ];
		[ self addSubview: tipsLabel ];
    }
    return self;
}


@end
