class FogRenderer {
    private var tileset: GraphicTileset
    private var map: VisibilityMap
    private var noneIndex: Int
    private var seenIndex: Int
    private var partialIndex: Int
    private var fogIndices: [Int] = []
    private var blackIndices: [Int] = []

    init(tileset: GraphicTileset, map: VisibilityMap) throws {
        let originalValues = [0x0b, 0x16, 0xd0, 0x68, 0x07, 0x94, 0xe0, 0x29, 0x03, 0x06, 0x14, 0x90, 0x60, 0xc0, 0x09, 0x28, 0x01, 0x02, 0x04, 0x10, 0x80, 0x40, 0x20, 0x08]
        self.tileset = tileset
        self.map = map
        noneIndex = tileset.findTile("none")
        seenIndex = tileset.findTile("seen")
        partialIndex = tileset.findTile("partial")
        for index in 0 ..< 0x100 {
            fogIndices.append(tileset.findTile("pf-\(index)"))
        }
        fogIndices[0x00] = seenIndex
        fogIndices[0x03] = fogIndices[0x07]
        fogIndices[0x06] = fogIndices[0x07]
        fogIndices[0x14] = fogIndices[0x94]
        fogIndices[0x90] = fogIndices[0x94]
        fogIndices[0x60] = fogIndices[0xe0]
        fogIndices[0xc0] = fogIndices[0xe0]
        fogIndices[0x09] = fogIndices[0x29]
        fogIndices[0x28] = fogIndices[0x29]

        for index in 0 ..< 0x100 {
            blackIndices.append(tileset.findTile("pb-\(index)"))
        }

        blackIndices[0x00] = noneIndex
        blackIndices[0x03] = blackIndices[0x07]
        blackIndices[0x06] = blackIndices[0x07]
        blackIndices[0x14] = blackIndices[0x94]
        blackIndices[0x90] = blackIndices[0x94]
        blackIndices[0x60] = blackIndices[0xe0]
        blackIndices[0xc0] = blackIndices[0xe0]
        blackIndices[0x09] = blackIndices[0x29]
        blackIndices[0x28] = blackIndices[0x29]

        var nextIndex = tileset.tileCount
        tileset.setTileCount(tileset.tileCount + (0x100 - originalValues.count) * 2)

        for allowedHamming in 1 ..< 8 {
            for value in 0 ..< 0x100 {
                if fogIndices[value] == -1 {
                    var bestMatch = -1
                    var bestHamming = 8

                    for originalValue in originalValues {
                        let currentHamming = FogRenderer.hammingDistance(originalValue, value)
                        if currentHamming == FogRenderer.hammingDistance(0, ~originalValue & value) {
                            if currentHamming < bestHamming {
                                bestHamming = currentHamming
                                bestMatch = originalValue
                            }
                        }
                    }
                    if bestHamming <= allowedHamming {
                        let firstBest = bestMatch
                        let currentValue = value & ~bestMatch
                        bestMatch = -1
                        bestHamming = 8

                        for originalValue in originalValues {
                            let currentHamming = FogRenderer.hammingDistance(originalValue, currentValue)
                            if currentHamming == FogRenderer.hammingDistance(0, ~originalValue & currentValue) {
                                if currentHamming < bestHamming {
                                    bestHamming = currentHamming
                                    bestMatch = originalValue
                                }
                            }
                        }
                        tileset.duplicateClippedTile(destinationIndex: nextIndex, tileName: "pf-\(value)", sourceIndex: fogIndices[firstBest], clipIndex: fogIndices[bestMatch])
                        fogIndices[value] = nextIndex
                        tileset.duplicateClippedTile(destinationIndex: nextIndex + 1, tileName: "pb-\(value)", sourceIndex: blackIndices[firstBest], clipIndex: blackIndices[bestMatch])
                        blackIndices[value] = nextIndex + 1
                        nextIndex += 2
                    }
                }
            }
        }
    }

