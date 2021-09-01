//
//  ContentView.swift
//  NYTimes_headlines
//
//  Created by Heli Sivunen on 31/08/2021.
//

import SwiftUI

//start of Plist section

private var API_KEY: String {

    get {
        
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find plist file.")
        }
let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
    return value
    }
}

//end of Plist section

//start of API call properties section
struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var title: String
    var abstract: String
    var url: String
}
//end of API call properties section

//start of view section
struct ContentView: View {
    @State var results = [Result]()
    
     var body: some View {
        Spacer()
        Spacer()
        Text("New York Times top stories")
            .font(.title2)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .foregroundColor(.black)
        
        List(results, id: \.title) { item in VStack(alignment: .leading) {

            Text(item.title)
                .font(.headline)
            Text(item.abstract)
                .font(.subheadline)
        
                Text(item.url)
            }
        }
        .onAppear(perform: loadData)
    }

//start of actual API call
    func loadData() {
        
        guard let url = URL(string: "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=\(API_KEY)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    return
                }
            }
            print("Fetch failed \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
// end of API call
}

//preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
//end of Contentview
  }

