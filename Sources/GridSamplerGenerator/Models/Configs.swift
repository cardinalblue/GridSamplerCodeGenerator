//
//  Configs.swift
//  GridSamplerGenerator
//
//  Created by Chiaote Ni on 2022/4/29.
//

import Foundation

final class Configs {

    static var shared = Configs()

    var sourcePath: String = "./Sample.json"
    var exportPath: String = "./Output.cpp"
    var hppTemplatePath: String = "./Template/Sampler.hpp"
    var cppTemplatePath: String = "./Template/Sampler.cpp"
    var samplerName: String = "NEW"
}
