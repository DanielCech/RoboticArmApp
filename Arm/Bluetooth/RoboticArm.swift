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
    }
    
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
        
        if let stringValue = String(data: characteristic.value!, encoding: .utf8), stringValue == "Finished" {
//            RobotState.shared.movementCompletionTimer?.invalidate()
//            RobotState.shared.movementCompletionTimer = nil
            RobotState.shared.movementCompletion?()
            RobotState.shared.movementCompletion = nil
        }
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
