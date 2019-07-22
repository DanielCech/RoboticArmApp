//
//  ControlsViewController.swift
//  ArmView
//
//  Created by Dan on 26.05.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ControlsViewController: UIViewController {
    
    @IBOutlet @objc private weak var _knobAngle: LiveKnob!
    @IBOutlet @objc private weak var _knobX: LiveKnob!
    @IBOutlet @objc private weak var _knobY: LiveKnob!
    @IBOutlet @objc private weak var _knobZ: LiveKnob!
    @IBOutlet @objc private weak var _pumpSwitch: UISwitch!
    
    @IBOutlet weak var _labelX: UILabel!
    @IBOutlet weak var _labelY: UILabel!
    @IBOutlet weak var _labelZ: UILabel!
    @IBOutlet weak var _labelAngle: UILabel!
    
    private var _knobXObservation: NSKeyValueObservation!
    private var _knobYObservation: NSKeyValueObservation!
    private var _knobZObservation: NSKeyValueObservation!
    private var _knobAngleObservation: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeComponents()
        
        // Do any additional setup after loading the view.
        
        RobotState.shared.valueX.signal.observeValues { [weak self] value in
            DispatchQueue.main.async {
                self?._knobX.value = value
                self?._labelX.text = "X:\n\(Int(value))"
            }
        }
        
        RobotState.shared.valueY.signal.observeValues { [weak self] value in
            DispatchQueue.main.async {
                self?._knobY.value = value
                self?._labelY.text = "Y:\n\(Int(value))"
            }
        }
        
        RobotState.shared.valueZ.signal.observeValues { [weak self] value in
            DispatchQueue.main.async {
                self?._knobZ.value = value
                self?._labelZ.text = "Z:\n\(Int(value))"
            }
        }
        
        RobotState.shared.valueAngle.signal.observeValues { [weak self] value in
            DispatchQueue.main.async {
                self?._knobAngle.value = value
                self?._labelAngle.text = "Angle:\n\(Int(value))"
            }
        }
        
        RobotState.shared.valuePump.signal.observeValues { [weak self] value in
            DispatchQueue.main.async {
                self?._pumpSwitch.isOn = value
            }
            
        }
        
        
        /////////////////////////////////////
        
        _knobX.valueSignal.observeValues { [weak self] value in
            self?._labelX.text = "X:\n\(Int(value))"
            RobotState.shared.valueX.value = value
            RobotState.shared.immediately = false
        }
        
        _knobY.valueSignal.observeValues { [weak self] value in
            self?._labelY.text = "Y:\n\(Int(value))"
            RobotState.shared.valueY.value = value
            RobotState.shared.immediately = false
        }
        
        _knobZ.valueSignal.observeValues { [weak self] value in
            self?._labelZ.text = "Z:\n\(Int(value))"
            RobotState.shared.valueZ.value = value
            RobotState.shared.immediately = false
        }
        
        _knobAngle.valueSignal.observeValues { [weak self] value in
            self?._labelAngle.text = "Angle:\n\(Int(value))"
            RobotState.shared.valueAngle.value = value
            RobotState.shared.immediately = false
        }
        
        _pumpSwitch.reactive.isOnValues.signal.observeValues { value in
            RobotState.shared.valuePump.value = value
            RobotState.shared.immediately = false
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icon-Connect")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(ControlsViewController._connect))
    }
    
    func initializeComponents() {
        _knobX.value = Constants.initialX
        _knobY.value = Constants.initialY
        _knobZ.value = Constants.initialZ
        _knobAngle.value = Constants.initialAngle
        
        _labelX.text = "X:\n\(Int(Constants.initialX))"
        _labelY.text = "Y:\n\(Int(Constants.initialY))"
        _labelZ.text = "Z:\n\(Int(Constants.initialZ))"
        _labelAngle.text = "Angle:\n\(Int(Constants.initialAngle))"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc private func _connect() {
        ConnectionManager.shared.startScan()
    }
    
}
