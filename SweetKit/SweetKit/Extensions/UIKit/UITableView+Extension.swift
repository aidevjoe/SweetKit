import UIKit

public extension UITableView {
    
    
    public func estimatedRowHeight(_ height: CGFloat) {
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = height
    }
    
    /// 隐藏 section style模式下顶部的空隙
    public func hideHeaderViewSpace(_ margin: CGFloat = 0.1) {
        self.tableHeaderView = UIView(frame: CGRect(height: margin))
    }
    
    /// 隐藏空的Cell
    public func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
    
    /// Dequeue reusable UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    /// - Returns: UITableViewCell object with associated class name (optional value)
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: name)) as? T
    }
    
    /// Dequeue reusable UITableViewCell using class name for indexPath
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as! T
    }
    
    /// Dequeue reusable UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    /// - Returns: UITableViewHeaderFooterView object with associated class name (optional value)
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T
    }
    
    /// Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the header or footer view.
    ///   - name: UITableViewHeaderFooterView type.
    public func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    /// Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    public func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    /// Register UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    public func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    /// Register UITableViewCell using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the tableView cell.
    ///   - name: UITableViewCell type.
    public func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
    /// Retrive all the IndexPaths for the section.
    ///
    /// - Parameter section: The section.
    /// - Returns: Return an array with all the IndexPaths.
    public func indexPaths(section: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        let rows: Int = self.numberOfRows(inSection: section)
        for i in 0 ..< rows {
            let indexPath: IndexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        
        return indexPaths
    }
    
    /// Retrive the next index path for the given row at section.
    ///
    /// - Parameters:
    ///   - row: Row of the index path.
    ///   - section: Section of the index path
    /// - Returns: Returns the next index path.
    public func nextIndexPath(row: Int, forSection section: Int) -> IndexPath? {
        let indexPath: [IndexPath] = self.indexPaths(section: section)
        guard indexPath != [] else {
            return nil
        }
        
        return indexPath[row + 1]
    }
    
    /// Retrive the previous index path for the given row at section
    ///
    /// - Parameters:
    ///   - row: Row of the index path.
    ///   - section: Section of the index path.
    /// - Returns: Returns the previous index path.
    public func previousIndexPath(row: Int, forSection section: Int) -> IndexPath? {
        let indexPath: [IndexPath] = self.indexPaths(section: section)
        guard indexPath != [] else {
            return nil
        }
        
        return indexPath[row - 1]
    }
}


public extension UITableView {
    public func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
    
    
    public func insertRowsAtBottom(_ rows: [IndexPath]) {
        //保证 insert row 不闪屏
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.beginUpdates()
        self.insertRows(at: rows, with: .none)
        self.endUpdates()
        self.scrollToRow(at: rows[0], at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    public func totalRows() -> Int {
        var i = 0
        var rowCount = 0
        while i < self.numberOfSections {
            rowCount += self.numberOfRows(inSection: i)
            i += 1
        }
        return rowCount
    }
    
    public var lastIndexPath: IndexPath? {
        if (self.totalRows()-1) > 0{
            return IndexPath(row: self.totalRows()-1, section: 0)
        } else {
            return nil
        }
    }
    
    //插入数据后调用
    public func scrollBottomWithoutFlashing() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    //键盘动画结束后调用
    public func scrollBottomToLastRow() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    //    func scrollToBottom(animated: Bool) {
    //        let bottomOffset = CGPoint(x: 0, y:self.contentSize.height - self.bounds.size.height)
    //        self.setContentOffset(bottomOffset, animated: animated)
    //    }
    
    public var isContentInsetBottomZero: Bool {
        get { return self.contentInset.bottom == 0 }
    }
    
    public func resetContentInsetAndScrollIndicatorInsets() {
        self.contentInset = UIEdgeInsets.zero
        self.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
