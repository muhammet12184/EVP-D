# UDS (Unified Diagnostic Services) - ISO 14229

## Overview
UDS (Unified Diagnostic Services) is a diagnostic communication protocol used in automotive Electronic Control Units (ECUs). It's specified in ISO 14229 and built on top of ISO-TP (ISO 15765-2).

## UDS Services (SIDs)

### Diagnostic and Communication Management

| SID  | Service Name                                    | Sub-functions | Description |
|------|-------------------------------------------------|---------------|-------------|
| 0x10 | DiagnosticSessionControl                        | Yes           | Changes diagnostic session (Default, Programming, Extended, etc.) |
| 0x11 | ECUReset                                        | Yes           | Resets the ECU |
| 0x27 | SecurityAccess                                  | Yes           | Unlocks secured services |
| 0x28 | CommunicationControl                            | Yes           | Controls communication parameters |
| 0x3E | TesterPresent                                   | Yes           | Keeps diagnostic session active |
| 0x83 | AccessTimingParameter                           | Yes           | Access timing parameters |
| 0x84 | SecuredDataTransmission                         | Yes           | Secured data transmission |
| 0x85 | ControlDTCSetting                               | Yes           | Enable/disable DTC setting |
| 0x86 | ResponseOnEvent                                 | Yes           | Configure response on events |
| 0x87 | LinkControl                                     | Yes           | Control diagnostic link |

### Data Transmission

| SID  | Service Name                                    | Sub-functions | Description |
|------|-------------------------------------------------|---------------|-------------|
| 0x22 | ReadDataByIdentifier                            | No            | Read data by DID |
| 0x23 | ReadMemoryByAddress                             | No            | Read memory by address |
| 0x24 | ReadScalingDataByIdentifier                     | No            | Read scaling data |
| 0x2A | ReadDataByPeriodicIdentifier                    | Yes           | Read periodic data |
| 0x2C | DynamicallyDefineDataIdentifier                 | Yes           | Define dynamic DIDs |
| 0x2E | WriteDataByIdentifier                           | No            | Write data by DID |
| 0x3D | WriteMemoryByAddress                            | No            | Write memory by address |

### Stored Data Transmission

| SID  | Service Name                                    | Sub-functions | Description |
|------|-------------------------------------------------|---------------|-------------|
| 0x14 | ClearDiagnosticInformation                      | No            | Clear DTCs |
| 0x19 | ReadDTCInformation                              | Yes           | Read DTC information |

### Input/Output Control

| SID  | Service Name                                    | Sub-functions | Description |
|------|-------------------------------------------------|---------------|-------------|
| 0x2F | InputOutputControlByIdentifier                  | No            | Control I/O by identifier |

### Remote Activation of Routine

| SID  | Service Name                                    | Sub-functions | Description |
|------|-------------------------------------------------|---------------|-------------|
| 0x31 | RoutineControl                                  | Yes           | Start/stop/request results of routines |

### Upload/Download

| SID  | Service Name                                    | Sub-functions | Description |
|------|-------------------------------------------------|---------------|-------------|
| 0x34 | RequestDownload                                 | No            | Request to download data to ECU |
| 0x35 | RequestUpload                                   | No            | Request to upload data from ECU |
| 0x36 | TransferData                                    | No            | Transfer data |
| 0x37 | RequestTransferExit                             | No            | Terminate data transfer |
| 0x38 | RequestFileTransfer                             | Yes           | File transfer operations |

## Negative Response Codes (NRCs)

