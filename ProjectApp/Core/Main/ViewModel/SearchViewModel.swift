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
    @Published var showedMerchant: MerchantInfoModel = MerchantInfoModel(customerUid: "", merchantUid: "",name: "")
    @Published var myFavMerchants: [MerchantInfoModel] = []
    
    // Private variable
    private var searchMerchantURL = "http://120.126.151.186/API/eating/user/customer/keyName"
    private var getMerchantURL = "http://120.126.151.186/API/eating/user/customer/getDetails"
    private var getMyFavListURL = "http://120.126.151.186/API/eating/user/customer/favorite"
    private var putIntoMyFavListURL = "http://120.126.151.186/API/eating/user/customer/favorite"
    
    // Pubilc function
    func searchMerchantName() {
        let merchantInfo = MerchantInfoModel(customerUid: ShareInfoManager.shared.uid, merchantUid: "", name: merchantName)
        searchedMerchant = []
        
        Task {
            let searchResult = await DatabaseManager.shared.uploadData(to: searchMerchantURL, data: merchantInfo, httpMethod: "POST")
            
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
        }
    }
    
    func getMerchantInfo(uid: String) {
        let merchantInfo = MerchantInfoModel(customerUid: "", merchantUid: "", uid: uid, name: "", phoneNumber: "", location: "", intro: "", photo: "", favorite: false)
        Task {
            let searchResult = await DatabaseManager.shared.uploadData(to: getMerchantURL, data: merchantInfo, httpMethod: "POST")
            
            switch searchResult {
            case .success(let returnedResult):
                let returnedData = returnedResult.0
                guard let merchantInfo = try? JSONDecoder().decode(MerchantInfoModel.self, from: returnedData) else {
                    return
                }
                await MainActor.run {
                    showedMerchant = merchantInfo
                }
                print("success")
                print(showedMerchant)
                
            case .failure(let errorStatus):
                print(errorStatus.rawValue)
            }
            
        }
    }
    
    func getMyFavList() {
        let merchantInfo = MerchantInfoModel(customerUid: ShareInfoManager.shared.uid, merchantUid: "", name: "")
        Task {
            let listResult = await DatabaseManager.shared.uploadData(to: getMyFavListURL, data: merchantInfo, httpMethod: "POST")
            
            switch listResult {
            case .success(let returnedResult):
                let returnData = returnedResult.0
                guard let merchantInfo = try? JSONDecoder().decode([MerchantInfoModel].self, from: returnData) else {
                    return
                }
                await MainActor.run{
                    myFavMerchants = merchantInfo
                }
                print(merchantInfo)
                
            case .failure(let errorStatus):
                print(errorStatus.rawValue)
            }
            
        }
        
    }
    
    func putIntoMyFavList(customerUid: String, merchantUid: String) {
        let merchantInfo = MerchantInfoModel(customerUid: customerUid, merchantUid: merchantUid, name: "")
        print(customerUid)
        print(merchantUid)
        Task {
            let savedResult = await DatabaseManager.shared.uploadData(to: putIntoMyFavListURL, data: merchantInfo, httpMethod: "PUT")
            
            switch savedResult {
            case .success(let returnedResult):
                switch returnedResult.1 {
                case 200:
                    print("✅ Create Success")
                    break
                default:
                    print(returnedResult.1)
                }
                
            case .failure(let errorStatus):
                print("Create Error: \(errorStatus.rawValue)")
            }
            
        }
    }
    
}
