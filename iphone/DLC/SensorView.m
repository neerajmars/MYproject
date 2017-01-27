#import "SensorView.h"

@implementation SensorView
{
    CGFloat deviceWidth;
    CGFloat deviceHeight;
    UIView *sensorVw;
    
    UIView *exitDelayTimerVw;
    
}
@synthesize delegate;
@synthesize ledImgVw;
@synthesize sensorImgVw;
@synthesize leftSensorBtn;
@synthesize rightSensorBtn;
@synthesize upSensorBtn;
@synthesize downSensorBtn;
@synthesize centerSensorBtn;
@synthesize leftArrowImgVw;
@synthesize rightArrowImgVw;
@synthesize upArrowImgVw;
@synthesize downArrowImgVw;
@synthesize centerArrowImgVw;
@synthesize exitTimerValueLbl;
@synthesize exitTimerSlider;

- (void)setSensorView:(NSInteger)value
{
    deviceWidth=self.bounds.size.width;
    deviceHeight=self.bounds.size.height;
    
    sensorVw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
    sensorVw.backgroundColor=[UIColor whiteColor];
    [self addSubview:sensorVw];
    
    [self showExitDelayTimerSliderVw];
    
    UILabel *pirDetectorLbl=[[UILabel alloc]initWithFrame:CGRectMake(5, exitDelayTimerVw.frame.origin.y+exitDelayTimerVw.frame.size.height+25, 300, 20)];
    pirDetectorLbl.text=@"Enable/Disable Movement Detectors";
    [sensorVw addSubview:pirDetectorLbl];
    pirDetectorLbl.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    
    
    
    
    sensorImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(sensorVw.frame.size.width/2-100, sensorVw.frame.size.height/2-100, 200, 200)];
   // sensorImgVw.image=[UIImage imageNamed:@"sensorImage.jpg"];
    sensorImgVw.image=[UIImage imageNamed:@"sensorImageGreenLED.png"];
    [sensorVw addSubview:sensorImgVw];
    sensorImgVw.userInteractionEnabled=YES;
    
    
    
