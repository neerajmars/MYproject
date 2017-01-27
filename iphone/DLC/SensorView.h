#import <UIKit/UIKit.h>

@protocol SensorViewDelegate <NSObject>

@optional
- (void)ClkOnleftSensorBtn:(id)sender;
- (void)ClkOnRightSensorBtn:(id)sender;
- (void)ClkOnUpSensorBtn:(id)sender;
- (void)ClkOnDownSensorBtn:(id)sender;
- (void)ClkOnCenterSensorBtn:(id)sender;
- (IBAction)exitTimerSliderValueChanged:(UISlider *)sender;
@end
@interface SensorView : UIView<SensorViewDelegate>
{
    UIImageView *ledImgVw;
    UIButton *leftSensorBtn;
    UIButton *rightSensorBtn;
    UIButton *upSensorBtn;
    UIButton *downSensorBtn;
    UIButton *centerSensorBtn;
    UIImageView *leftArrowImgVw;
    UIImageView *rightArrowImgVw;
    UIImageView *upArrowImgVw;
    UIImageView *downArrowImgVw;
    UIImageView *centerArrowImgVw;
    UILabel *exitTimerValueLbl;
    UISlider *exitTimerSlider;
    UIImageView *sensorImgVw;
}
- (void)setSensorView:(NSInteger)value;
@property (strong, nonatomic) UIImageView *ledImgVw;
@property (strong, nonatomic) UIImageView *sensorImgVw;
@property (nonatomic, strong) UIButton *leftSensorBtn;
@property (nonatomic, strong) UIButton *rightSensorBtn;
@property (nonatomic, strong) UIButton *upSensorBtn;
@property (nonatomic, strong) UIButton *downSensorBtn;
@property (nonatomic, strong) UIButton *centerSensorBtn;
@property (strong, nonatomic) UIImageView *leftArrowImgVw;
@property (strong, nonatomic) UIImageView *rightArrowImgVw;
@property (strong, nonatomic) UIImageView *upArrowImgVw;
@property (strong, nonatomic) UIImageView *downArrowImgVw;
@property (strong, nonatomic) UIImageView *centerArrowImgVw;
@property (nonatomic, strong) UILabel *exitTimerValueLbl;
@property (strong, nonatomic) UISlider *exitTimerSlider;

@property (weak, nonatomic) id <SensorViewDelegate> delegate;
@end
