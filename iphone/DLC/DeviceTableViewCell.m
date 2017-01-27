

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        _deviceImgVw=[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 50, 50)];
        _deviceImgVw.layer.cornerRadius=_deviceImgVw.frame.size.width/2;
        _deviceImgVw.layer.masksToBounds=YES;
        [self addSubview:self.deviceImgVw];
        
        _deviceName=[[UILabel alloc] initWithFrame:CGRectMake(65, 5, 150, 20)];
        [self addSubview:self.deviceName];
        
        _deviceStrength=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-120, 5, 30, 20) ];
        [self addSubview:self.deviceStrength];
        
        _deviceId=[[UILabel alloc]initWithFrame:CGRectMake(65, 25, 200, 15)];
        [self addSubview:self.deviceId];
        
        _changePwdBtn=[[UIButton alloc]initWithFrame:CGRectMake(70, 40, 100, 25)];
        [self.changePwdBtn setTitle:@"Change Password" forState:UIControlStateNormal];
        [self.changePwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.changePwdBtn setBackgroundColor:[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0]];
        [self addSubview:self.changePwdBtn];
        self.changePwdBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:10.0f];
        _changePwdBtn.layer.cornerRadius=2.0;
         _changePwdBtn.layer.masksToBounds=YES;
        
        _changeDeviceNmBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-140, 40, 120, 25)];
        [_changeDeviceNmBtn setTitle:@"Change Device Name" forState:UIControlStateNormal];
        [_changeDeviceNmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeDeviceNmBtn setBackgroundColor:[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0]];
        [self addSubview:_changeDeviceNmBtn];
        _changeDeviceNmBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:10.0f];
        _changeDeviceNmBtn.layer.cornerRadius=2.0;
        _changeDeviceNmBtn.layer.masksToBounds=YES;
        
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
   
}

@end
