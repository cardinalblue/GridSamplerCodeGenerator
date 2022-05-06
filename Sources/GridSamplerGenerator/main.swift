#!/usr/bin/swift

import Foundation

private func makeURL(with subPath: String) -> URL {
    let filePath = Process().currentDirectoryPath + "/" + subPath
    return URL(fileURLWithPath: filePath)
}

private func generateCode(with subPath: String?) {
    guard let subPath = subPath else {
        print("Need path as the first parameter")
        return
    }
    let url = makeURL(with: subPath)
    let grids = GridGenerator().makeGrids(with: url)
    guard !grids.isEmpty else {
        print("Load Grids fail")
        return
    }
    CodeGenerator().generateCode(with: grids)
}

private func setUpConfigs() throws {
    let fileURL = makeURL(with: "Config.json")
    let data = try Data(contentsOf: fileURL)
    let object = try JSONSerialization.jsonObject(with: data, options: [])

    guard let dic = object as? [String: String] else {
        throw NSError(
            domain: NSCocoaErrorDomain,
            code: NSCoderReadCorruptError,
            userInfo: [
                NSLocalizedDescriptionKey: "💥Config decode type fail, it's \(object)"
            ]
        )
    }

    let config = Configs.shared
    if let sourcePath = dic["source_path"] {
        config.sourcePath = sourcePath
    }
    if let exportPath = dic["export_path"] {
        config.exportPath = exportPath
    }
    if let hppTemplatePath = dic["hpp_template_path"] {
        config.hppTemplatePath = hppTemplatePath
    }
    if let cppTemplatePath = dic["cpp_template_path"] {
        config.cppTemplatePath = cppTemplatePath
    }
    if let samplerName = dic["sampler_name"] {
        config.samplerName = samplerName
    }
}

do {
    try setUpConfigs()
} catch {
    debugPrint(error)
    exit(0)
}

//let arguments = CommandLine.arguments.dropFirst()
generateCode(with: Configs.shared.sourcePath)