    func drawMap(on surface: GraphicSurface, in rectangle: Rectangle) {
        var unknownFog = Array(repeating: false, count: 0x100)
        var unknownBlack = Array(repeating: false, count: 0x100)

        let tileWidth = tileset.tileWidth
        let tileHeight = tileset.tileHeight

        var yIndex = (rectangle.y / tileHeight) - 1
        for yPosition in stride(from: -(rectangle.y % tileHeight), to: rectangle.height, by: tileHeight) {
            yIndex += 1
            var xIndex = (rectangle.x / tileWidth) - 1
            for xPosition in stride(from: -(rectangle.x % tileWidth), to: rectangle.width, by: tileWidth) {
                xIndex += 1

                let tileType = map.tileTypeAt(x: xIndex, y: yIndex)
                if tileType == .none {
                    tileset.drawTile(on: surface, x: xPosition, y: yPosition, index: noneIndex)
                    continue
                } else if tileType == .visible {
                    continue
                }
                if tileType == .seen || tileType == .seenPartial {
                    tileset.drawTile(on: surface, x: xPosition, y: yPosition, index: seenIndex)
                }
                if tileType == .partialPartial || tileType == .partial {
                    var visibilityIndex = 0
                    var visibilityMask = 0x1

                    for yOffset in -1 ..< 2 {
                        for xOffset in -1 ..< 2 {
                            if yOffset != 0 || xOffset != 0 {
                                let visibilityTile = map.tileTypeAt(x: xIndex + xOffset, y: yIndex + yOffset)

                                if visibilityTile == .visible {
                                    visibilityIndex |= visibilityMask
                                }
                                visibilityMask <<= 1
                            }
                        }
                    }
                    if fogIndices[visibilityIndex] == -1 {
                        if !unknownFog[visibilityIndex] {
                            printError("Unknown fog 0x\(visibilityIndex) @ (\(xIndex), \(yIndex))")
                            unknownFog[visibilityIndex] = true
                        }
                    }
                    tileset.drawTile(on: surface, x: xPosition, y: yPosition, index: fogIndices[visibilityIndex])
                }

                if tileType == .partialPartial || tileType == .seenPartial {
                    var visibilityIndex = 0
                    var visibilityMask = 0x1

                    for yOffset in -1 ..< 2 {
                        for xOffset in -1 ..< 2 {
                            if yOffset != 0 || xOffset != 0 {
                                let visibilityTile = map.tileTypeAt(x: xIndex + xOffset, y: yIndex + yOffset)

                                if visibilityTile == .visible || visibilityTile == .partial || visibilityTile == .seen {
                                    visibilityIndex |= visibilityMask
                                }
                                visibilityMask <<= 1
                            }
                        }
                    }
                    if blackIndices[visibilityIndex] == -1 {
                        if !unknownBlack[visibilityIndex] {
                            printError("Unknown black 0x\(visibilityIndex) @ (\(xIndex), \(yIndex))\n")
                            unknownBlack[visibilityIndex] = true
                        }
                    }
                    tileset.drawTile(on: surface, x: xPosition, y: yPosition, index: blackIndices[visibilityIndex])
                }
            }
        }
    }

    func drawMiniMap(on resourceContext: GraphicResourceContext) {
        resourceContext.setLineWidth(1)
        resourceContext.setLineCap(.square)
        for yPosition in 0 ..< map.height {
            var xPosition = 0
            while xPosition < map.width {
                let tileType = map.tileTypeAt(x: xPosition, y: yPosition)
                let xAnchor = xPosition
                while xPosition < map.width && map.tileTypeAt(x: xPosition, y: yPosition) == tileType {
                    xPosition += 1
                }
                if tileType != .visible {
                    var colorRGBA: UInt32 = 0x0000_0000
                    switch tileType {
                    case .none: colorRGBA = 0xff00_0000
                    case .seen, .seenPartial: colorRGBA = 0xa800_0000
                    default: colorRGBA = 0x5400_0000
                    }
                    resourceContext.setSourceRGB(colorRGBA)
                    resourceContext.moveTo(x: xAnchor, y: yPosition)
                    resourceContext.lineTo(x: xPosition - 1, y: yPosition)
                    resourceContext.stroke()
                }
            }
        }
    }

    static func hammingDistance(_ v1: Int, _ v2: Int) -> Int {
        var delta = v1 ^ v2
        var distance = 0

        while delta != 0 {
            if delta & 0x01 != 0 {
                distance += 1
            }
            delta >>= 1
        }
        return distance
    }
}
