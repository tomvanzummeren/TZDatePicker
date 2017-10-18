//
//  ViewController.swift
//  TZDatePicker
//
//  Created by Tom van Zummeren on 18/10/2017.
//  Copyright © 2017 Tom van Zummeren. All rights reserved.
//

import UIKit
import TZDatePicker

class ViewController: UIViewController {

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    private lazy var dateFormatterWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        var dateComponents = DateComponents()
        dateComponents.month = 7
        dateComponents.day = 20
        
        let datePicker = TZDatePicker(dateComponents: dateComponents)
        datePicker.onValueChanged = {
            dateComponents in
            self.updateLabel(dateComponents)
        }
        updateLabel(dateComponents)
        
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -20).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func updateLabel(_ dateComponents: DateComponents) {
        guard let date = Calendar.current.date(from: dateComponents) else { return }
        
        let string: String
        if dateComponents.year != nil {
            string = dateFormatterWithYear.string(from: date)
        } else {
            string = dateFormatter.string(from: date)
        }
        label.text = "Selected: \(string)"
    }
}

