//
//  Headline.swift
//  NYTimes_headlines
//
//  Created by Heli Sivunen on 31/08/2021.
//

import Foundation

struct Headline: Codable {
    var title: String
    var abstract: String
    var url: URL
}