| NRC  | Description                                              |
|------|----------------------------------------------------------|
| 0x10 | generalReject                                            |
| 0x11 | serviceNotSupported                                      |
| 0x12 | subFunctionNotSupported                                  |
| 0x13 | incorrectMessageLengthOrInvalidFormat                    |
| 0x14 | responseTooLong                                          |
| 0x21 | busyRepeatRequest                                        |
| 0x22 | conditionsNotCorrect                                     |
| 0x24 | requestSequenceError                                     |
| 0x25 | noResponseFromSubnetComponent                            |
| 0x26 | failurePreventsExecutionOfRequestedAction                |
| 0x31 | requestOutOfRange                                        |
| 0x33 | securityAccessDenied                                     |
| 0x35 | invalidKey                                               |
| 0x36 | exceedNumberOfAttempts                                   |
| 0x37 | requiredTimeDelayNotExpired                              |
| 0x70 | uploadDownloadNotAccepted                                |
| 0x71 | transferDataSuspended                                    |
| 0x72 | generalProgrammingFailure                                |
| 0x73 | wrongBlockSequenceCounter                                |
| 0x78 | requestCorrectlyReceived-ResponsePending                 |
| 0x7E | subFunctionNotSupportedInActiveSession                   |
| 0x7F | serviceNotSupportedInActiveSession                       |
| 0x81 | rpmTooHigh                                               |
| 0x82 | rpmTooLow                                                |
| 0x83 | engineIsRunning                                          |
| 0x84 | engineIsNotRunning                                       |
| 0x85 | engineRunTimeTooLow                                      |
| 0x86 | temperatureTooHigh                                       |
| 0x87 | temperatureTooLow                                        |
| 0x88 | vehicleSpeedTooHigh                                      |
| 0x89 | vehicleSpeedTooLow                                       |
| 0x8A | throttle/PedalTooHigh                                    |
| 0x8B | throttle/PedalTooLow                                     |
| 0x8C | transmissionRangeNotInNeutral                            |
| 0x8D | transmissionRangeNotInGear                               |
| 0x8F | brakeSwitchNotClosed                                     |
| 0x90 | shifterLeverNotInPark                                    |
| 0x91 | torqueConverterClutchLocked                              |
| 0x92 | voltageTooHigh                                           |
| 0x93 | voltageTooLow                                            |

## Common DIDs (Data Identifiers)

### Vehicle Information DIDs

| DID    | Description                                    | Length   |
|--------|------------------------------------------------|----------|
| 0xF186 | ActiveDiagnosticSessionDataIdentifier          | 1 byte   |
| 0xF187 | VehicleManufacturerSparePartNumberDataIdentifier | Variable |
| 0xF188 | VehicleManufacturerECUSoftwareNumberDataIdentifier | Variable |
| 0xF189 | VehicleManufacturerECUSoftwareVersionNumberDataIdentifier | Variable |
| 0xF18A | SystemSupplierSpecificDataIdentifier           | Variable |
| 0xF18B | ECUManufacturingDateAndTimeDataIdentifier      | 4 bytes  |
| 0xF18C | ECUSerialNumberDataIdentifier                  | Variable |
| 0xF18D | SupportedFunctionalUnitsDataIdentifier         | Variable |
| 0xF18E | VehicleManufacturerKitAssemblyPartNumberDataIdentifier | Variable |
| 0xF190 | VINDataIdentifier                              | 17 bytes |
| 0xF191 | VehicleManufacturerECUHardwareNumberDataIdentifier | Variable |
| 0xF192 | SystemSupplierECUHardwareNumberDataIdentifier  | Variable |
| 0xF193 | SystemSupplierECUHardwareVersionNumberDataIdentifier | Variable |
| 0xF194 | SystemSupplierECUSoftwareNumberDataIdentifier  | Variable |
| 0xF195 | SystemSupplierECUSoftwareVersionNumberDataIdentifier | Variable |
| 0xF197 | SystemNameDataIdentifier                       | Variable |
| 0xF198 | RepairShopCodeOrTesterSerialNumberDataIdentifier | Variable |
| 0xF199 | ProgrammingDateDataIdentifier                  | 4 bytes  |
| 0xF19A | CalibrationRepairShopCodeOrTesterSerialNumberDataIdentifier | Variable |
| 0xF19B | CalibrationEquipmentSoftwareNumberDataIdentifier | Variable |
| 0xF19D | ECUInstallationDateDataIdentifier              | 4 bytes  |
| 0xF19E | ODXFileDataIdentifier                          | Variable |
| 0xF1A0 | VehicleManufacturerEnablesCounterDataIdentifier | Variable |

