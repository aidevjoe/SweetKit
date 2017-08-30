import UIKit

public extension UICollectionView {
    
    public func sectionWidth(at section: Int) -> CGFloat {
        var width = bounds.width
        width -= contentInset.left
        width -= contentInset.right
        
        if let delegate = self.delegate as? UICollectionViewDelegateFlowLayout,
            let inset = delegate.collectionView?(self, layout: self.collectionViewLayout, insetForSectionAt: section) {
            width -= inset.left
            width -= inset.right
        } else if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            width -= layout.sectionInset.left
            width -= layout.sectionInset.right
        }
        
        return width
    }
    
    public var indexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        
        let sections = self.numberOfSections
        for section in 0 ..< sections {
            let rows = self.numberOfItems(inSection: section)
            for row in 0 ..< rows {
                indexPaths.append(IndexPath(row: row, section: section))
            }
        }
        
        return indexPaths
    }
    
    public func nextIndexPath(to indexPath: IndexPath, offset: Int = 0) -> IndexPath? {
        return UICollectionView.nextIndexPath(to: indexPath, offset: offset, source: self.indexPaths)
    }
    
    public func previousIndexPath(to indexPath: IndexPath, offset: Int = 0) -> IndexPath? {
        return UICollectionView.nextIndexPath(to: indexPath, offset: offset, source: self.indexPaths.reversed())
    }
    
    private class func nextIndexPath(to indexPath: IndexPath, offset: Int = 0, source: [IndexPath]) -> IndexPath? {
        var found = false
        var skippedResults = offset
        
        for currentIndexPath in source {
            if found == true {
                if skippedResults <= 0 {
                    return currentIndexPath
                }
                
                skippedResults -= 1
            }
            
            if currentIndexPath == indexPath {
                found = true
            }
        }
        
        return nil
    }
}
