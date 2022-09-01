//
//  YSSandboxViewController.swift
//  LeiFengHao
//
//  Created by xj on 2022/3/2.
//

import UIKit

class YSSandboxViewController: XJBaseViewController {
    
    /// 本地路径
    var localPath: String = ""
    
    /// 最后一级目录
    var lastPath: String = ""
    
    /// 数据模型
    var fileModels: [YSLocalFileModel] = []
    
    var tableView: UITableView = UITableView()

    convenience init(localPath: String, lastPath: String) {
        self.init(nibName: nil, bundle: nil)
        self.localPath = localPath
        self.lastPath = lastPath
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        if self.localPath.count == 0 { self.localPath = FileManager.xj.homeDirectory() }
        if self.lastPath.count == 0 { self.lastPath = "沙盒"}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = lastPath
        
        setupUI()

        DispatchQueue.global().async {
            // 获取数据源
            self.fileModels = YSLocalFileModel(path: self.localPath).getLocalFiles()

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func test() {
        let path = FileManager.xj.homeDirectory()
        let searchFiles: [String] = FileManager.xj.getAllFileNames(folderPath: path) ?? []
        print("searchFiles \(searchFiles.count) = \(searchFiles)")
        
        for file in searchFiles {
            let filePath = path + "/" + file
            let attributes = FileManager.xj.fileAttributes(path: filePath)!

            print("--------------\(file)----------")
            print("文件类型：\(attributes[FileAttributeKey.type]!)")
            print("文件大小：\(attributes[FileAttributeKey.size]!)")
            print("创建时间：\(attributes[FileAttributeKey.creationDate]!)")
            print("修改时间：\(attributes[FileAttributeKey.modificationDate]!)")

        }
    }

}

extension YSSandboxViewController {
    
    fileprivate func setupUI() {
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        //tableView.separatorStyle = .none
        // 适配ios11
        if #available(iOS 11.0, *) {
            
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        weak var weakSelf = self
        self.setRefreshHeader(tableView) {
            weakSelf?.endRefreshHeader()
        }
    }
}

extension YSSandboxViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 返回每组个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileModels.count
    }
    
    // 返回cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = YSLocalFileCell.tableViewCell(tableView: tableView)
        let fileModel = self.fileModels[indexPath.row]
        cell.fileModel = fileModel
        return cell
    }
    
    // 返回cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let fileModel = self.fileModels[indexPath.row]
        if fileModel.type == .folder {
            print("click----\(fileModel.fileName)")
         
            let nextPath = self.localPath + "/" + fileModel.fileName
            let fileVc = YSSandboxViewController(localPath: nextPath, lastPath: fileModel.fileName)
            self.pushVC(fileVc)
        }
    }
}
