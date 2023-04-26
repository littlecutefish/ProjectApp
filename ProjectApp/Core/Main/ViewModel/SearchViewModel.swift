//
//  SearchViewModel.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/25.
//

import Foundation

class SearchViewModel: ObservableObject {
    
    // Published variable
    @Published var merchantName: String = ""
    @Published var searchedMerchant: [MerchantInfoModel] = []
    
    // Private variable
    private var getMerchantURL = "http://120.126.151.186/API/eating/user/customer/keyName"
    
    // Pubilc function
    func searchMerchantName() {
        let merchantInfo = MerchantInfoModel(name: merchantName)
        searchedMerchant = []
        
        Task {
            let searchResult = await DatabaseManager.shared.uploadData(to: getMerchantURL, data: merchantInfo, httpMethod: "POST")
            
            switch searchResult {
            case .success(let returnedResult):
                let returnedData = returnedResult.0
                guard let merchantInfo = try? JSONDecoder().decode([MerchantInfoModel].self, from: returnedData) else {
                    return
                }
                await MainActor.run {
                    searchedMerchant = merchantInfo
                }
                print("success")
                print(merchantInfo)
                
            case .failure(let errorStatus):
                print(errorStatus.rawValue)
                print("failure")
            }
            print(merchantName)
        }
    }
}
