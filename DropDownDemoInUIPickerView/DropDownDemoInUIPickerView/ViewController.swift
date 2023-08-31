//
//  ViewController.swift
//  DropDownDemoInUIPickerView
//
//  Created by Mac on 31/08/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var statusData = [StatusData]()
    var remarks: [Remark] = []
    
    let statusPickerView = UIPickerView()
    let remarkPickerView = UIPickerView()
    
    @IBOutlet weak var statusField: UITextField!
    @IBOutlet weak var remarkField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataFromStatusApi()
        fetchDataFromRemarkApi()
        
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
        
        remarkPickerView.delegate = self
        remarkPickerView.dataSource = self
        
        statusField.inputView = statusPickerView
        remarkField.inputView = remarkPickerView
        
        addDoneButtonToPickerViews()
    }

    @objc func doneButtonTapped() {
        statusField.resignFirstResponder()
        remarkField.resignFirstResponder()
    }
    
    func addDoneButtonToPickerViews() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        statusField.inputAccessoryView = toolbar
        remarkField.inputAccessoryView = toolbar
    }
    
    func fetchDataFromStatusApi() {
        let apiUrl = "https://test.avantisregtec.in/androidappDIY/Data/statuslist?ComplianceID=1921&Email=VgHyLXtAgFUcHK2G4E4aPLnHgLejklWh75KLICwam5o=&customerID=5&ComplianceinstanceID=437588&ScheduledOnID=3457606"

        let headers: HTTPHeaders = [
            "Authorization": "bearer ltinw9U9RenDK_Q8FFy2iKMyXcMRDv2QQpCwtzrnxFhxK-OXFR-gEACWqV3lISYlH2jlRo82Hovpa7faVPua3nKrNnamzs4jGkBbD_EllHaPsPhL-NsS1PMkW5qQIPhaH5w6ixCuyBJhICZQl5ldO3oYP3Fa5fJXn9TzqdMRuuDzmz__I4jN4GWAlwpFPhorDp7C-vD7hDt-sD7GGdPptTnp_wDSFOEtrLf6fA9XMIIST0eWR_piQwlii1mOQI2eByguDV8CufPiNERESmaC1qXeY8NY-mBeJErpuNWEVZpwtz_bPYPlGaba_dmZUOAI"
        ]

        AF.request(apiUrl, headers: headers)
            .validate()
            .responseDecodable(of: [StatusData].self) { response in
                switch response.result {
                case .success(let status):
                    self.statusData = status
                    self.statusPickerView.reloadAllComponents()
                    case .failure(let error):
                      print(error)
                }
            }

    }
    func fetchDataFromRemarkApi() {
        let apiUrl = "https://test.avantisregtec.in/androidappDIY/Data/GetRemarkList?status=18&CustomerID=100099&ComplianceinstanceID=43267"
        
            let headers: HTTPHeaders = ["Authorization": "bearer ltinw9U9RenDK_Q8FFy2iKMyXcMRDv2QQpCwtzrnxFhxK-OXFR-gEACWqV3lISYlH2jlRo82Hovpa7faVPua3nKrNnamzs4jGkBbD_EllHaPsPhL-NsS1PMkW5qQIPhaH5w6ixCuyBJhICZQl5ldO3oYP3Fa5fJXn9TzqdMRuuDzmz__I4jN4GWAlwpFPhorDp7C-vD7hDt-sD7GGdPptTnp_wDSFOEtrLf6fA9XMIIST0eWR_piQwlii1mOQI2eByguDV8CufPiNERESmaC1qXeY8NY-mBeJErpuNWEVZpwtz_bPYPlGaba_dmZUOAI"
                ]
                
                AF.request(apiUrl, headers: headers).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let json = value as? [String: Any],
                           let responseData = try? JSONSerialization.data(withJSONObject: json),
                           let apiResponse = try? JSONDecoder().decode(APIResponse.self, from: responseData) {
                            self.remarks = apiResponse.data
                            self.remarkPickerView.reloadAllComponents()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == statusPickerView {
            return statusData.count
        } else {
            return remarks.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == statusPickerView && row < statusData.count {
            return statusData[row].Name
        } else if pickerView == remarkPickerView && row < remarks.count {
            return remarks[row].remark
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == statusPickerView {
            statusField.text = statusData[row].Name
        } else {
            remarkField.text = remarks[row].remark
        }
    }
    
}
