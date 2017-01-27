//
//  BLEDevice.m
//  BLE Light Controller Demo
//
//  Created by mr king on 06/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLEDevice.h"
#import "DLCOne.h"

@implementation BLEDevice

@synthesize delegate;
@synthesize CM;
@synthesize peripherals;
@synthesize activePeripheral;


#pragma mark -
#pragma mark DLC read and write characteristics (called from VC)
/*!
 *  @method setRemoteControl:
 *
 *  @param status The data to write
 *  @param p CBPeripheral to write to
 *
 *  @discussion Turn light on/off on on BLE device. This method writes a value to the proximity alert service
 *
 */


//-(void) writeRemoteControl:(DLCOne *)controller p:(CBPeripheral *)p
-(void) writeRemoteControl:(DLCOne *)controller p:(CBPeripheral *)p ForRemoteObject:(int)value
{
    uint8_t data[BLE_DEVICE_DLC_CHAR_REMOTE_CONTROL_READ_LEN];
    ControllerRemote* settings = [controller getRemoteCommands];
//    if (value==0)
//    {
    
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *timeFormater = [[NSDateFormatter alloc] init];
    [timeFormater setDateFormat:@"HH:mm"];
    NSString *timeString = [timeFormater stringFromDate:now];
    NSLog(@"%@", timeString);
    NSArray* split = [timeString componentsSeparatedByString: @":"];
    NSString* hours = [split objectAtIndex: 0];
    int hour = [hours intValue];
    NSString *mins = [split objectAtIndex:1];
    int min = [mins intValue];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
     dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *dateString = [dateFormat stringFromDate:now];
    NSLog(@"%@", dateString);
    split = [dateString componentsSeparatedByString:@" "];
    NSString * monthStr = [split[1] uppercaseString];
    NSString * dateStr = [split[2] uppercaseString];
    NSString * yearStr = [split[3] uppercaseString];
    split = [dateStr componentsSeparatedByString:@","];
    dateStr = [split[0] uppercaseString];
    int day = dateStr.intValue;
    int month = 0;
    int year = yearStr.intValue - 2000;
        
    
    
    if ([monthStr isEqualToString:@"JANUARY"])
        month = 1;
    else if ([monthStr isEqualToString:@"FEBRUARY"])
        month = 2;
    else if ([monthStr isEqualToString:@"MARCH"])
        month = 3;
    else if ([monthStr isEqualToString:@"APRIL"])
        month = 4;
    else if ([monthStr isEqualToString:@"MAY"])
        month = 5;
    else if ([monthStr isEqualToString:@"JUNE"])
        month = 6;
    else if ([monthStr isEqualToString:@"JULY"])
        month = 7;
    else if ([monthStr isEqualToString:@"AUGUST"])
        month = 8;
    else if ([monthStr isEqualToString:@"SEPTEMBER"])
        month = 9;
    else if ([monthStr isEqualToString:@"OCTOBER"])
        month = 10;
    else if ([monthStr isEqualToString:@"NOVEMBER"])
        month = 11;
    else if ([monthStr isEqualToString:@"DECEMBER"])
        month = 12;
    else
        month = 11;
    
    if (value==0)
    {
    
    data[0] = settings.calibrateSensor;
    data[1] = settings.manualOverride;
    data[2] = settings.dimLevelOverrideA;
    data[3] = min;
    data[4] = hour;
    data[5] = day;
    data[6] = month;
    data[7] = year;
    data[8]=0;
    data[9]=settings.daliReset;
    data[10]=settings.walkTestEnable;
    data[11]=settings.emcOverride;
    data[12] = settings.dimLevelOverrideB;
    data[13]=0;
    data[14]=0;
    data[15]=0;

    }
    else if (value==1)
    {
        data[0] = settings.calibrateSensor;
        data[1] = 0;
        data[2] = 0;
        data[3] = min;
        data[4] = hour;
        data[5] = day;
        data[6] = month;
        data[7] = year;
        data[8] = 0;
        data[9]=0;
        data[10]=0;
        data[11]=0;
        data[12] = 0;
        data[13] = 0;
        data[14] = 0;
        data[15] = 0;
    }
    else if (value==2)
    {
        data[1] = settings.manualOverride;
        data[0] = 0;
        
        data[2] = 0;
        data[3] = min;
        data[4] = hour;
        data[5] = day;
        data[6] = month;
        data[7] = year;
        data[8] = 0;
        data[9]=0;
        data[10]=0;
        data[11]=0;
        data[12] = 0;
        data[13] = 0;
        data[14] = 0;
        data[15] = 0;
    }
    else if (value==3)
    {
        data[2] = settings.dimLevelOverrideA;
        data[0] = 0;
        data[1] = 0;
        
        data[3] = min;
        data[4] = hour;
        data[5] = day;
        data[6] = month;
        data[7] = year;
        data[8] = 0;
        data[9]=0;
        data[10]=0;
        data[11]=0;
        data[12] = 0;
        data[13] = 0;
        data[14] = 0;
        data[15] = 0;
    }
    else if (value==10)
    {
        data[9]=settings.daliReset;
        data[0]=0;
        data[1] = 0;
        data[2] = 0;
        data[3] = min;
        data[4] = hour;
        data[5] = day;
        data[6] = month;
        data[7] = year;
        data[8] = 0;
        
        data[10]=0;
        data[11]=0;
        data[12] = 0;
        data[13] = 0;
        data[14] = 0;
        data[15] = 0;
    }
    else if (value==11)
    {
        data[10]=settings.walkTestEnable;
        data[0]=0;
        data[1] = 0;
        data[2] = 0;
        data[3] = min;
        data[4] = hour;
        data[5] = day;
        data[6] = month;
        data[7] = year;
        data[8] = 0;
        data[9]=0;
        
        data[11]=0;
        data[12] = 0;
        data[13] = 0;
        data[14] = 0;
        data[15] = 0;
    }
    else if (value==12)
    {
        data[11]=settings.emcOverride;
        data[0]=0;
        data[1] = 0;
        data[2] = 0;
        data[3] = min;
        data[4] = hour;
        data[5] = day;
        data[6] = month;
        data[7] = year;
        data[8] = 0;
        data[9]=0;
        data[10]=0;
        
        data[12] = 0;
        data[13] = 0;
        data[14] = 0;
        data[15] = 0;
    }
    else if (value==13)
    {
        data[12] = settings.dimLevelOverrideB;
        data[0] = 0;
        data[1] = 0;
        data[2] = 0;
        data[3] = min;
        data[4] = hour;
        data[5] = day;
        data[6] = month;
        data[7] = year;
        data[8] = 0;
        data[9]=0;
        data[10]=0;
        data[11]=0;
        
        data[13] = 0;
        data[14] = 0;
        data[15] = 0;
    }
    
    NSData *d = [[NSData alloc] initWithBytes:&data length:BLE_DEVICE_DLC_CHAR_REMOTE_CONTROL_READ_LEN];
    [self writeValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_REMOTE_CONTROL_UUID_STR p:p data:d];
    
    printf("REMOTE CONTROL Tx:");
    for (int b = 0; b < BLE_DEVICE_DLC_CHAR_REMOTE_CONTROL_READ_LEN; b++)
    {
        printf(" 0x%x", data[b]);
    }
    
    printf("\n");
}