### Network Configuration DIDs

| DID    | Description                                    | Length   |
|--------|------------------------------------------------|----------|
| 0xF400 | BootSoftwareIdentificationDataIdentifier       | Variable |
| 0xF401 | ApplicationSoftwareIdentificationDataIdentifier | Variable |
| 0xF402 | ApplicationDataIdentificationDataIdentifier     | Variable |
| 0xF403 | BootSoftwareFingerprintDataIdentifier          | Variable |
| 0xF404 | ApplicationSoftwareFingerprintDataIdentifier   | Variable |
| 0xF405 | ApplicationDataFingerprintDataIdentifier       | Variable |
| 0xF40D | ActiveDiagnosticSessionDataIdentifier          | 1 byte   |
| 0xF410 | VehicleSpeedDataIdentifier                     | 2 bytes  |
| 0xF417 | OdometerDataIdentifier                         | 3 bytes  |

## UDS Sub-functions

### DiagnosticSessionControl (0x10) Sub-functions

| Sub-function | Session Type                |
|--------------|----------------------------|
| 0x01         | defaultSession             |
| 0x02         | programmingSession         |
| 0x03         | extendedDiagnosticSession  |
| 0x04         | safetySystemDiagnosticSession |
| 0x40-0x5F    | vehicleManufacturerSpecific |
| 0x60-0x7E    | systemSupplierSpecific     |

### ECUReset (0x11) Sub-functions

| Sub-function | Reset Type                 |
|--------------|---------------------------|
| 0x01         | hardReset                 |
| 0x02         | keyOffOnReset             |
| 0x03         | softReset                 |
| 0x04         | enableRapidPowerShutDown  |
| 0x05         | disableRapidPowerShutDown |
| 0x40-0x5F    | vehicleManufacturerSpecific |
| 0x60-0x7E    | systemSupplierSpecific    |

### SecurityAccess (0x27) Sub-functions

| Sub-function | Description                |
|--------------|---------------------------|
| 0x01         | requestSeed level 1       |
| 0x02         | sendKey level 1           |
| 0x03         | requestSeed level 2       |
| 0x04         | sendKey level 2           |
| ...          | ...                       |
| 0x41         | requestSeed level 33      |
| 0x42         | sendKey level 33          |

### ReadDTCInformation (0x19) Sub-functions

| Sub-function | Description                                          |
|--------------|------------------------------------------------------|
| 0x01         | reportNumberOfDTCByStatusMask                        |
| 0x02         | reportDTCByStatusMask                                |
| 0x03         | reportDTCSnapshotIdentification                      |
| 0x04         | reportDTCSnapshotRecordByDTCNumber                   |
| 0x05         | reportDTCStoredDataByRecordNumber                    |
| 0x06         | reportDTCExtDataRecordByDTCNumber                    |
| 0x07         | reportNumberOfDTCBySeverityMaskRecord                |
| 0x08         | reportDTCBySeverityMaskRecord                        |
| 0x09         | reportSeverityInformationOfDTC                       |
| 0x0A         | reportSupportedDTC                                   |
| 0x0B         | reportFirstTestFailedDTC                             |
| 0x0C         | reportFirstConfirmedDTC                              |
| 0x0D         | reportMostRecentTestFailedDTC                        |
| 0x0E         | reportMostRecentConfirmedDTC                         |
| 0x0F         | reportMirrorMemoryDTCByStatusMask                    |
| 0x10         | reportMirrorMemoryDTCExtDataRecordByDTCNumber        |
| 0x11         | reportNumberOfMirrorMemoryDTCByStatusMask            |
| 0x12         | reportNumberOfEmissionsOBDDTCByStatusMask            |
| 0x13         | reportEmissionsOBDDTCByStatusMask                    |
| 0x14         | reportDTCFaultDetectionCounter                       |
| 0x15         | reportDTCWithPermanentStatus                         |
| 0x16         | reportDTCExtDataRecordByRecordNumber                 |
| 0x17         | reportUserDefMemoryDTCByStatusMask                   |
| 0x18         | reportUserDefMemoryDTCSnapshotRecordByDTCNumber      |
| 0x19         | reportUserDefMemoryDTCExtDataRecordByDTCNumber       |
| 0x42         | reportWWHOBDDTCByMaskRecord                          |
| 0x55         | reportWWHOBDDTCWithPermanentStatus                   |

