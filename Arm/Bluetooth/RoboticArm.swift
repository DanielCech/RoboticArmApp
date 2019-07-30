//
//  RoboticArm.swift
//  OpkixTest
//
//  Created by Džindra on 06/04/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Foundation
import CoreBluetooth




public protocol RoboticArmDelegate: class {
    func deviceReady(device: RoboticArm)
    func deviceUpdated(device: RoboticArm)
    func deviceFailed(device: RoboticArm, error: ArmError)

}

// TODO : split this into OpkixAdvertisedDevice and RoboticArm that will be returned in success block of advertised device after all BLE scanning is done
public class RoboticArm: NSObject {
    // TODO : possibly remove link between manager and device?
    private weak var manager: ConnectionManager?
    private let peripheral: CBPeripheral?
//    private var handlersMap: [CBUUIDPair:OpkixCharHandler] = [:]
    private let queue: DispatchQueue

    private var _controlCharacteristic: CBCharacteristic?
    
    public weak var delegate: RoboticArmDelegate?
//    public internal(set) var advertisingInfo: OpkixAdvertisingInfo
    public internal(set) var rssi: Int
    public var name: String {
        return peripheral?.name ?? "RoboticArmApp"
    }
    
    
    init(manager: ConnectionManager, peripheral: CBPeripheral?, rssi: Int, queue: DispatchQueue) {
        self.peripheral = peripheral
        self.rssi = rssi
        self.manager = manager
        self.queue = queue
        
        super.init()

        peripheral?.delegate = self
        
//        add(handler: BatteryHandler())
//        add(handler: DeviceInfoHandler())
//        add(handler: TimeHandler())
//        add(handler: LidHandler())
//        add(handler: WifiSSIDHandler())
//        add(handler: WifiPasswordHandler())
    }
    
//    func add(handler: OpkixCharHandler) {
//        for pair in handler.handledChars {
//            handlersMap[pair] = handler
//        }
//    }
//
//    // returns handler with specified type
//    func handler<T: OpkixCharHandler>(for handlerType: T.Type) -> T? {
//        return handlersMap.values.first { $0 is T } as? T
//    }

    
    public func connect() {
        guard let peripheral = self.peripheral else { return }
        manager?.connect(peripheral: peripheral)
    }
    
    public func disconnect() {
        guard let peripheral = self.peripheral else { return }
        manager?.disconnect(peripheral: peripheral)
    }
    
    
    // called from manager, do not call directly, assuming all called on internal queue
    
    func didConnect() {
        debugPrint("Did connect called")
        peripheral?.discoverServices(nil)
    }
    
    func didDisconnect(error: Error?) {
        if let unwrappedError = error {
            DispatchQueue.main.async(execute: strongify(weak: self) { strongSelf in
                strongSelf.delegate?.deviceFailed(device: strongSelf, error: .deviceDisconnectError(unwrappedError))
            })
        }
    }
    
    func didFailToConnect(error: Error) {
        DispatchQueue.main.async(execute: strongify(weak: self) { strongSelf in
            strongSelf.delegate?.deviceFailed(device: strongSelf, error: .deviceConnectError(error))
        })
    }
    
    
    // handlers are calling those
    
    func notify(characteristic: CBCharacteristic, enabled: Bool = true) {
        queue.async { [weak self] in
            self?.peripheral?.setNotifyValue(enabled, for: characteristic)
        }
    }
    
    func read(characteristic: CBCharacteristic) {
        queue.async { [weak self] in
            self?.peripheral?.readValue(for: characteristic)
        }
    }
    
    func write(data: Data, for characteristic: CBCharacteristic, type: CBCharacteristicWriteType = .withoutResponse) {
        queue.async { [weak self] in
            self?.peripheral?.writeValue(data, for: characteristic, type: type)
        }
    }
}

extension RoboticArm: CBPeripheralDelegate {
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        self.rssi = RSSI.intValue
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services, error == nil else {
            DispatchQueue.main.async(execute: strongify(weak: self) { strongSelf in
                strongSelf.delegate?.deviceFailed(device: strongSelf, error: .serviceDiscoveryError(error!))
            })
            return
        }
        
        services.forEach {
            peripheral.discoverCharacteristics(nil, for: $0)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let chars = service.characteristics, error == nil else {
            DispatchQueue.main.async(execute: strongify(weak: self) { strongSelf in
                strongSelf.delegate?.deviceFailed(device: strongSelf, error: .characteristicDiscoveryError(error!))
            })
            return
        }
        
//        for char in chars {
//            if let handler = handlersMap[char.uuidPair] {
//                handler.discover(device: self, char: char)
//            } else {
//                debugPrint("Discovered unhandled characteristic")
//            }
//        }


        for characteristic in chars {
            if characteristic.uuid == CBUUID(string: "326a9001-85cb-9195-d9dd-464cfbbae75a") {
                _controlCharacteristic = characteristic
            }
        }

        DispatchQueue.main.async(execute: strongify(weak: self) { strongSelf in
            strongSelf.delegate?.deviceReady(device: strongSelf)
        })
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic)
        
        let string = String(data: characteristic.value!, encoding: .utf8)
        print(string)
//        guard let handler = handlersMap[characteristic.uuidPair] else {
//            debugPrint("Updated unhandled characteristic \(characteristic.uuidPair)  \(characteristic)")
//            return
//        }

//        handler.update(device: self, char: characteristic)

        // TODO : this is a bit hacky. Not every update means device got changed. Maybe introduce return type from update and check it
        DispatchQueue.main.async(execute: strongify(weak: self) { strongSelf in
            strongSelf.delegate?.deviceUpdated(device: strongSelf)
        })
    }

    public func control(command: Command, x: Float, y: Float, z: Float, angle: Float, pump: Bool) {
        guard let controlCharacteristic = _controlCharacteristic else { return }

        let hexString = String(format: "%@%04x%04x%04x%04x%01x", command.rawValue, Int(x*10), Int(y*10), Int(z*10), Int(angle*10), pump)

        let data = hexString.data(using: .ascii)
        peripheral?.writeValue(data!, for: controlCharacteristic, type: .withResponse)
    }
    
    public func checkFinish() {
        guard let controlCharacteristic = _controlCharacteristic else { return }
        peripheral?.readValue(for: controlCharacteristic)
    }
    
}