-(void) writeGlobalSettings:(DLCOne *)controller p:(CBPeripheral *)p
{
    uint8_t* data = [[controller getGlobalSettings] getDataArray];
    [controller updateDLCGlobalSettingsChecksum:data WithLength: BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_READ_LEN];
    
    NSData *d = [[NSData alloc] initWithBytes:data length:BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_READ_LEN];
    [self writeValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_UUID_STR p:p data:d];
    
    printf("GLOBAL SETTINGS Tx:");
    for (int b = 0; b < BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_READ_LEN; b++)
    {
        printf(" 0x%x", data[b]);
    }
    
    printf("\n");
}

-(void) writePrimaryProfile:(DLCOne *)controller p:(CBPeripheral *)p
{
    UInt8* data = [[controller getProfileSettingsFor:PROFILE1] getDataArray];
    [controller updateDLCProfileChecksumForProfile: PROFILE1 ForData: data WithLength: BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_READ_LEN];
    
    NSData *d = [[NSData alloc] initWithBytes:data length:BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_READ_LEN];
    [self writeValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_UUID_STR p:p data:d];
    
    printf("PROFILE1 SETTINGS Tx:");
    for (int b = 0; b < BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_READ_LEN; b++)
    {
        printf(" 0x%x", data[b]);
    }
    
    printf("\n");
}

-(void) writeSecondaryProfile:(DLCOne *)controller p:(CBPeripheral *)p
{
    UInt8* data = [[controller getProfileSettingsFor:PROFILE2] getDataArray];
    [controller updateDLCProfileChecksumForProfile: PROFILE2 ForData: data WithLength: BLE_DEVICE_DLC_CHAR_SECONDARY_SETTINGS_READ_LEN];
    
    NSData *d = [[NSData alloc] initWithBytes:data length:BLE_DEVICE_DLC_CHAR_SECONDARY_SETTINGS_READ_LEN];
    [self writeValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_SECONDARY_SETTINGS_UUID_STR p:p data:d];
    
    printf("PROFILE2 SETTINGS Tx:");
    for (int b = 0; b < BLE_DEVICE_DLC_CHAR_SECONDARY_SETTINGS_READ_LEN; b++)
    {
        printf(" 0x%x", data[b]);
    }
    
    printf("\n");
}

