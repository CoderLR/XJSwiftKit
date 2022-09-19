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
    
    /// 文本内容
    var textContent: String = ""
    
    /// 数据模型
    var fileModels: [YSLocalFileModel] = []
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: self.view.bounds)
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        textView.isEditable = false // 是否可编辑
        textView.isSelectable = true // 是否可选
        textView.dataDetectorTypes = .link //只有网址加链接
        return textView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
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
        return tableView
    }()
    
    convenience init(localPath: String, lastPath: String) {
        self.init(nibName: nil, bundle: nil)
        
        self.localPath = localPath
        self.lastPath = lastPath
    }
    
    convenience init(localPath: String, lastPath: String, textContent: String) {
        self.init(nibName: nil, bundle: nil)
        
        self.localPath = localPath
        self.lastPath = lastPath
        self.textContent = textContent
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
        
        print("localPath = \(localPath)")
        let filePath = self.localPath as NSString
        let type = YSLocalFileModel.getFileType(pathExt: filePath.pathExtension)
        setupUI(type)
        if type == .txt || type == .log { return }

        setupUI(.folder)
        
        // .folder
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
    
    fileprivate func setupUI(_ type: YSLocalFileType) {
        
        if type == .txt || type == .log {
            self.view.addSubview(self.textView)
            self.textView.text = self.textContent
            return
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
        print("click----\(fileModel.fileName)")
        let nextPath = self.localPath + "/" + fileModel.fileName
        
        if fileModel.type == .folder {
            let fileVc = YSSandboxViewController(localPath: nextPath, lastPath: fileModel.fileName)
            self.pushVC(fileVc)
        } else if (fileModel.type == .txt ||  fileModel.type == .log) {
            
            do {
                let data = try Data(contentsOf: URL.init(fileURLWithPath: nextPath))
                guard let str = String(data: data, encoding: .utf8) else { return }
                print(str)
                let fileVc = YSSandboxViewController(localPath: nextPath, lastPath: fileModel.fileName, textContent: str)
                self.pushVC(fileVc)
            } catch {
                
            }
            
        }
    }
}