//    ledImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(sensorImgVw.frame.origin.x+49, sensorImgVw.frame.origin.y+88, 25, 25)];
//    ledImgVw.image=[UIImage imageNamed:@"LEDFlashGreen.png"];
//    [sensorVw addSubview:ledImgVw];
    
    leftSensorBtn=[[UIButton alloc]initWithFrame:CGRectMake(sensorImgVw.frame.origin.x-2, sensorImgVw.frame.origin.y+88, 30, 30)];
    [leftSensorBtn addTarget:self action:@selector(ClkOnleftSensorBtn :) forControlEvents:UIControlEventTouchUpInside];
    [sensorVw addSubview:leftSensorBtn];
    leftSensorBtn.transform = CGAffineTransformMakeRotation(M_PI);
    
    rightSensorBtn=[[UIButton alloc]initWithFrame:CGRectMake(sensorImgVw.frame.origin.x+sensorImgVw.frame.size.width-30, sensorImgVw.frame.origin.y+85, 30, 30)];
    [rightSensorBtn addTarget:self action:@selector(ClkOnRightSensorBtn :) forControlEvents:UIControlEventTouchUpInside];
    [sensorVw addSubview:rightSensorBtn];
    
    upSensorBtn=[[UIButton alloc]initWithFrame:CGRectMake(sensorImgVw.frame.origin.x+sensorImgVw.frame.size.width/2-15, sensorImgVw.frame.origin.y, 30, 30)];
    [upSensorBtn addTarget:self action:@selector(ClkOnUpSensorBtn :) forControlEvents:UIControlEventTouchUpInside];
    [sensorVw addSubview:upSensorBtn];
    upSensorBtn.transform = CGAffineTransformMakeRotation(270*M_PI/180);
    
    downSensorBtn=[[UIButton alloc]initWithFrame:CGRectMake(sensorImgVw.frame.origin.x+sensorImgVw.frame.size.width/2-15, sensorImgVw.frame.origin.y+170, 30, 30)];
    [downSensorBtn addTarget:self action:@selector(ClkOnDownSensorBtn :) forControlEvents:UIControlEventTouchUpInside];
    [sensorVw addSubview:downSensorBtn];
    downSensorBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    
    centerSensorBtn=[[UIButton alloc]initWithFrame:CGRectMake(sensorImgVw.frame.origin.x+sensorImgVw.frame.size.width/2-20, sensorImgVw.frame.origin.y+sensorImgVw.frame.size.height/2-20, 40, 40)];
    [centerSensorBtn addTarget:self action:@selector(ClkOnCenterSensorBtn :) forControlEvents:UIControlEventTouchUpInside];
    [sensorVw addSubview:centerSensorBtn];
 
  
    leftArrowImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(leftSensorBtn.frame.origin.x-50, leftSensorBtn.frame.origin.y+5, 40, 15)];
    leftArrowImgVw.image=[UIImage imageNamed:@"leftArrow.png"];
    [sensorVw addSubview:leftArrowImgVw];
    
    
    rightArrowImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(rightSensorBtn.frame.origin.x+40, rightSensorBtn.frame.origin.y+5, 40, 15)];
    rightArrowImgVw.image=[UIImage imageNamed:@"rightArrow.png"];
    [sensorVw addSubview:rightArrowImgVw];
    
    upArrowImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(upSensorBtn.frame.origin.x+6, upSensorBtn.frame.origin.y-40, 15, 40)];
    upArrowImgVw.image=[UIImage imageNamed:@"upArrow.png"];
    [sensorVw addSubview:upArrowImgVw];
    
    downArrowImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(downSensorBtn.frame.origin.x+7, downSensorBtn.frame.origin.y+35, 15, 40)];
    downArrowImgVw.image=[UIImage imageNamed:@"downArrow.png"];
    [sensorVw addSubview:downArrowImgVw];
    
    centerArrowImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(centerSensorBtn.frame.origin.x-25, centerSensorBtn.frame.origin.y+35, 15, 40)];
    centerArrowImgVw.image=[UIImage imageNamed:@"downArrow.png"];
    [sensorVw addSubview:centerArrowImgVw];
    centerArrowImgVw.transform = CGAffineTransformMakeRotation(0.785398);
    
    leftArrowImgVw.hidden=YES;
    rightArrowImgVw.hidden=YES;
    upArrowImgVw.hidden=YES;
    downArrowImgVw.hidden=YES;
    centerArrowImgVw.hidden=YES;

}
-(void)showExitDelayTimerSliderVw
{
    exitDelayTimerVw=[[UIView alloc]initWithFrame:CGRectMake(5, 10, sensorVw.frame.size.width-10, 30)];
    [sensorVw addSubview:exitDelayTimerVw];
    exitTimerSlider=[[UISlider alloc]initWithFrame:CGRectMake(30, 15, exitDelayTimerVw.frame.size.width-60, 20)];
    [exitDelayTimerVw addSubview:exitTimerSlider];
    [exitTimerSlider addTarget:self action:@selector(exitTimerSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    exitTimerSlider.minimumValue=-0.1;
    exitTimerSlider.maximumValue=3.2;
    [exitTimerSlider setValue:-0.1];
    
    UILabel *leftExitTimerlbl=[[UILabel alloc]initWithFrame:CGRectMake(20, 25, 50, 20)];
    leftExitTimerlbl.text=@"0";
    [exitDelayTimerVw addSubview:leftExitTimerlbl];
    
    leftExitTimerlbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    
    UILabel *rightExitTimerLbl=[[UILabel alloc]initWithFrame:CGRectMake(exitDelayTimerVw.frame.size.width-30, 25, 50, 20)];
    rightExitTimerLbl.text=@"30";
    [exitDelayTimerVw addSubview:rightExitTimerLbl];
    rightExitTimerLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    
    exitTimerValueLbl=[[UILabel alloc]initWithFrame:CGRectMake(exitDelayTimerVw.frame.size.width/2-50, 0, 100, 15)];
    exitTimerValueLbl.text=[NSString stringWithFormat:@"Exit Timer :0 mins"];
    
    [exitDelayTimerVw addSubview:exitTimerValueLbl];
    exitTimerValueLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    exitTimerValueLbl.textAlignment=NSTextAlignmentCenter;
}
- (IBAction)exitTimerSliderValueChanged:(UISlider *)sender
{
    [delegate exitTimerSliderValueChanged:sender];
}

- (void)ClkOnleftSensorBtn:(id)sender
{
    [delegate ClkOnleftSensorBtn:sender];
}
- (void)ClkOnRightSensorBtn:(id)sender
{
    [delegate ClkOnRightSensorBtn:sender];
}
- (void)ClkOnUpSensorBtn:(id)sender
{
    [delegate ClkOnUpSensorBtn:sender];
}
- (void)ClkOnDownSensorBtn:(id)sender
{
    [delegate ClkOnDownSensorBtn:sender];
}

- (void)ClkOnCenterSensorBtn:(id)sender
{
    [delegate ClkOnCenterSensorBtn:sender];
}


@end
