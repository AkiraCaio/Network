//
//  ViewController.swift
//  NetworkSample
//
//  Created by Caio Vinicius Pinho Vasconcelos on 21/05/23.
//

import UIKit
import Network

enum TestRequest {
    case showCap
}

extension TestRequest: Endpoint {
    var host: String {
        "0.0.0.0"
    }

    var path: String {
        "/test"
    }

    var port: Int? {
        3001
    }

    var method: Network.RequestMethod {
        .get
    }

    var header: [String : String]? {
        nil
    }

    var queryParameters: [String : String]? {
        return ["origem": "caio"]
    }

    var bodyParameters: [String : Any]? {
        nil
    }

    var scheme: String {
        "http"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Task.detached {
            let result = await DefaultNetworkService().request(endpoint: TestRequest.showCap)
            print(result)
        }
    }
}
