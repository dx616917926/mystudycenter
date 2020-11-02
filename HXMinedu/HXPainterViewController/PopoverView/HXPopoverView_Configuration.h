//
//  PopoverView_Configuration.h
//  popover
//
//  Created by Bas Pellis on 12/25/12.
//  Copyright (c) 2012 Oliver Rickard. All rights reserved.
//

#pragma mark Constants - Configure look/feel

// BOX GEOMETRY

//Height/width of the actual arrow
#define HX_kArrowHeight 12.f

//padding within the box for the contentView
#define HX_kBoxPadding 10.f

//control point offset for rounding corners of the main popover box
#define HX_kCPOffset 1.8f

//radius for the rounded corners of the main popover box
#define HX_kBoxRadius 4.f

//Curvature value for the arrow.  Set to 0.f to make it linear.
#define HX_kArrowCurvature 6.f

//Minimum distance from the side of the arrow to the beginning of curvature for the box
#define HX_kArrowHorizontalPadding 5.f

//Alpha value for the shadow behind the PopoverView
#define HX_kShadowAlpha 0.4f

//Blur for the shadow behind the PopoverView
#define HX_kShadowBlur 3.f;

//Box gradient bg alpha
#define HX_kBoxAlpha 0.95f

//Padding along top of screen to allow for any nav/status bars
#define HX_kTopMargin 50.f

//margin along the left and right of the box
#define HX_kHorizontalMargin 10.f

//padding along top of icons/images
#define HX_kImageTopPadding 3.f

//padding along bottom of icons/images
#define HX_kImageBottomPadding 3.f


// DIVIDERS BETWEEN VIEWS

//Bool that turns off/on the dividers
#define HX_kShowDividersBetweenViews NO

//color for the divider fill
#define HX_kDividerColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:0.15f]


// BACKGROUND GRADIENT

//bottom color white in gradient bg
#define HX_kGradientBottomColor [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:HX_kBoxAlpha]

//top color white value in gradient bg
#define HX_kGradientTopColor [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:HX_kBoxAlpha]


// TITLE GRADIENT

//bool that turns off/on title gradient
#define HX_kDrawTitleGradient YES

//bottom color white value in title gradient bg
#define HX_kGradientTitleBottomColor [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:HX_kBoxAlpha]

//top color white value in title gradient bg
#define HX_kGradientTitleTopColor [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:HX_kBoxAlpha]


// FONTS

//normal text font
#define HX_kTextFont [UIFont fontWithName:@"HelveticaNeue" size:16.f]

//normal text color
#define HX_kTextColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1]
// highlighted text color
#define HX_kTextHighlightColor [UIColor colorWithRed:0.098 green:0.102 blue:0.106 alpha:1.000]

//normal text alignment
#define HX_kTextAlignment UITextAlignmentCenter

//title font
#define HX_kTitleFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f]

//title text color
#define HX_kTitleColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1]


// BORDER

//bool that turns off/on the border
#define HX_kDrawBorder NO

//border color
#define HX_kBorderColor [UIColor blackColor]

//border width
#define HX_kBorderWidth 1.f