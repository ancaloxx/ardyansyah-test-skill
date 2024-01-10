//
//  ListProductViewController.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 05/01/24.
//

import UIKit
import Kingfisher

class ListProductViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var buttonAddProduct: UIButton!
    @IBOutlet weak var collectionProduct: UICollectionView!
    
    private var indicatorRunning = IndicatorRunning()
    private var popUp = PopUp()
    private var jsonData = ProductData()
    private var cellTag = 0
    private var listProduct = ListProduct()
    
    var key = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBarSetup()
        
        cellTag = -1
        listProduct = ListProduct(
            page: 1,
            per_page: 100,
            search: ""
        )
        
        showIndicatorRunning()
        APIManager.shareInstance.callingListProductAPI(key: key, listProduct: listProduct) { result, data in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let code = result["code"] as? String
                
                if code == "20000" {
                    self.navigationController?.navigationBar.isHidden = false
                    self.indicatorRunning.removeFromSuperview()
                    
                    if data.data?.items?.count != 0 {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Component 13_1"), style: .plain, target: self, action: #selector(self.buttonAddProductAction(_:)))
                        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "blueColorCustom")
                        
                        self.jsonData = data
                        self.collectionProduct.reloadData()
                        
                        self.collectionProduct.isHidden = false
                        self.buttonAddProduct.isHidden = true
                    } else {
                        self.collectionProduct.isHidden = true
                        self.buttonAddProduct.isHidden = false
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    private func showIndicatorRunning() {
        navigationController?.navigationBar.isHidden = true
        
        indicatorRunning = IndicatorRunning(frame: view.frame)
        view.addSubview(indicatorRunning)
    }
    
    private func initialSetup() {
        navigationBarSetup()
        searchBarSetup()
        collectionProductSetup()
    }
    
    private func navigationBarSetup() {
        let backImage = UIBarButtonItem(image: UIImage(named: "Component 14_1"), style: .plain, target: self, action: #selector(navigationBack))
        backImage.imageInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        let backTitle = UIBarButtonItem(title: "Product", style: .plain, target: self, action: #selector(navigationBack))
        
        navigationItem.leftBarButtonItems = [backImage, backTitle]
    }
    
    @objc private func navigationBack() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func searchBarSetup() {
        searchBar.text = ""
        searchBar.setImage(UIImage(named: "Component 5_1"), for: .search, state: .normal)
        searchBar.delegate = self
    }
    
    private func collectionProductSetup() {
        let nibCell = UINib(nibName: "ListProductCell", bundle: nil)
        collectionProduct.register(nibCell, forCellWithReuseIdentifier: "listProduct")
        
        collectionProduct.dataSource = self
        collectionProduct.collectionViewLayout = collectionViewProductLayout()
    }
    
    private func collectionViewProductLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(0.5)
            ),
            repeatingSubitem: item,
            count: 2
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @IBAction func buttonAddProductAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addproductVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddProductViewController {
            if cellTag != -1 {
                let items = jsonData.data?.items?[cellTag]
                var productVariants = [VariantsData]()
                
                items?.variants.forEach { item in
                    productVariants.append(item)
                }
                
                vc.backTitleProduct = items?.title ?? ""
                vc.productID = items?.id ?? 0
                vc.product = Items(
                    title: items?.title,
                    description: items?.description,
                    variants: productVariants
                )
            }
            
            vc.key = key
        }
    }
    
    @IBAction func buttonLogoutAction(_ sender: UIButton) {
        showPopUp()
    }
    
    private func showPopUp() {
        popUp = PopUp(frame: view.frame)
        popUp.delegate = self
        popUp.labelInformation.text = "Are you sure to LOGOUT?"
        view.addSubview(popUp)
    }
    
}

extension ListProductViewController: PopUpProtocol {
    
    func buttonAction(action: Bool) {
        if action {
            navigationController?.popToRootViewController(animated: true)
        } else {
            popUp.removeFromSuperview()
        }
    }
    
}

extension ListProductViewController: UICollectionViewDataSource, ListProductCellProtocol {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonData.data?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listProduct", for: indexPath) as? ListProductCell else {
            return UICollectionViewCell()
        }
        
        let item = jsonData.data?.items?[indexPath.row] ?? Items()
        cell.delegate = self
        
        cell.productDataSetup(item: item)
        cell.buttonProduct.tag = indexPath.row
        
        return cell
    }
    
    func clickProductCell(index: Int) {
        cellTag = index
        self.performSegue(withIdentifier: "addproductVC", sender: self)
    }
    
}

extension ListProductViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        listProduct.search = searchBar.text
        showIndicatorRunning()
        
        APIManager.shareInstance.callingListProductAPI(key: key, listProduct: listProduct) { result, data in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let code = result["code"] as? String
                
                if code == "20000" {
                    self.navigationController?.navigationBar.isHidden = false
                    self.indicatorRunning.removeFromSuperview()
                    
                    if data.data?.items?.count != 0 {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Component 13_1"), style: .plain, target: self, action: #selector(self.buttonAddProductAction(_:)))
                        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "blueColorCustom")
                        
                        self.jsonData = data
                        self.collectionProduct.reloadData()
                        
                        self.collectionProduct.isHidden = false
                        self.buttonAddProduct.isHidden = true
                    } else {
                        self.collectionProduct.isHidden = true
                        self.buttonAddProduct.isHidden = false
                    }
                }
            }
        }
        
        searchBar.endEditing(true)
    }
    
}
