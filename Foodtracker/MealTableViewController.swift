//
//  MealTableViewController.swift
//  Foodtracker
//
//  Created by dohien on 6/9/18.
//  Copyright © 2018 hiền hihi. All rights reserved.
//

import UIKit
import os.log
class MealTableViewController: UITableViewController , UISearchResultsUpdating{
    
    // hàm search
    func updateSearchResults(for searchController: UISearchController) {
        meal100 = meals.filter({(meal1000 : Meal) -> Bool in
            return meal1000.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    
  
//    var tableData = ["Caprese Salad","Chicken and Potatoes","Pasta with Meatballs"]
//    var filteredTableData = [String]()
    let controller = UISearchController(searchResultsController : nil)
    var meal100 : [Meal] = []
    var meals = [Meal]()
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        guard let meal1 = Meal(name: "Caprese Salad " , photo: photo1, rating: 4 ) else {
            fatalError("Unable to instantiale meal1")
        }
        guard let meal2 = Meal(name: "Chicken and Potatoes" , photo: photo2 , rating: 5) else {
            fatalError("Unable to instantiale meal2")
        }
        guard let meal3 = Meal(name: "Pasta with Meatballs" , photo: photo3 , rating: 3) else {
            fatalError("unable to instantiale meal3")
        }
        meals += [meal1 , meal2 , meal3]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        if let savedMeals = loadMeals(){
            meals += savedMeals
        }else{
             loadSampleMeals()
        }
        controller.searchResultsUpdater = self
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        self.tableView.tableHeaderView = controller.searchBar
        controller.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = controller.searchBar
        // truyền sang mất nút search
        definesPresentationContext = true
        
        
        self.tableView.reloadData()
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if controller.isActive {
            return meal100.count
        } else {
            return meals.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier  = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }
        
        // nút search
        
        var listMeal : [Meal] = []
        if controller.isActive{
//            let meal0 = meal100[indexPath.row]
//            cell.nameLabel.text = meal0.name
//            cell.photoImageView.image = meal0.photo
//            cell.ratingControl.rating = meal0.rating
            listMeal = meal100
        }else{
            listMeal = meals
//            let meal = meals[indexPath.row]
//            cell.nameLabel.text = meal.name
//            cell.photoImageView.image = meal.photo
//            cell.ratingControl.rating = meal.rating
        }
        cell.nameLabel.text = listMeal[indexPath.row].name
        cell.photoImageView.image = listMeal[indexPath.row].photo
        cell.ratingControl.rating = listMeal[indexPath.row].rating
        return cell
    }
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                // luu cac bua an
                saveMeals()
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                // Add a new meal.
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
            
        case "add":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealcell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealcell) else {
                fatalError("The selected cell is not being display be the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Secgue Identifier ; \(segue.identifier))")
        }
    }
    // lưu và tải danh sách bữa ăn
    private func saveMeals(){
        let isSuccesfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccesfulSave{
            os_log("Meals successfully saved ", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    //Thao tác này ghi nhật ký một thông báo gỡ lỗi vào bảng điều khiển nếu lưu thành công và thông báo lỗi cho bảng điều khiển nếu lưu không thành công.
    
    //  thực hiện một phương pháp để tải bữa ăn.
    private func loadMeals() -> [Meal]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
}
