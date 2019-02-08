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

    private var _valueX = MutableProperty<Int>(0)
    private var _valueY = MutableProperty<Int>(0)
    private var _valueZ = MutableProperty<Int>(0)
    private var _valueAngle = MutableProperty<Int>(0)
    private var _valuePump = MutableProperty<Bool>(false)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        _knobX.valueSignal.observeValues { [weak self] value in
            self?._labelX.text = "X:\n\(Int(value))"
            self?._valueX.value = Int(value)
        }

        _knobY.valueSignal.observeValues { [weak self] value in
            self?._labelY.text = "Y:\n\(Int(value))"
            self?._valueY.value = Int(value)
        }

        _knobZ.valueSignal.observeValues { [weak self] value in
            self?._labelZ.text = "Z:\n\(Int(value))"
            self?._valueZ.value = Int(value)
        }

        _knobAngle.valueSignal.observeValues { [weak self] value in
            self?._labelAngle.text = "Angle:\n\(Int(value))"
            self?._valueAngle.value = Int(value)
        }

        _pumpSwitch.reactive.isOnValues.signal.observeValues { [weak self] value in
            self?._valuePump.value = value
        }

        _valueX.value = 0
        _valueY.value = 0
        _valueZ.value = 0
        _valueAngle.value = 0
        _valuePump.value = false

        SignalProducer.combineLatest(_valueX.producer, _valueY.producer, _valueZ.producer, _valueAngle.producer, _valuePump.producer)
            .throttle(0.2, on: QueueScheduler(qos: .default, name: "search", targeting: DispatchQueue.main))
            .startWithValues { [weak self] (x, y, z, angle, pump) in
                self?._updateRoboticArm()
            }

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icon-Connect")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(ControlsViewController._connect))
    }

    private func _updateRoboticArm() {
        ConnectionManager.shared.control(x: _valueX.value, y: _valueY.value, z: _valueZ.value, angle: _valueAngle.value, pump: _valuePump.value)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc private func _connect() {
        ConnectionManager.shared.startScan()
    }

}
