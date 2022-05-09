//
//  GridGenerator.swift
//  GridSamplerGenerator
//
//  Created by Chiaote Ni on 2022/4/28.
//

import Foundation

final class GridGenerator {

    func makeGrids(with jsonFileURL: URL) -> [Grid] {
        do {
            let data: Data = try fetchData(with: jsonFileURL)
            let grid: [Grid] = try decodeModel(with: data)
            return grid
        } catch {
            return []
        }
    }
}

// MARK: Private functions
extension GridGenerator {

    private func fetchData(with url: URL) throws -> Data {
        do {
            return try Data(contentsOf: url)
        } catch {
            debugPrint("fetch data fail: ", error)
            throw error
        }
    }

    private func decodeModel(with data: Data) throws -> [Grid] {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Grid].self, from: data)
        } catch {
            debugPrint("decode data fail: ", error)
            throw error
        }
    }
}

// MARK: - Slot extension about decode from JSON file

extension Grid: Decodable {

    private enum CodingKeys: String, CodingKey {
        case name, slots, width, height, isVip, isFilled
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gridName = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        width = try container.decode(Float.self, forKey: .width)
        height = try container.decode(Float.self, forKey: .height)
        isVip = try container.decode(Bool.self, forKey: .isVip)
        isFilled = try container.decode(Bool.self, forKey: .isFilled)

        var slots: [Slot] = []
        var slotsContainer = try container.nestedUnkeyedContainer(forKey: .slots)

        while slotsContainer.isAtEnd == false {
            do {
                let rectSlot = try slotsContainer.decode(Slot.self)
                slots.append(rectSlot)
            } catch {
                let text = try slotsContainer.decode(String.self)
                throw NSError(
                    domain: NSCocoaErrorDomain,
                    code: NSCoderReadCorruptError,
                    userInfo: [
                        NSLocalizedDescriptionKey: "💥Grid decode fail, find a new structor: \(text)"
                    ]
                )
            }
        }
        self.slots = slots
    }
}

extension Slot: Decodable {

    private enum CodingKeys: String, CodingKey {
        case rect, path
        case layer
        case relatedPhotoId = "related_photo_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dPath = try container.decodeIfPresent(String.self, forKey: .path)
        layer = try container.decodeIfPresent(Int.self, forKey: .layer)
        relatedPhotoId = try container.decodeIfPresent(Float.self, forKey: .relatedPhotoId)

        var rectContainer = try container.nestedUnkeyedContainer(forKey: .rect)
        let origin = try rectContainer.decode([Float].self)
        let size = try rectContainer.decode([Float].self)
        let getValue: (_ array: [Float], _ index: Int) -> CGFloat? = { array, index in
            guard
                let value = array[safe: index]
            else {
                debugPrint("💥Decode slot fail, error occur while decoding rect from slot, get value at index \(index) from: ", array)
                return nil
            }
            return CGFloat(value)
        }
        guard
            var x = getValue(origin, 0),
            var y = getValue(origin, 1),
            var width = getValue(size, 0),
            var height = getValue(size, 1)
        else {
            throw NSError(
                domain: NSCocoaErrorDomain,
                code: NSCoderReadCorruptError,
                userInfo: [NSLocalizedDescriptionKey: "💥Decode slot fail, origin=\(origin), size= \(size)"]
            )
        }

        guard dPath == nil else {
            boundingBox = CGRect(x: x, y: y, width: width, height:  height)
            return
        }

        let makeBoundaryAlignedValue: (_ value: CGFloat) -> CGFloat = { value in
            if value > 639 {
                return 640
            } else if value < 1 {
                return 0
            } else {
                return value
            }
        }

        x = makeBoundaryAlignedValue(x)
        let maxX = makeBoundaryAlignedValue(x + width)
        width = maxX - x

        y = makeBoundaryAlignedValue(y)
        let maxY = makeBoundaryAlignedValue(y + height)
        height = maxY - y

        boundingBox = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
    }
}
