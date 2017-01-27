
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *deviceImgVw;
@property (strong, nonatomic) IBOutlet UILabel *deviceName;
@property (strong, nonatomic) IBOutlet UILabel *deviceId;
@property (strong, nonatomic) IBOutlet UILabel *deviceStrength;
@property (strong, nonatomic) IBOutlet UIButton *changeDeviceNmBtn;
@property (strong, nonatomic) IBOutlet UIButton *changePwdBtn;
@property (strong, nonatomic) IBOutlet UIView *lineVw;


@end
