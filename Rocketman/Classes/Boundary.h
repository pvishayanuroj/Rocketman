//
//  Boundary.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/29/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class Obstacle;

@interface Boundary : NSObject {
  
	PVCollide collide_;
 
    id target_;
    
    SEL hitSel_;
    
    SEL collideSel_;
    
}

@property (nonatomic, assign) PVCollide collide;

+ (id) boundaryWithTarget:(Obstacle *)obstacle collide:(SEL)cSel hit:(SEL)hSel colStruct:(PVCollide)col;

- (id) initWithTarget:(Obstacle *)obstacle collide:(SEL)cSel hit:(SEL)hSel colStruct:(PVCollide)col;

- (BOOL) collisionCheckAndHandle:(CGPoint)objectPos rocketBox:(CGRect)rocketBox;

- (BOOL) hitCheckAndHandle:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius;

- (BOOL) collides:(CGPoint)objectPos rocketBox:(CGRect)rocketBox;

- (BOOL) collides:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius;

@end