-(void) writePrimaryExtendProfile:(DLCOne *)controller p:(CBPeripheral *)p
{
    UInt8* data = [controller getScheduleDataArrayFor:PROFILE1];
    [controller updateDLCExtendChecksumForProfile: PROFILE1 ForData: data WithLength: BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_READ_LEN];
    
    NSData *d = [[NSData alloc] initWithBytes:data length:BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_READ_LEN];
    [self writeValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_UUID_STR p:p data:d];
    
    printf("PROFILE1-EXTEND SETTINGS Tx:");
    for (int b = 0; b < BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_READ_LEN; b++)
    {
        printf(" 0x%x", data[b]);
    }
    
    printf("\n");
}

-(void) writeSecondaryExtendProfile:(DLCOne *)controller p:(CBPeripheral *)p
{
    UInt8* data = [controller getScheduleDataArrayFor:PROFILE2];
    [controller updateDLCExtendChecksumForProfile: PROFILE2 ForData: data WithLength: BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_READ_LEN];
    
    NSData *d = [[NSData alloc] initWithBytes:data length:BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_READ_LEN];
    [self writeValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_UUID_STR p:p data:d];
    
    printf("PROFILE2-EXTEND SETTINGS Tx:");
    for (int b = 0; b < BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_READ_LEN; b++)
    {
        printf(" 0x%x", data[b]);
    }
    
    printf("\n");
}

-(void) writeDeviceInfomation:(DLCOne *)controller p:(CBPeripheral *)p
{
    UInt8 data[BLE_DEVICE_DLC_CHAR_DEVICE_NAME_READ_LEN];
    NSString *s = [controller getDeviceName];
    unsigned long length = [s length];
    
    for (int b = 0; b < BLE_DEVICE_DLC_CHAR_DEVICE_NAME_READ_LEN; b++)
    {
        data[b] = (b < length) ? [s characterAtIndex:b] : ' ';
    }
    
    NSData *d = [[NSData alloc] initWithBytes:data length:BLE_DEVICE_DLC_CHAR_DEVICE_NAME_READ_LEN];
    [self writeValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_DEVICE_NAME_UUID_STR p:p data:d];
    
    printf("DEVICE NAME Tx:");
    for (int b = 0; b < BLE_DEVICE_DLC_CHAR_DEVICE_NAME_READ_LEN; b++)
    {
        printf(" 0x%x", data[b]);
    }
    
    printf("\n");
}

/*!
 *  @method readDLCStatus:
 *
 *  @param p CBPeripheral to read from
 *
 *  @discussion Start a relay status read cycle from the relay status service
 *
 */
-(void) readDeviceInformation:(CBPeripheral *)p
{
    [self readValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_DEVICE_NAME_UUID_STR p:p];
}
-(void) readModelNumber:(CBPeripheral *)p
{
    [self readValue:BLE_DEVICE_INFO_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_INFO_CHAR_MODEL_NO_UUID_STR p:p];
}

-(void) readDLCStatus:(CBPeripheral *)p
{
    [self readValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_STATUS_UUID_STR p:p];
}

-(void) readGlobalSettings:(CBPeripheral *)p
{
    [self readValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_UUID_STR p:p];
}

-(void) readPrimaryProfile:(CBPeripheral *)p
{
    [self readValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_UUID_STR p:p];
}

-(void) readSecondaryProfile:(CBPeripheral *)p
{
    [self readValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_SECONDARY_SETTINGS_UUID_STR p:p];
}

-(void) readPrimaryExtend:(CBPeripheral *)p
{
    [self readValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_UUID_STR p:p];
}

-(void) readSecondaryExtend:(CBPeripheral *)p
{
    [self readValue:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_UUID_STR p:p];
}

#pragma mark -
#pragma mark enable/disable methods (called from deviceReady)
/*!
 *  @method enableLightSensor:
 *
 *  @param p CBPeripheral to write to
 *
 *  @discussion Enables the light senor and enables notifications of light level
 *
 */
-(void) enableDLCStatus:(CBPeripheral *)p
{
    [self notification:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_STATUS_UUID_STR p:p on:YES];
}

/*!
 *  @method disableDLCStatus:
 *
 *  @param p CBPeripheral to write to
 *
 *  @discussion Disables the light sensor and disables notifications on light level
 *
 */
-(void) disableDLCStatus:(CBPeripheral *)p
{
    [self notification:BLE_DEVICE_DLC_SERVICE_UUID_STR characteristicUUID:BLE_DEVICE_DLC_CHAR_STATUS_UUID_STR p:p on:NO];
}

/*!
 *  @method enableRelay:
 *
 *  @param p CBPeripheral to write to
 *
 *  @discussion Enables notifications on the relay status service
 *
 */
-(void) enableRelay:(CBPeripheral *)p
{
    //[self notification:BLE_DEVICE_RELAY_STATUS_SERVICE_UUID characteristicUUID:BLE_DEVICE_RELAY_NOTIFICATION_UUID p:p on:YES];
}

