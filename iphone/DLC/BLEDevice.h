///
//  BLEDevice.h
//
//  Created by mr king on 06/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "BLEDefines.h"
@class DLCOne;

// Delegate interface definition
@protocol BLEDeviceDelegate
@optional
-(void) deviceReady;
-(void) deviceDisconnected;
@required
-(void) newDeviceFoundWithUUID:(NSString *)newUUIDstr;
-(void) controllerStatusUpdate:(uint8_t *)newStatus;
-(void) relayOutputUpdate:(char)sw;
-(void) globalSettingsUpdate:(uint8_t *)newGlobalSettings;
-(void) primarySettingsUpdate:(uint8_t *)newPrimarySettings;
-(void) secondarySettingsUpdate:(uint8_t *)newSecondarySettings;
-(void) primaryExtendSettingsUpdate:(uint8_t *)newPrimaryExtendSettings;
-(void) secondaryExtendSettingsUpdate:(uint8_t *)newSecondaryExtendSettings;
-(void) modelNumberUpdate:(char *)modelNoString;
-(void) deviceNameUpdate:(uint8_t *)newDeviceName ofLength:(uint8_t)length;
@end

// BLE device interface
@interface BLEDevice : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    BOOL nullUUIDFound;
    BOOL scanning;
    uint  charCount;
}

// property declarations

@property (nonatomic,assign) id <BLEDeviceDelegate> delegate;
@property (strong, nonatomic)  NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *CM;
@property (strong, nonatomic) CBPeripheral *activePeripheral;
@property (strong, nonatomic) NSMutableArray *rssiValues;
@property (nonatomic, assign) NSInteger proximityValue;
// public functions
-(void) writeRemoteControl:(DLCOne *)controller p:(CBPeripheral *)p ForRemoteObject:(int)value;
-(void) writeRemoteControl:(DLCOne *)controller p:(CBPeripheral *)p;
-(void) writeGlobalSettings:(DLCOne *)controller p:(CBPeripheral *)p;
-(void) writePrimaryProfile:(DLCOne *)controller p:(CBPeripheral *)p;
-(void) writeSecondaryProfile:(DLCOne *)controller p:(CBPeripheral *)p;
-(void) writePrimaryExtendProfile:(DLCOne *)controller p:(CBPeripheral *)p;
-(void) writeSecondaryExtendProfile:(DLCOne *)controller p:(CBPeripheral *)p;
-(void) writeDeviceInfomation:(DLCOne *)controller p:(CBPeripheral *)p;

-(void) readDeviceInformation:(CBPeripheral *)p;
-(void) readModelNumber:(CBPeripheral *)p;
-(void) readDLCStatus:(CBPeripheral *)p;
-(void) readGlobalSettings:(CBPeripheral *)p;
-(void) readPrimaryProfile:(CBPeripheral *)p;
-(void) readSecondaryProfile:(CBPeripheral *)p;
-(void) readPrimaryExtend:(CBPeripheral *)p;
-(void) readSecondaryExtend:(CBPeripheral *)p;
-(void) enableRelay:(CBPeripheral *)p;
-(void) disableRelay:(CBPeripheral *)p;
-(void) enableDLCStatus:(CBPeripheral *)p;
-(void) disableDLCStatus:(CBPeripheral *)p;

//lower level routines
-(void) writeValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID  p:(CBPeripheral *)p data:(NSData *)data;
-(void) readValue: (NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID  p:(CBPeripheral *)p;
-(void) notification:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID  p:(CBPeripheral *)p on:(BOOL)on;

-(UInt16) swap:(UInt16) s;
-(int) controlSetup:(int) s;
-(int) findBLEPeripherals;
-(const char *) centralManagerStateToString:(int)state;
-(void) stopBLEScanning;
-(void) printKnownPeripherals;
-(void) printPeripheralInfo:(CBPeripheral*)peripheral;
-(void) connectPeripheral:(CBPeripheral *)peripheral;


-(void) getAllServicesFromBLEDevice:(CBPeripheral *)p;
-(void) getAllCharacteristicsFromBLEDevice:(CBPeripheral *)p;
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service;
-(NSString *) UUIDToString:(NSUUID *) UUID;
-(const char *) CBUUIDToString:(CBUUID *) UUID;
-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2;
-(int) compareCBUUIDToInt:(CBUUID *) UUID1 UUID2:(UInt16)UUID2;
-(UInt32) CBUUIDToInt:(CBUUID *) UUID;
-(int) UUIDSAreEqual:(NSUUID *)u1 u2:(NSUUID *)u2;


@end
