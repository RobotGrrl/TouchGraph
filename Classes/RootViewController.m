//
//  RootViewController.m
//  DemoS7GraphView
//
//  Created by Rudi Farkas on 20.12.09.
//  Copyright Wolfscliff 2009. All rights reserved.
//

//  Modified by RobotGrrl in Sept. 2010
//  Added basic zoom and pan capabilities

// It clips negative y values to 0
// It autoscales y to the max y over all plots

#import "RootViewController.h"


@implementation RootViewController

@synthesize graphView;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	//self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.graphView = [[S7GraphView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = self.graphView;
	self.graphView.dataSource = self;
	//self.view.backgroundColor = [UIColor yellowColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:0];
	[numberFormatter setMaximumFractionDigits:0];
	
	self.graphView.yValuesFormatter = numberFormatter;
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	self.graphView.xValuesFormatter = dateFormatter;
	
	[dateFormatter release];        
	[numberFormatter release];
	
	self.graphView.backgroundColor = [UIColor blackColor];
	
	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = YES;
	self.graphView.drawGridY = YES;
	
	self.graphView.frameHeight = self.view.frame.size.height;
	self.graphView.frameWidth = self.view.frame.size.width;
	self.graphView.positionX = 0;
	self.graphView.positionY = 0;
	
	self.graphView.xValuesColor = [UIColor whiteColor];
	self.graphView.yValuesColor = [UIColor whiteColor];
	
	self.graphView.gridXColor = [UIColor whiteColor];
	self.graphView.gridYColor = [UIColor whiteColor];
	
	self.graphView.drawInfo = NO;
	self.graphView.info = @"Load";
	self.graphView.infoColor = [UIColor whiteColor];
	
	//When you need to update the data, make this call:
	
	[self.graphView reloadData];
	
	initialDistance = -1;
	initialX = 0.0;
	initialY = 0.0;
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSSet *allTouches = [event allTouches];
	CGPoint touchPt;
	
	switch ([allTouches count]) {
		case 1: { //Single touch
			
			// Touches moved
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			touchPt = [touch1 locationInView:[self view]];
			
			initialX = self.graphView.positionX;
			initialY = self.graphView.positionY;
			
			touchDownX = touchPt.x;
			touchDownY = touchPt.y;
			
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
			switch ([touch tapCount])
			{
				case 1: //Single Tap.
					break;
				case 2: //Double tap. 
					break;
			}
			
		}
			break;
			
		case 2: { //Double Touch
			
			NSLog(@"Double touch");
			//Track the initial distance between two fingers.
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			
			initialDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:[self view]] 
													 toPoint:[touch2 locationInView:[self view]]];
			
			NSLog(@"Initial dist: %f", initialDistance);
			
		}	
			break;
			
		default:
			break;
	}
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSSet *allTouches = [event allTouches];
	CGPoint touchPt;
	
	switch ([allTouches count]) {
		case 1: {
			
			// Touches moved
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			touchPt = [touch1 locationInView:[self view]];
			
			self.graphView.positionX = initialX + (touchPt.x-touchDownX);
			self.graphView.positionY = initialY - (touchPt.y-touchDownY);
			[self.graphView reloadData];
			
		}
			break;
			
		case 2: {
			//The image is being zoomed in or out.
			
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			
			//Calculate the distance between the two fingers.
			CGFloat finalDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:[self view]]
														   toPoint:[touch2 locationInView:[self view]]];
			
			NSLog(@"Initial dist: %f Final dist: %f", initialDistance, finalDistance);
			
			//Check if zoom in or zoom out.
			if(initialDistance >= finalDistance) {
				NSLog(@"Zoom Out");
				self.graphView.frameHeight -= (finalDistance/10);
				self.graphView.frameWidth -= (finalDistance/10);
			} else {
				NSLog(@"Zoom In");
				self.graphView.frameHeight += (finalDistance/10);
				self.graphView.frameWidth += (finalDistance/10);
			}
			
			[self.graphView reloadData];
			
		} 
			break;
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self clearTouches];
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
	
	float x = toPoint.x - fromPoint.x;
	float y = toPoint.y - fromPoint.y;
	
	return sqrt( (x * x) + (y * y) );
}

- (void)clearTouches {
	initialDistance = -1;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[graphView release];
	graphView = nil;

    [super dealloc];
}

#pragma mark protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	/* Return the number of plots you are going to have in the view. 1+ */
	return 2;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:101];
	for ( int i = -50 ; i <= 50 ; i ++ ) {
		[array addObject:[NSNumber numberWithInt:i]];	
	}
	return array;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
	/* Return the values for a specific graph. Each plot is meant to have equal number of points.
	 And this amount should be equal to the amount of elements you return from graphViewXValues: method. */
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:101];
	switch (plotIndex) {
		default:
		case 0:
			for ( int i = -50 ; i <= 50 ; i ++ ) {
				[array addObject:[NSNumber numberWithInt:i*i]];	// y = x*x		
			}
			break;
		case 1:
			for ( int i = -50 ; i <= 50 ; i ++ ) {
				[array addObject:[NSNumber numberWithInt:i*i*i]];	// y = x*x*x				
			}
			break;
	}
	
	return array;
}




@end

