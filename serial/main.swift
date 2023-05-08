//
//  main.swift
//  serial
//
//  Created by Mikey on 08/05/2023.
//

import Foundation
import AppKit
// AppKit needed to access NSPasteboard

/// Retrieves the serial number of the current macOS device.
///
/// This function accesses the I/O Registry to get the serial number of the device
/// from the "IOPlatformExpertDevice" entry. If successful, the serial number is
/// returned as a String. If the process fails at any point, it returns `nil`.
///
/// - Returns: An optional `String` containing the serial number of the device, or `nil` if retrieval fails.
func getSerialNumber() -> String? {
    let platformExpert = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice") )
   
    // Check if the platformExpert value is valid
    guard platformExpert != IO_OBJECT_NULL else {
        return nil
    }
    
    // Get the serial number property
    guard let serialNumber = (IORegistryEntryCreateCFProperty(platformExpert,
                                kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? String) else {
//        https://stackoverflow.com/a/29049072
        return nil
  }

  IOObjectRelease(platformExpert)
  return serialNumber
}

if let serialNumber = getSerialNumber() {
    print(serialNumber)
    
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    // Clear the pasteboard of previous contents
    pasteboard.setString(serialNumber, forType: .string)
    // Copy the serial number to the pasteboard
    exit(0)
} else {
    print("Failed to retrieve serial number")
    exit(1)
}