/*!
 *  @method disableRelay:
 *
 *  @param p CBPeripheral to write to
 *
 *  @discussion Disables notifications on the relay status service
 *
 */
-(void) disableRelay:(CBPeripheral *)p
{
    //[self notification:BLE_DEVICE_RELAY_STATUS_SERVICE_UUID characteristicUUID:BLE_DEVICE_RELAY_NOTIFICATION_UUID p:p on:NO];
}


#pragma mark -
#pragma mark read/write values to/from BLE device
/*!
 *  @method writeValue:
 *
 *  @param serviceUUID Service UUID to write to (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to write to (e.g. 0x2401)
 *  @param data Data to write to peripheral
 *  @param p CBPeripheral to write to
 *
 *  @discussion Main routine for writeValue request, writes without feedback. It converts integer into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, value is written. If not nothing is done.
 *
 */

-(void) writeValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data
{
    CBUUID *cu = [CBUUID UUIDWithString:characteristicUUID];
    CBUUID *su = [CBUUID UUIDWithString:serviceUUID];
    CBService *service = [self findServiceFromUUID:su p:p];
    
    if (!service)
    {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n", [serviceUUID UTF8String], [[self UUIDToString:p.identifier] UTF8String]);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    
    if (!characteristic)
    {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[characteristicUUID UTF8String],[self CBUUIDToString:su],[[self UUIDToString:p.identifier] UTF8String]);
        return;
    }
    
    [p writeValue:data forCharacteristic:characteristic  type:CBCharacteristicWriteWithResponse];
}


/*!
 *  @method readValue:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for read value request. It converts integers into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the read value is started. When value is read the didUpdateValueForCharacteristic
 *  routine is called.
 *
 *  @see didUpdateValueForCharacteristic
 */

-(void) readValue: (NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID p:(CBPeripheral *)p
{
    CBUUID *cu = [CBUUID UUIDWithString:characteristicUUID];
    CBUUID *su = [CBUUID UUIDWithString:serviceUUID];
    CBService *service = [self findServiceFromUUID:su p:p];
    
    if (!service)
    {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[serviceUUID UTF8String],[[self UUIDToString:p.identifier] UTF8String]);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    
    if (!characteristic)
    {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[characteristicUUID UTF8String],[self CBUUIDToString:su],[[self UUIDToString:p.identifier] UTF8String]);
        return;
    }
    
    [p readValueForCharacteristic:characteristic];
}

#pragma mark -
#pragma mark enable BLE device notifications
/*!
 *  @method notification:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for enabling and disabling notification services. It converts integers
 *  into CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the notfication is set.
 *
 */
-(void) notification:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on
{
    CBUUID *cu = [CBUUID UUIDWithString:characteristicUUID];
    CBUUID *su = [CBUUID UUIDWithString:serviceUUID];
    CBService *service = [self findServiceFromUUID:su p:p];
    
    if (!service)
    {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[serviceUUID UTF8String],[[self UUIDToString:p.identifier] UTF8String]);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    
    if (!characteristic)
    {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[characteristicUUID UTF8String],[self CBUUIDToString:su],[[self UUIDToString:p.identifier] UTF8String]);
        return;
    }
    
    [p setNotifyValue:on forCharacteristic:characteristic];
}

#pragma mark -
#pragma mark initialise CBCentralManager
/*!
 *  @method controlSetup:
 *
 *  @param s Not used
 *
 *  @return Allways 0 (Success)
 *
 *  @discussion controlSetup enables CoreBluetooths Central Manager and sets delegate to BLEDevice class
 *
 */
- (int) controlSetup: (int) s
{
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return 0;
}

#pragma mark -
#pragma mark find & connect peripherals
/*!
 *  @method findBLEPeripherals:
 *
 *  @param none (keeps scanning until stopBLEScanning() is called)
 *
 *  @return 0 (Success), -1 (Fault)
 *
 *  @discussion findBLEPeripherals searches for BLE peripherals and sets a timeout when scanning is stopped
 *
 */
- (int) findBLEPeripherals
{
    if (self->CM.state  != CBCentralManagerStatePoweredOn)
    {
        printf("CoreBluetooth not correctly initialized !\r\n");
        printf("State = %ld (%s)\r\n",(long)self->CM.state,[self centralManagerStateToString:self.CM.state]);
        return -1;
    }
    
    scanning = true;
    nullUUIDFound = false;
    CBUUID *su = [CBUUID UUIDWithString:BLE_DEVICE_DLC_SERVICE_UUID_STR];
    [self.CM scanForPeripheralsWithServices:@[su] options:0];
    return 0; // Started scanning OK !

}


/*!
 *  @method connectPeripheral:
 *
 *  @param p Peripheral to connect to
 *
 *  @discussion connectPeripheral connects to a given peripheral and sets the activePeripheral property of BLE device.
 *
 */
