//
//  MyBubbles.m
//  dinG
//
//  Created by iPhones on 9/19/15.
//  Copyright (c) 2015 ps. All rights reserved.
//

#import "MyBubbles.h"

@implementation MyBubbles


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//-(void)drawRect:(CGRect)rect {
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //CGContextSetRGBFillColor(ctx, 0.0, 0.0, 1.0, 1.0);
//    CGContextSetRGBFillColor(ctx, self.Red, self.Green, self.Blue, 1);
//    CGContextFillEllipseInRect(ctx, CGRectMake(0.0, 0.0, self.ovalSize.width,self.ovalSize.height)); //oval shape
//    CGContextBeginPath(ctx);
//    CGContextMoveToPoint(ctx, 8.0, 40.0);
//    CGContextAddLineToPoint(ctx, 6.0, 50.0);
//    CGContextAddLineToPoint(ctx, 18.0, 45.0);
//    CGContextClosePath(ctx);
//    CGContextFillPath(ctx);
//}

-(void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect aRect = CGRectMake(2.0, 2.0, (self.bounds.size.width * 0.95f), (self.bounds.size.width * 0.60f)); // set the rect with inset.
    CGContextSetRGBFillColor(ctx, self.Red, self.Green, self.Blue, 1.0); //white fill
    CGContextSetRGBStrokeColor(ctx, self.Red, self.Green, self.Blue, 1.0); //black stroke
    CGContextSetLineWidth(ctx, 2.0);
    // As a bonus, we'll combine arcs to create a round rectangle!
    
    // Drawing with a white stroke color
   
    
    
    // If you were making this as a routine, you would probably accept a rectangle
    // that defines its bounds, and a radius reflecting the "rounded-ness" of the rectangle.
   
    CGFloat radius = 10.0;
    // NOTE: At this point you may want to verify that your radius is no more than half
    // the width and height of your rectangle, as this technique degenerates for those cases.
    
    // In order to draw a rounded rectangle, we will take advantage of the fact that
    // CGContextAddArcToPoint will draw straight lines past the start and end of the arc
    // in order to create the path from the current position and the destination position.
    
    // In order to create the 4 arcs correctly, we need to know the min, mid and max positions
    // on the x and y lengths of the given rectangle.
    CGFloat minx = CGRectGetMinX(aRect), midx = CGRectGetMidX(aRect), maxx = CGRectGetMaxX(aRect);
    CGFloat miny = CGRectGetMinY(aRect), midy = CGRectGetMidY(aRect), maxy = CGRectGetMaxY(aRect);
    
    // Next, we will go around the rectangle in the order given by the figure below.
    //       minx    midx    maxx
    // miny    2       3       4
    // midy   1 9              5
    // maxy    8       7       6
    // Which gives us a coincident start and end point, which is incidental to this technique, but still doesn't
    // form a closed path, so we still need to close the path to connect the ends correctly.
    // Thus we start by moving to point 1, then adding arcs through each pair of points that follows.
    // You could use a similar tecgnique to create any shape with rounded corners.
    
    // Start at 1
    CGContextMoveToPoint(ctx, minx, midy);
    // Add an arc through 2 to 3
    CGContextAddArcToPoint(ctx, minx, miny, midx, miny, radius);
    // Add an arc through 4 to 5
    CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, radius);
    // Add an arc through 6 to 7
    CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, radius);
    // Add an arc through 8 to 9
    CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, radius);
    // Close the path 
    CGContextClosePath(ctx);
    // Fill & stroke the path 
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    //CGContextFillEllipseInRect(ctx, aRect);
    //CGContextStrokeEllipseInRect(ctx, aRect);
    //CGContextFillRect(ctx, aRect);
   // CGContextStrokeRect(ctx, aRect);
//    CGContextBeginPath(ctx);
//    CGContextMoveToPoint(ctx, (self.bounds.size.width * 0.10), (self.bounds.size.width * 0.70f));
//    CGContextAddLineToPoint(ctx, 40.0, (self.bounds.size.height *0.80f));
//    CGContextAddLineToPoint(ctx, 20.0, (self.bounds.size.height *0.70f));
//    CGContextClosePath(ctx);
//    CGContextFillPath(ctx);
//    
//    CGContextBeginPath(ctx);
//    CGContextMoveToPoint(ctx, (self.bounds.size.width * 0.10), (self.bounds.size.width * 0.48f));
//    CGContextAddLineToPoint(ctx, 40.0, (self.bounds.size.height *0.80f));
//    CGContextStrokePath(ctx);
//    
//    CGContextBeginPath(ctx);
//    CGContextMoveToPoint(ctx, 40.0, (self.bounds.size.height *0.80f));
//    CGContextAddLineToPoint(ctx, 20.0, (self.bounds.size.height *0.70f));
//    CGContextStrokePath(ctx);
    
   // CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    CGContextMoveToPoint(ctx, self.bounds.size.width-10, self.bounds.size.height-30);
