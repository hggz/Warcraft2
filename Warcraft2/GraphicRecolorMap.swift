class GraphicRecolorMap {

    private var state: Int = -1
    private var mapping: [String: Int] = [:]
    private var colorNames: [String] = []
    private var colors: [[UInt32]] = [[]]
    private var originalColors: [[UInt32]] = [[]]

    var groupCount: Int {
        return colors.count
    }

    var colorCount: Int {
        return colors.first?.count ?? 0
    }

    func findColor(with name: String) -> Int {
        fatalError("This method is not yet implemented.")
    }

    func colorValue(gIndex: Int, cIndex: Int) -> UInt32 {
        fatalError("This method is not yet implemented.")
    }

    func load(from dataSource: DataSource) throws {
        fatalError("This method is not yet implemented.")
    }

    func observePixels() -> UInt32 {
        fatalError("This method is not yet implemented.")
    }

    func recolorPixels() -> UInt32 {
        fatalError("This method is not yet implemented")
    }

    func recolorSurface(index: Int, on surface: GraphicSurface) -> GraphicSurface {
        fatalError("This method is not yet implemented")
    }
}