### RoutineControl (0x31) Sub-functions

| Sub-function | Description                |
|--------------|---------------------------|
| 0x01         | startRoutine              |
| 0x02         | stopRoutine               |
| 0x03         | requestRoutineResults     |

## Common Routine Identifiers

| Routine ID | Description                                    |
|-----------|------------------------------------------------|
| 0x0202    | Erase Memory                                   |
| 0x0203    | Check Programming Dependencies                 |
| 0x0204    | Check Programming Pre-Conditions               |
| 0xFF00    | Erase Memory                                   |
| 0xFF01    | Check Programming Dependencies                 |
| 0xF000    | Check Pre-Conditions                           |
| 0xF001    | Component Present                              |
| 0xF002    | Control DTC Setting                            |
| 0xF003    | Control Communication                          |

## Message Format

### Request Message Format
```
[A_PCI] [SID] [Sub-function/Parameters] [Data]
```

### Positive Response Format
```
[A_PCI] [SID + 0x40] [Sub-function/Parameters] [Response Data]
```

### Negative Response Format
```
[A_PCI] [0x7F] [SID] [NRC]
```

## Timing Parameters

| Parameter | Description                          | Default Value |
|-----------|--------------------------------------|---------------|
| P2        | ECU response time                    | 50 ms         |
| P2*       | Enhanced response time               | 5000 ms       |
| S3        | Time for session timeout             | 5000 ms       |
| P3        | Time between tester present messages | < S3          |

## Security Access Levels

| Level | Typical Use                              |
|-------|------------------------------------------|
| 1-2   | Read access to protected data            |
| 3-4   | Write access to protected data           |
| 5-6   | Flash programming                        |
| 7-8   | Special functions                        |
| 9-10  | EOL (End of Line) programming            |
| 11+   | Manufacturer specific                    |

## DTC Status Bits (ISO 14229-1)

| Bit | Name                                      | Description |
|-----|-------------------------------------------|-------------|
| 0   | testFailed                                | Test failed during current operation cycle |
| 1   | testFailedThisOperationCycle              | Test failed at least once this cycle |
| 2   | pendingDTC                                | Test failed but not confirmed |
| 3   | confirmedDTC                              | DTC is confirmed |
| 4   | testNotCompletedSinceLastClear            | Test not completed since last clear |
| 5   | testFailedSinceLastClear                  | Test failed at least once since last clear |
| 6   | testNotCompletedThisOperationCycle        | Test not completed this cycle |
| 7   | warningIndicatorRequested                 | Warning indicator is requested |

## Common Manufacturer Extensions

### Extended Sessions (Manufacturer Specific)

| Session ID | Common Use                           |
|-----------|--------------------------------------|
| 0x60      | EOL (End of Line) Session            |
| 0x61      | Development Session                  |
| 0x62      | Workshop Session                     |
| 0x63      | Engineering Session                  |
| 0x65      | Flash Programming Session            |
| 0x66      | Calibration Session                  |
| 0x67      | Safety System Programming            |

### Manufacturer Specific Services

| SID Range | Typical Use                          |
|-----------|--------------------------------------|
| 0xB0-0xB9 | Manufacturer diagnostic services     |
| 0xBA-0xBE | Manufacturer network services        |
| 0xBF      | Reserved                             |