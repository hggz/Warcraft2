//
//  MapManager.swift
//  Warcraft2
//
//  Created by Andrew van Tonningen on 1/19/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class MapManager {

    // MARK: Member Variables

    var mapFileName = ".map"
    var mapTileTypes: [[TerrainMap.TileType]] = []

    var sampleMapData = "Maze \n96 64\nGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\nGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFG\nGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFG\nGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFG\nGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFG\nGGGGGGGGGGGGGGGGGGFFFFFFFGGGGGGGGGGGGGGGGGGGGGGGGFFFFFFFFFGGGGGGGGGGGGGGGGGGFFFFFFFFGGGGGGGGGGGDRR\nGGGGGGWWWWWWWWWWWGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGDRR\nGGGGGGWGGGGGGGGGWGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGFFFGGGGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGDRR\nGGGGGGWGGGGGGGGGWGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGDRR\nGGGGGGWGGWWWWWGGWGGGGGGGGGGGGGGGGGRRRRGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGDDDDDDGGGGGGGGGGGGGGDRR\nGGGGGGWGGWGGGWGGWGGGGGGGGGGGGGGGGRRRRGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGDDDRRRDDGGGGGGGGGGGGGGDRR\nGGGGGGWGGWGGGWGGWGGGGGGGGGGGGGGGRRRGGGGGGGGGGGGGGGGFFFFFGGGGGGGGGGGGGGGGGGDDDRRRRDDGGGGGGGGGGGGDRR\nGGGGGGWGGWGGGWGGWGGGGGGGGGGGGGGGRRRGGGGGGGGGGGGGGGGGFFFFFGGGGGGGGGGGGGGGGGGGDDRRRRDDGGGGGGGGGGGDRR\nGGGGGGWGGGGGGWGGWGGGGGGGGGGGGGGGGRRRGGGGGGGGGGGGGGGGGFFFFFGGGGGGGGGGGGGGGGGGGDDRRRRDDGGGGGGGGGGDRR\nGGGGGGWGGGGGGWGGWGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGGGGDDRRRRDDGGGGGGGGDDRR\nGGGGGGWWWWWWWWGGWGGGGGGGGGGGRRRGGGGGGGGGGGGGGGGGGGGGGGFFFGGGGGGGGGGGGGGGGGGGGGGDDRRRRDDGGGGGGGDRRR\nGGGGGGGGGGGGGGGGWGGGGGGGGGGRRRRRRGGGGGGGGGGGGGGGGGGGFFFFFGGGGGGGGGGGGGGGGGGGGGGGDDRRRRDDDDDDDRRRRR\nGGGGGGGGGGGGGGGGWGGGGGGGGGRRRRRRRGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGDDDDRRRRRRRRRRRRRR\nGGGGGGGGGGGGGGGGGGGGGGGGGRRRRRRRGGGGGGGGGGGGGGGGRRRRRRRRRGGGGGGGGGGGGGGGGGGGGGGRRDDDDRRRRRRRRRRRRR\nGGGGGGGGGGGGGGGGGGGGGGGGGRRRRRRRGGGGGGGGGGGGGGRRRRRRRRRRRGGGGGGGGGGGGGGGGGGGGGGRRRDDDDRRRRRRRRRRRR\nGGGGGGGGGGGGGGGGGGGGGGGGRRRRRRRRRGGGGGGGGGGGGRRRRRRRRRRRRRGGGGGGGGGGGGGGGGGGGGGRRRRDDDDDRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRDDRRRRRRRRRRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRDDDDRRRRRRRRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRDDDDDDRRRRRRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRRDDDDDDRRRRRRRRRRRRRRRRRRDDDDDDDDRRRRRRRRRRRRRRRRRRRDDDDDDDRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRRDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRRDDDDDDDRRRRRRRRRRRRRRRRRRRDDDDDDDDRRRRRRRRRRRRRRRRRRDDDDDDRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRRRRRRRRDDDDDDRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRRRRRRRRRRDDDDRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRRRRRRRRRRRRDDRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRDDDDDRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRRDDDDRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\nRRRRRRRRRRDDDDDRRRRGGGGGGGGGGGGGGGGGGGGGGRRRRRRRRRRRRRGGGGGGGGGGGGGGGRRRRRRRRRGGGGGGGGGGGGGGGGGGGG\nRRRRRRRRRRRRDDDDRRRGGGGGGGGGGGGGGGGGGGGGGGRRRRRRRRRRRGGGGGGGGGGGGGGGGGRRRRRRRGGGGGGGGGGGGGGGGGGGGG\nRRRRRRRRRRRRRDDDDRRGGGGGGGGGGGGGGGGGGGGGGGGGRRRRRRRRRGGGGGGGGGGGGGGGGGRRRRRRRGGGGGGGGGGGGGGGGGGGGG\nRRRRRRRRRRRRRRDDDDGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGRRRRRRRGGGGGGGGGGGGGGGGGGGGGG\nRRRRRDDDDDDDRRRRDDGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGFFFFFGGGGGGGGGGGGGGGGRRRRRRGGGGGGGGGGGGGGGGGGGGGGG\nRRRDDGGGGGGDDRRRRDDGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGFFFGGGGGGGGGGGGGGGGGGRRRGGGGGGGGGGGGGGGGGGGGGGGG\nRRDDGGGGGGGGDDRRRRDDGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\nRRDGGGGGGGGGGDDRRRRDDGGGGGGGGGGGGGGGGGGGGGGGGGGGGFFFFFGGGGGGGGGGGGRRRGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\nRRDGGGGGGGGGGGDDRRRRDDGGGGGGGGGGGGGGGGGGGGGGGGGGFFFFFGGGGGGGGGGGGRRRGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\nRRDGGGGGGGGGGGGDDRRRRDDGGGGGGGGGGGGGGGGGGGGGGGGFFFFFGGGGGGGGGGGGGRRRGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\nRRDGGGGGGGGGGGGGDDRRRRDDGGGGGGGGGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGRRRRGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\nRRDGGGGGGGGGGGGGGDDDDDGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGRRRRGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\nRRDGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\nRRDGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGGGGGGGGGFFFGGGGGGGGGGGGGGGGGGGGGGGFFFGGGGGGGGGGGGGGGGGGGGG\nRRDGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGGGGGGGGGFFFFGGGGGGGGGGGGGGGGGGGGGGGFFFGGGGGGGGGGGGGGGGGGGGG\nRRDGGGGGGGGGGFFFFFFFFGGGGGGGGGGGGGGGGGGGGGGGGFFFFFFFFFGGGGGGGGGGGGGGGGGGGFFFFFFFGGGGGGGGGGGGGGGGGG\nGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFG\nGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFG\nGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFG\nGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFG\nGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"

    // MARK: Member Functions

    func loadMap() {
        let fileLines: [String] = self.sampleMapData.components(separatedBy: "\n")
        mapTileTypes = []

        for i in 2 ..< fileLines.count {
            let tileRow = fileLines[i].characters.map {
                TerrainMap.TileType.getType(fromTileCharCode: $0)!
            }
            mapTileTypes.append(tileRow)
        }

        mapTileTypes = mapTileTypes.reversed()
    }

    func mapYCount() -> Int {
        return mapTileTypes.count
    }

    func mapXCount() -> Int {
        return (mapYCount() == 0) ? 0 : mapTileTypes[0].count
    }
}
