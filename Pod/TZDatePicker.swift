
import UIKit

public class TZDatePicker: UIControl {
    
    public var dateComponents: DateComponents {
        didSet {
            if !dateComponents.isValidDate {
                while !dateComponents.isValidDate {
                    if let day = dateComponents.day {
                        dateComponents.day = day - 1
                    }
                }
            }
            updatePickerView(animated: true)
            onValueChanged?(dateComponents)
        }
    }
    
    private let pickerView: UIPickerView
    
    public var onValueChanged: ((DateComponents) -> Void)?
    
    public var locale = Locale.current {
        didSet {
            configureLocale()
            pickerView.reloadAllComponents()
        }
    }
    
    private var calendar = Calendar.current
    
    private var monthSymbols = [String]()
    
    private var monthComponent = 0
    
    private var dayComponent = 1

    private var yearComponent = 2
    
    private var currentYear = 1980
    
    private var numberOfMonths: Int {
        return monthSymbols.count
    }
    
    private let numberOfDays = 31
    
    private let repeatCount = 1000
    
    private var monthComponentWidth: CGFloat = 100
    
    public init(dateComponents: DateComponents) {
        self.dateComponents = dateComponents
        pickerView = UIPickerView(frame: .zero)
        
        self.dateComponents.calendar = calendar
        
        super.init(frame: .zero)
        
        configureLocale()
        addSubview(pickerView)
        pickerView.delegate = self
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pickerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        pickerView.selectRow((repeatCount * numberOfMonths) / 2, inComponent: monthComponent, animated: false)
        pickerView.selectRow((repeatCount * numberOfDays) / 2, inComponent: dayComponent, animated: false)
        updatePickerView()
    }
    
    public convenience init() {
        self.init(date: Date())
    }
    
    public convenience init(date: Date) {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .calendar], from: date)
        self.init(dateComponents: dateComponents)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updatePickerView(animated: Bool = false) {
        if let month = dateComponents.month {
            let repeatCount = pickerView.selectedRow(inComponent: monthComponent) / numberOfMonths
            pickerView.selectRow((repeatCount * numberOfMonths) + month - 1, inComponent: monthComponent, animated: animated)
        }
        
        if let day = dateComponents.day {
            let repeatCount = pickerView.selectedRow(inComponent: dayComponent) / numberOfDays
            pickerView.selectRow((repeatCount * numberOfDays) + day - 1, inComponent: dayComponent, animated: animated)
        }
        
        if let year = dateComponents.year {
            pickerView.selectRow(min(year - 1, currentYear - 1), inComponent: yearComponent, animated: animated)
        } else {
            // Selects the "----" option
            pickerView.selectRow(currentYear, inComponent: yearComponent, animated: animated)
        }
    }
    
    private func configureLocale() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = locale
        monthSymbols = formatter.monthSymbols ?? []
        
        // Determine order of date components
        let date = Date()
        let string = formatter.string(from: date)
         if self.string(string, startsWith: monthSymbols) {
            monthComponent = 0
            dayComponent = 1
        } else {
            dayComponent = 0
            monthComponent = 1
        }
        
        // Determine current year
        let components = calendar.dateComponents([.year], from: date)
        if let year = components.year {
            currentYear = year
        }
        
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25)
        ]
        monthComponentWidth = 0
        for monthSymbol in monthSymbols {
            let width = monthSymbol.size(withAttributes: attributes).width
            if width > monthComponentWidth {
                monthComponentWidth = width
            }
        }
    }
    
    private func string(_ string: String, startsWith matches: [String]) -> Bool {
        for match in matches {
            if string.starts(with: match) {
                return true
            }
        }
        return false
    }
}

extension TZDatePicker: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case monthComponent:
            return monthComponentWidth + 10
        case dayComponent:
            return 75
        case yearComponent:
            return 75
        default:
            return 0
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let attributes: [NSAttributedStringKey: Any] = [
            .paragraphStyle: paragraphStyle,
        ]
        
        switch component {
        case monthComponent:
            return NSAttributedString(string: monthSymbols[row % numberOfMonths], attributes: attributes)
        case dayComponent:
            let day = (row % numberOfDays) + 1
            return NSAttributedString(string: "\(day)")
        case yearComponent:
            let year = row + 1
            return NSAttributedString(string: year > currentYear ? "----" : "\(year)")
        default:
            return nil
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case monthComponent:
            let month = row % numberOfMonths + 1
            dateComponents.month = month
        case dayComponent:
            let day = (row % numberOfDays) + 1
            dateComponents.day = day
        case yearComponent:
            let year = row + 1
            if year > currentYear {
                dateComponents.year = nil
            } else {
                dateComponents.year = year
            }
        default:
            break
        }
    }
}

extension TZDatePicker: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case monthComponent:
            return numberOfMonths * repeatCount
        case dayComponent:
            return numberOfDays * repeatCount
        case yearComponent:
            return currentYear + 1
        default:
            return 0
        }
    }
}
