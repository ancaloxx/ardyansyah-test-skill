//
//  APIManager.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 05/01/24.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shareInstance = APIManager()
    
    func callingRegisterAPI(register: Register, completion: @escaping(AnyObject) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(urlRegister, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    debugPrint(json)
                    completion(json as AnyObject)
                } catch {
                    print(String(describing: error))
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func callingLoginAPI(login: Login, completion: @escaping(AnyObject) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(urlLogin, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    debugPrint(json)
                    completion(json as AnyObject)
                } catch {
                    print(String(describing: error))
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func callingListProductAPI(key: String, listProduct: ListProduct, completion: @escaping(AnyObject, ProductData) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(key)
        ]
        
        AF.request(urlListProduct, method: .get, parameters: listProduct, encoder: URLEncodedFormParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    debugPrint(json as AnyObject)
                    let jsonData = try JSONDecoder().decode(ProductData.self, from: data!)
                    completion(json as AnyObject, jsonData)
                    
                } catch {
                    print(String(describing: error))
                    let errorObject: [String: Any] = [
                        "code": "22222"
                    ]
                    
                    completion(errorObject as AnyObject, ProductData())
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func callingCreateProductAPI(key: String, product: Items, completion: @escaping(AnyObject) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(key)
        ]
        
        AF.request(urlCreateProduct, method: .post, parameters: product, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    debugPrint(json)
                    
                    completion(json as AnyObject)
                } catch {
                    print(String(describing: error))
                    let errorObject: [String: Any] = [
                        "code": "22222",
                    ]
                    
                    completion(errorObject as AnyObject)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func callingDeleteProduct(key: String, id: Int, completion: @escaping(AnyObject) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(key)
        ]
        
        AF.request("\(urlDeleteProduct)\(id)/delete", method: .delete, parameters: nil, headers: headers).response { response in
            print("\(urlDeleteProduct)\(id)/delete")
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    debugPrint(json)
                    
                    completion(json as AnyObject)
                } catch {
                    print(error.localizedDescription)
                    print(String(describing: error))
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func callingUpdateProduct(key: String, id: Int, product: Items, completion: @escaping(AnyObject) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(key)
        ]
        
        AF.request("\(urlUpdateProduct)\(id)", method: .post, parameters: product, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            print("\(urlDeleteProduct)\(id)")
            
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    debugPrint(json)
                    
                    completion(json as AnyObject)
                } catch {
                    print(String(describing: error))
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func callingUpdateVariant(key: String, id: Int, variant: VariantsData, completion: @escaping(AnyObject) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(key)
        ]
        
        AF.request("\(urlUpdateProduct)\(id)", method: .post, parameters: variant, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    debugPrint(json)
                    
                    completion(json as AnyObject)
                } catch {
                    print(String(describing: error))
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}