//    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
//    CGContextAddLineToPoint(ctx, self.bounds.size.width+20, self.bounds.size.height);
//    CGContextAddLineToPoint(ctx, self.bounds.size.width-10, self.bounds.size.width-30);
//    CGContextSetRGBFillColor(ctx, self.Red, self.Green, self.Blue, 1);
//    CGContextFillPath(ctx);
}

//-(void)drawRect:(CGRect)rect
//{
//    UIColor *MyPopupLayer = [UIColor colorWithRed:self.Red green:self.Green blue:self.Blue alpha:1];
//    CGRect currentFrame = self.bounds;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineJoin(context, kCGLineJoinRound);
//    CGContextSetLineWidth(context, 2);
//    CGContextSetStrokeColorWithColor(context, MyPopupLayer.CGColor);
//    CGContextSetFillColorWithColor(context,  MyPopupLayer.CGColor);
//
//    // Draw and fill the bubble
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 5 + 2 + 0.5f, 2 + 30 + 0.5f);
//    CGContextAddLineToPoint(context, round(currentFrame.size.width / 2.0f - 30 / 2.0f) + 0.5f, 30 + 2 + 0.5f);
//    CGContextAddLineToPoint(context, round(currentFrame.size.width / 2.0f) + 0.5f, 2 + 0.5f);
//    CGContextAddLineToPoint(context, round(currentFrame.size.width / 2.0f + 30 / 2.0f) + 0.5f, 30 + 2 + 0.5f);
//    CGContextAddArcToPoint(context, currentFrame.size.width - 2 - 0.5f, 2 + 30 + 0.5f, currentFrame.size.width - 2 - 0.5f, currentFrame.size.height - 2 - 0.5f, 5 - 2);
//    CGContextAddArcToPoint(context, currentFrame.size.width - 2 - 0.5f, currentFrame.size.height - 2 - 0.5f, round(currentFrame.size.width / 2.0f + 30 / 2.0f) - 2 + 0.5f, currentFrame.size.height - 2 - 0.5f, 5 - 2);
//    CGContextAddArcToPoint(context, 2 + 0.5f, currentFrame.size.height - 2 - 0.5f, 2 + 0.5f, 30 + 2 + 0.5f, 5 - 2);
//    CGContextAddArcToPoint(context, 2 + 0.5f, 2 + 30 + 0.5f, currentFrame.size.width - 2 - 0.5f, 30 + 2 + 0.5f, 5 - 2);
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke);
//    
//    // Draw a clipping path for the fill
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 5 + 2 + 0.5f, round((currentFrame.size.height + 30) * 0.50f) + 0.5f);
//    CGContextAddArcToPoint(context, currentFrame.size.width - 2 - 0.5f, round((currentFrame.size.height + 30) * 0.50f) + 0.5f, currentFrame.size.width - 2 - 0.5f, currentFrame.size.height - 2 - 0.5f, 5 - 2);
//    CGContextAddArcToPoint(context, currentFrame.size.width - 2 - 0.5f, currentFrame.size.height - 2 - 0.5f, round(currentFrame.size.width / 2.0f + 30 / 2.0f) - 2 + 0.5f, currentFrame.size.height - 2 - 0.5f, 5 - 2);
//    CGContextAddArcToPoint(context, 2 + 0.5f, currentFrame.size.height - 2 - 0.5f, 2 + 0.5f, 30 + 2+ 0.5f, 5 - 2);
//    CGContextAddArcToPoint(context, 2 + 0.5f, round((currentFrame.size.height + 30) * 0.50f) + 0.5f, currentFrame.size.width - 2 - 0.5f, round((currentFrame.size.height + 30) * 0.50f) + 0.5f, 5 - 2);
//    CGContextClosePath(context);
//    CGContextClip(context);
//}

@end