- (void) connectPeripheral:(CBPeripheral *)peripheral
{
    printf("Connecting to peripheral with UUID : %s\r\n",[[self UUIDToString:peripheral.identifier] UTF8String]);
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    [CM connectPeripheral:activePeripheral options:nil];
}

#pragma mark -
#pragma mark timer (stops scanning for devices)
/*!
 *  @method stopBLEScanning:
 *
 *  @param
 *
 *  @discussion call when want to stop the CentralManager from scanning further and prints out information about known peripherals
 *
 */
- (void) stopBLEScanning
{
    [self.CM stopScan];
    scanning = false;
    printf("Stopped Scanning\r\n");
    printf("Known peripherals : %lu\r\n",(unsigned long)[self->peripherals count]);
    [self printKnownPeripherals];
	
    if (nullUUIDFound == true)
    {
        if ([self activePeripheral])
        {
            if ([[self activePeripheral] state] == CBPeripheralStateConnected)
            {
                [[self CM] cancelPeripheralConnection:[self activePeripheral]];
            }
        }
        
        nullUUIDFound = false;
    }
}

#pragma mark -
#pragma mark get all services & characteristics from BLE device
/*
 *  @method getAllServicesFromBLEDevice
 *
 *  @param p Peripheral to scan
 *
 *
 *  @discussion getAllServicesFromBLEDevice starts a service discovery on a peripheral pointed to by p.
 *  When services are found the didDiscoverServices method is called
 *
 */
-(void) getAllServicesFromBLEDevice:(CBPeripheral *)p
{
    [p discoverServices:nil]; // Discover all services without filter
    
}

/*
 *  @method getAllCharacteristicsFromBLEDevice
 *
 *  @param p Peripheral to scan
 *
 *
 *  @discussion getAllCharacteristicsFromBLEDevice starts a characteristics discovery on a peripheral
 *  pointed to by p
 *
 */
