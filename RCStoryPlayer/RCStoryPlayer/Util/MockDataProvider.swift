//
//  MockDataProvider.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 27.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import PromiseKit

class MockDataProvider {
    
    // MARK: - Properties
    static var shared = MockDataProvider()
    private let jsonReader: JsonReader = .init()
    
    // MARK: - Life Cycle
    private init(){}
    
    // MARK: - Retrieve
    func retrieve<T: Codable>(from fileName: String, _ returnType: T.Type) -> Promise<T>{
        jsonReader.read(fileName: fileName, type: returnType)
    }
  
    enum JSONError: Error{
        case keyNotFound, valueNotFound, typeMisMatch, dataNil, fileNotFound, corrupted
    }

    class JsonReader {
        
        func read<T: Codable>(fileName: String, type: T.Type) -> Promise<T> {
            Promise { seal in
                guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                    seal.reject(JSONError.fileNotFound)
                    return;
                }

                do{
                    let data = try Data(contentsOf: url)
                    let info = try JSONDecoder().decode(T.self, from: data)
                    seal.fulfill(info)
                } catch DecodingError.keyNotFound(_, let context) {
                    print(context.codingPath)
                    seal.reject(JSONError.keyNotFound)
                } catch DecodingError.valueNotFound(_, let context){
                    print(context.codingPath)
                    seal.reject(JSONError.valueNotFound)
                }catch DecodingError.typeMismatch(_, let context){
                    print(context.codingPath)
                    seal.reject(JSONError.typeMisMatch)
                }catch{
                    seal.reject(JSONError.dataNil)
                }
            }
        }
    }
}
