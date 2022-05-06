//
//  CodeGenerator.swift
//  GridSamplerGenerator
//
//  Created by Chiaote Ni on 2022/4/28.
//

import Foundation

private func makeNewLineContent(_ text: String, indents indentAmount: Int) -> String {
    var result = ""
    result += ("\n" + makeIndents(indentAmount) + text)
    return result
}

private func makeIndents(_ count: Int) -> String {
    var result = ""
    let indent = "    "
    for _ in 0 ..< count {
        result += indent
    }
    return result
}

final class CodeGenerator {

    func generateCode(with grids: [Grid]) {
        generateHppFile(with: grids)
        generateCppFile(with: grids)
    }
}

// MARK: Private functions
extension CodeGenerator {

    private func generateHppFile(with grids: [Grid]) {
        let directoryPath = FileManager.default.currentDirectoryPath
        let filePath = directoryPath + "/\(Configs.shared.exportPath)" + "/\(Configs.shared.samplerName)Sampler.hpp"

        let templatePath = FileManager.default.currentDirectoryPath + "/\(Configs.shared.hppTemplatePath)"
        do {
            let content = try String(contentsOfFile: templatePath)
                .replacingOccurrences(of: "${{SamplerName}}", with: Configs.shared.samplerName)
                .replacingOccurrences(of: "${{UpperCaseSamplerName}}", with: Configs.shared.samplerName.uppercased())
            try content.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            debugPrint("💥export cpp file fail", error)
        }
    }

    private func generateCppFile(with grids: [Grid]) {
        let gridsGroup = groupGridsWithSlotCount(grids)
        let code = makeContent(with: gridsGroup)

        let directoryPath = FileManager.default.currentDirectoryPath
        let filePath = directoryPath + "/\(Configs.shared.exportPath)" + "/\(Configs.shared.samplerName)Sampler.cpp"
        do {
            let content = try makeFileContent(with: code, gridsGroupCount: gridsGroup.count)
            try content.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            debugPrint("💥export cpp file fail", error)
        }
    }

    private func groupGridsWithSlotCount(_ grids: [Grid]) -> [[Grid]] {
        var tmpDic: [Int: [Grid]] = [:]
        var maxCount: Int = 0

        for grid in grids {
            let slotsCount = grid.slots.count
            maxCount = max(maxCount, slotsCount)

            if tmpDic[slotsCount] == nil {
                tmpDic[slotsCount] = [grid]
            } else {
                tmpDic[slotsCount]?.append(grid)
            }
        }

        var result: [[Grid]] = Array(repeating: [Grid](), count: maxCount + 1)
        for i in 0 ... maxCount {
            guard let grids = tmpDic[i] else { continue }
            result[i] = grids
        }

        return result
    }

    private func makeContent(with gridsGroup: [[Grid]]) -> String {
        gridsGroup.enumerated().reduce(into: "") { partialResult, elementSet in
            let grids = elementSet.element
            let index = elementSet.offset
            guard !grids.isEmpty else { return }

            partialResult += makeNewLineContent("// ===== For \(index) photo =====", indents: 1)
            + "\n"
            +  makeNewLineContent("tmpGrids.clear();", indents: 1)
            grids.forEach { grid in
                partialResult += "\n" + grid.export()
            }
            partialResult += makeNewLineContent("mBucket[\(index)] = tmpGrids;\n", indents: 1)
        }
    }

    private func makeFileContent(with code: String, gridsGroupCount: Int) throws -> String {
        let templatePath = FileManager.default.currentDirectoryPath + "/\(Configs.shared.cppTemplatePath)"
        let template = try String(contentsOfFile: templatePath)
        return template
            .replacingOccurrences(of: "${{Content}}", with: code)
            .replacingOccurrences(of: "${{SamplerName}}", with: Configs.shared.samplerName)
            .replacingOccurrences(of: "${{LowerCaseSamplerName}}", with: Configs.shared.samplerName.lowercased())
            .replacingOccurrences(of: "${{GridCount}}", with: "\(gridsGroupCount)")
    }
}

// MARK: - Slot extension about code generation

private extension Grid {

    func export() -> String {
        var content = makeNewLineContent("tmpGrids.push_back(Grid(gGridName + \"\(gridName)\"));", indents: 1)
        slots.forEach { slot in
            content += slot.export(isFilled: isFilled)
        }
        return content
    }
}

extension Slot {

    func export(isFilled: Bool) -> String {
        if let dPath = dPath {
            return exportSVG(with: dPath, isFilled: isFilled)
        } else {
            return exportRectangle(isFilled: isFilled)
        }
    }

    private func exportSVG(with dPath: String, isFilled: Bool) -> String {

        var result: String = makeNewLineContent(
            "tmpGrids.back().slots.push_back(RectSlot(",
            indents: 1
        ) + makeNewLineContent(
            "\(boundingBox.minX)f, \(boundingBox.minY)f, \(boundingBox.width)f, \(boundingBox.height)f, ",
            indents: 2
        )

        if let layer = layer {
            result += makeNewLineContent("\(layer), ", indents: 2)
        } else {
            result += makeNewLineContent("0, ", indents: 2)
        }

        result += makeNewLineContent("\(isFilled), ", indents: 2)
        + makeNewLineContent("\"\(dPath)\")", indents: 2)
        + makeNewLineContent(");", indents: 1)

        return result
    }

    private func exportRectangle(isFilled: Bool) -> String {
        let rect: String = "\(boundingBox.minX)f, \(boundingBox.minY)f, \(boundingBox.width)f, \(boundingBox.height)f"
        return "\n    tmpGrids.back().slots.push_back(RectSlot(\(rect)));"
    }
}