-(void) getAllCharacteristicsFromBLEDevice:(CBPeripheral *)p
{
    for (int i=0; i < p.services.count; i++)
    {
        CBService *s = [p.services objectAtIndex:i];
        printf("Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
        [p discoverCharacteristics:nil forService:s];
    }
}

#pragma mark -
#pragma mark prints methods
/*!
 *  @method centralManagerStateToString:
 *
 *  @param state State to print info of
 *
 *  @discussion centralManagerStateToString prints information text about a given CBCentralManager state
 *
 */
- (const char *) centralManagerStateToString: (int)state
{
    switch(state)
    {
        case CBCentralManagerStateUnknown:
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    return "Unknown state";
}

/*!
 *  @method printKnownPeripherals:
 *
 *  @discussion printKnownPeripherals prints all curenntly known peripherals stored in the peripherals array of BLE device class
 *
 */
- (void) printKnownPeripherals
{
    int i;
    printf("List of currently known peripherals : \r\n");
    
    for (i=0; i < self->peripherals.count; i++)
    {
        CBPeripheral *p = [self->peripherals objectAtIndex:i];
        //CFStringRef s = CFUUIDCreateString(NULL, p.UUID);
        //printf("%d  |  %s\r\n",i,CFStringGetCStringPtr(s, 0));
        printf("%d  |  %s\r\n",i,[[self UUIDToString:p.identifier] UTF8String]);
        
        [self printPeripheralInfo:p];
    }
}

/*
 *  @method printPeripheralInfo:
 *
 *  @param peripheral Peripheral to print info of
 *
 *  @discussion printPeripheralInfo prints detailed info about peripheral
 *
 */
- (void) printPeripheralInfo:(CBPeripheral*)peripheral
{
    //CFStringRef s = CFUUIDCreateString(NULL, peripheral.UUID);
    printf("------------------------------------\r\n");
    printf("Peripheral Info :\r\n");
    //printf("UUID : %s\r\n",CFStringGetCStringPtr(s, 0));
    printf("UUID : %s\r\n",[[self UUIDToString:peripheral.identifier] UTF8String]);
    printf("RSSI : %d\r\n",[peripheral.RSSI intValue]);
    printf("Name : %s\r\n",[peripheral.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    printf("isConnected : %ld\r\n",(long)peripheral.state);
    printf("-------------------------------------\r\n");
    
}

/*
 *  @method CBUUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion CBUUIDToString converts the data of a CBUUID class to a character pointer for easy printout using printf()
 *
 */
-(const char *) CBUUIDToString:(CBUUID *) UUID
{
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}


/*
 *  @method UUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion UUIDToString converts the data of a CFUUIDRef class to a character pointer for easy printout using printf()
 *
 */
-(NSString *) UUIDToString:(NSUUID *)UUID
{
    /*if (!UUID)
     {
     return "NULL";
     }
     
     CFStringRef s = CFUUIDCreateString(NULL, UUID);
     
     return CFStringGetCStringPtr(s, 0);
     */
    return (UUID.UUIDString);
}
//-(NSString *) UUIDToString:(CBUUID *)UUID
//{
//    /*if (!UUID)
//     {
//     return "NULL";
//     }
//     
//     CFStringRef s = CFUUIDCreateString(NULL, UUID);
//     
//     return CFStringGetCStringPtr(s, 0);
//     */
//    NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDBytes:[UUID.data bytes]];
//    return (nsuuid.UUIDString);
//}

#pragma mark -
#pragma mark byte stuffing & checking etc
/*!
 *  @method swap:
 *
 *  @param s Uint16 value to byteswap
 *
 *  @discussion swap byteswaps a UInt16
 *
 *  @return Byteswapped UInt16
 */

-(UInt16) swap:(UInt16)s
{
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

/*
 *  @method UUIDSAreEqual:
 *
 *  @param u1 CFUUIDRef 1 to compare
 *  @param u2 CFUUIDRef 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compares two CFUUIDRef's
 *
 */

- (int) UUIDSAreEqual:(NSUUID *)u1 u2:(NSUUID *)u2
{
    
    //CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    //CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    
    if ([u1 isEqual:u2] == true)
        //if (memcmp(&b1, &b2, 16) == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}


/*
 *  @method compareCBUUID
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUID compares two CBUUID's to each other and returns 1 if they are equal and 0 if they are not
 *
 */

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2
{
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    
    if (memcmp(b1, b2, UUID1.data.length) == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

/*
 *  @method compareCBUUIDToInt
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UInt16 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUIDToInt compares a CBUUID to a UInt16 representation of a UUID and returns 1
 *  if they are equal and 0 if they are not
 *
 */
-(int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2
{
    char b1[16];
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    
    if (memcmp(b1, (char *)&b2, 2) == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
/*
 *  @method CBUUIDToInt
 *
 *  @param UUID1 UUID 1 to convert
 *
 *  @returns UInt16 representation of the CBUUID
 *
 *  @discussion CBUUIDToInt converts a CBUUID to a Uint32 representation of the UUID
 *
 */
-(UInt32) CBUUIDToInt:(CBUUID *) UUID
{
    char b1[16];
    UInt32 value = 0;
    [UUID.data getBytes:b1];
    
    // Device Info begins with 2a
    if ((UInt8)b1[0] == 0x2a)
        value = ((UInt8)b1[0] << 8) | (UInt8)b1[1];
    else
        value = ((UInt8)b1[12] << 24) | ((UInt8)b1[13] << 16) | ((UInt8)b1[14] << 8) | (UInt8)b1[15];
    
    return (value);
}

/*
 *  @method IntToCBUUID
 *
 *  @param UInt16 representation of a UUID
 *
 *  @return The converted CBUUID
 *
 *  @discussion IntToCBUUID converts a UInt16 UUID to a CBUUID
 *
 */
-(CBUUID *) IntToCBUUID:(UInt16)UUID
{
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}

#pragma mark -
#pragma mark find service or characteristic from UUID
/*
 *  @method findServiceFromUUID:
 *
 *  @param UUID CBUUID to find in service list
 *  @param p Peripheral to find service on
 *
 *  @return pointer to CBService if found, nil if not
 *
 *  @discussion findServiceFromUUID searches through the services list of a peripheral to find a
 *  service with a specific UUID
 *
 */
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p
{
    for(int i = 0; i < p.services.count; i++)
    {
        CBService *s = [p.services objectAtIndex:i];
        
        if ([self compareCBUUID:s.UUID UUID2:UUID])
        {
            return s;
        }
    }
    
    return nil; //Service not found on this peripheral
}

/*
 *  @method findCharacteristicFromUUID:
 *
 *  @param UUID CBUUID to find in Characteristic list of service
 *  @param service Pointer to CBService to search for charateristics on
 *
 *  @return pointer to CBCharacteristic if found, nil if not
 *
 *  @discussion findCharacteristicFromUUID searches through the characteristic list of a given service
 *  to find a characteristic with a specific UUID
 *
 */
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service
{
    for(int i=0; i < service.characteristics.count; i++)
    {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        
        if ([self compareCBUUID:c.UUID UUID2:UUID])
        {
            return c;
        }
    }
    
    return nil; //Characteristic not found on this service
}

#pragma mark -
#pragma mark central manager delegates
//----------------------------------------------------------------------------------------------------
//
//
//
//
//CBCentralManagerDelegate protocol methods beneeth here
// Documented in CoreBluetooth documentation
//
//
//
//
//----------------------------------------------------------------------------------------------------
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    printf("Status of CoreBluetooth central manager changed %ld (%s)\r\n",(long)central.state,[self centralManagerStateToString:central.state]);
}
-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals{
    NSLog(@"This is it!");
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSInteger rssiValueLevel;
    NSInteger rssiValue = RSSI.integerValue;
    
        //Convert RSSI to positive and divide by 10 as client wants values between 1-10
   // rssiValue = (rssiValue * -1) * 0.1;
    
    // Calculate rssiValue Level According to client
    
    
    if (rssiValue>=-30 )
    {
        rssiValueLevel=10;
    }
    else if (rssiValue>=-37)
    {
        rssiValueLevel=9;
    }
    else if (rssiValue>=-44)
    {
        rssiValueLevel=8;
    }
    else if (rssiValue>=-51)
    {
        rssiValueLevel=7;
    }
    else if (rssiValue>=-58)
    {
        rssiValueLevel=6;
    }
    else if (rssiValue>=-65)
    {
        rssiValueLevel=5;
    }
    else if (rssiValue>=-72)
    {
        rssiValueLevel=4;
    }
    else if (rssiValue>=-77)
    {
        rssiValueLevel=3;
    }
    else if (rssiValue>=-84)
    {
        rssiValueLevel=2;
    }
    else
    {
        rssiValueLevel=1;
    }
    
    NSLog(@"before RSSI value:-%ld",(long)rssiValue);
  
    NSLog(@"After RSSI value:-%ld",(long)rssiValueLevel);
    

     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     int proximity = (int)[defaults integerForKey:@"proximity"];
     NSLog(@"******************** Device proximity loadingvalue: %ld *********************", (long)proximity);
    NSLog(@"******************** Device proximity: %ld *********************", (long)rssiValue);
    
    if (proximity <= rssiValueLevel) {
        return;
    }

    if (peripheral.identifier == nil)
    {
        if (nullUUIDFound == false)
        {
            nullUUIDFound = true;
            [self connectPeripheral:peripheral];
        }
        return;
    }
    if (!self.peripherals)
    {
        self.peripherals = [[NSMutableArray alloc] initWithObjects:peripheral,nil];
    }
    else
    {
        for(int i = 0; i < self.peripherals.count; i++)
        {
            CBPeripheral *p = [self.peripherals objectAtIndex:i];
            if ([self UUIDSAreEqual:p.identifier u2:peripheral.identifier])
            {
                [self.peripherals replaceObjectAtIndex:i withObject:peripheral];
                
                printf("Duplicate UUID found updating...\r\n");
                return;
            }
        }
        
        [self->peripherals addObject:peripheral];
        printf("New UUID, adding\r\n");
        [[self delegate] newDeviceFoundWithUUID:[self UUIDToString:peripheral.identifier]];
        
        
    }
    if (!self.rssiValues)
    {
        
        self.rssiValues = [[NSMutableArray alloc] initWithObjects:RSSI, nil];
    }
    else {
        
        [self.rssiValues addObject:RSSI];
        for(int i = 0; i < self.rssiValues.count; i++)
        {
            
            if (![[self.rssiValues objectAtIndex:i] isEqual:RSSI])
            {
                
                [self.rssiValues replaceObjectAtIndex:i withObject:RSSI];
                printf("Duplicate RSSI found updating...\r\n");
                return;
            }
        }
        
        printf("New RSSI. Adding \r\n");
    }
    printf("didDiscoverPeripheral\r\n");
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    printf("Connection to peripheral with UUID : %s successfull\r\n",[[self UUIDToString:peripheral.identifier] UTF8String]);
    
    if ((scanning == true) && (nullUUIDFound == true))
    {
        self.activePeripheral = peripheral;
        return;
    }
    
    charCount = 0;
    self.activePeripheral = peripheral;
    [self.activePeripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    printf("Disconnected from peripheral with UUID : %s \r\n",[[self UUIDToString:peripheral.identifier] UTF8String]);
    [[self delegate] deviceDisconnected];
}

#pragma mark -
#pragma mark peripheral delegates
//----------------------------------------------------------------------------------------------------
//
//
//
//
//
//CBPeripheralDelegate protocol methods beneeth here
//
//
//
//
//
//----------------------------------------------------------------------------------------------------


/*
 *  @method didDiscoverCharacteristicsForService
 *
 *  @param peripheral Pheripheral that got updated
 *  @param service Service that characteristics where found on
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverCharacteristicsForService is called when CoreBluetooth has discovered
 *  characteristics on a service, on a peripheral after the discoverCharacteristics routine has been called on the service
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error)
    {
        printf("Characteristics of service with UUID : %s found - with %lu services\r\n",[self CBUUIDToString:service.UUID], service.characteristics.count);
        
        for (int i = 0; i < service.characteristics.count; i++)
        {
            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
            printf("Found characteristic String %s \r\n",[[self UUIDToString:[[NSUUID alloc] initWithUUIDBytes:[c.UUID.data bytes]]] UTF8String]);
            printf("Found characteristic %s\r\n",[self CBUUIDToString:c.UUID]);
            CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
            
            if ([self compareCBUUID:service.UUID UUID2:s.UUID])
            {
                printf("Finished discovering characteristics for %s", [self CBUUIDToString:c.UUID]);
                if (++charCount == BLE_DEVICE_DLC_CHAR_COUNT)
                {
                    [[self delegate] deviceReady];
                }
            }
        }
    }
    else
    {
        printf("Characteristic discorvery unsuccessfull !\r\n");
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
}

/*
 *  @method didDiscoverServices
 *
 *  @param peripheral Pheripheral that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverServices is called when CoreBluetooth has discovered services on a
 *  peripheral after the discoverServices routine has been called on the peripheral
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error)
    {
        printf("Services of peripheral with UUID : %s found\r\n",[[self UUIDToString:peripheral.identifier] UTF8String]);
        [self getAllCharacteristicsFromBLEDevice:peripheral];
    }
    else
    {
        printf("Service discovery was unsuccessfull !\r\n");
    }
}

/*
 *  @method didUpdateNotificationStateForCharacteristic
 *
 *  @param peripheral Pheripheral that got updated
 *  @param characteristic Characteristic that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didUpdateNotificationStateForCharacteristic is called when CoreBluetooth has updated a
 *  notification state for a characteristic
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error)
    {
        printf("Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[[self UUIDToString:peripheral.identifier] UTF8String]);
    }
    else
    {
        printf("Error in setting notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[[self UUIDToString:peripheral.identifier] UTF8String]);
        printf("Error code was %s\r\n",[[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
    
}

/*
 *  @method didUpdateValueForCharacteristic
 *
 *  @param peripheral Pheripheral that got updated
 *  @param characteristic Characteristic that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didUpdateValueForCharacteristic is called when CoreBluetooth has updated a
 *  characteristic for a peripheral. All reads and notifications come here to be processed.
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    UInt32 characteristicUUID = [self CBUUIDToInt:characteristic.UUID];
    
    if (!error)
    {
        int size = (int)[characteristic.value length];
        uint8_t data[size];
        [characteristic.value getBytes:&data length:size];
        printf("UUID: 0x%x ", (unsigned int)characteristicUUID);
        printf("Rx:");
        for (int b = 0; b < size; b++)
        {
            printf(" 0x%x", data[b]);
        }
        
        printf("\n");
        
        switch (characteristicUUID)
        {
            case BLE_DEVICE_DLC_CHAR_STATUS_UUID:
            {
                if (size >= BLE_DEVICE_DLC_CHAR_STATUS_READ_LEN)
                {
                    [[self delegate] controllerStatusUpdate:data];
                }
                else
                {
                    printf("Unexpected length of status characteristic data: size %d.\n", size);
                }
                break;
            }
            case BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_UUID:
            {
                if (size >= BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_READ_LEN)
                {
                    [[self delegate] globalSettingsUpdate:data];
                }
                else
                {
                    printf("Unexpected length of global settings characteristic data: size %d.\n", size);
                }
                break;
            }
            case BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_UUID:
            {
                if (size >= BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_READ_LEN)
                {
                    [[self delegate] primarySettingsUpdate:data];
                }
                else
                {
                    printf("Unexpected length of global settings characteristic data: size %d.\n", size);
                }
                break;
            }
            case BLE_DEVICE_DLC_CHAR_SECONDARY_SETTINGS_UUID:
            {
                if (size >= BLE_DEVICE_DLC_CHAR_SECONDARY_SETTINGS_READ_LEN)
                {
                    [[self delegate] secondarySettingsUpdate:data];
                }
                else
                {
                    printf("Unexpected length of secondary settings characteristic data: size %d.\n", size);
                }
                break;
            }
            case BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_UUID:
            {
                if (size >= BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_READ_LEN)
                {
                    [[self delegate] primaryExtendSettingsUpdate:data];
                }
                else
                {
                    printf("Unexpected length of primary extend settings characteristic data: size %d.\n", size);
                }
                break;
            }
            case BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_UUID:
            {
                if (size >= BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_READ_LEN)
                {
                    [[self delegate] secondaryExtendSettingsUpdate:data];
                }
                else
                {
                    printf("Unexpected length of secondary extend settings characteristic data: size %d.\n", size);
                }
                break;
            }
            case BLE_DEVICE_DLC_CHAR_DEVICE_NAME_UUID:
            {
                [[self delegate] deviceNameUpdate:data ofLength:size];
                break;
            }
            case BLE_DEVICE_INFO_CHAR_MODEL_NO_UUID:
            {
                [[self delegate] modelNumberUpdate:(char *)data];
                break;
            }
                
            default:
            {
                printf("Unexpected type of characteristic data.");
            }
        }
    }
    else
    {
        printf("updateValueForCharacteristic failed !\n");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //printf("peripheral write value for characteristic failed!\n");
    //NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}


@end
