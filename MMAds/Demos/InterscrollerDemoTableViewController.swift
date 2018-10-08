//
//  DemoTableViewController.swift
//  MMAds
//
//  Created by L.D. Deurman on 30/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InterscrollerDemoTableViewController: UITableViewController, DMSAdsLoaderDelegate {

    
    var scroller:DMSAdsScroller?
    var items = Item.getDemoItems();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //self.interscroller = DMSAdsScroller(tableView: self.tableView, indexPath: IndexPath(row: 25, section: 0));
        
        
        
        let loader = DMSAdsLoader(implementation: DMSAdsBannerViewLoader(adUnitId:  "/35445201/dmsads_interscroller", adSize: GADAdSizeFromCGSize(CGSize(width: 300, height: 600)), validAdSizes: nil, dfpBannerSize: CGSize(width: 300, height: 600), nativeSize: nil), delegate: self, viewController: self);
        loader.callAd(data: nil);
        
        
        self.scroller = DMSAdsScroller(tableView: self.tableView, indexPath: IndexPath(row: 6, section: 0));
        
        self.tableView.separatorStyle = .none;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func onAdLoaded(bannerView: UIView?) {
        print("loaded");
        self.scroller?.setup(bannerView: bannerView, backgroundView: UIView());
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count + 1;
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scroller?.scrollViewDidScroll(scrollView: scrollView);
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return self.scroller?.tableView(tableView, heightForRowAt: indexPath) ?? super.tableView(tableView, heightForRowAt: indexPath);
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if let adCell = self.scroller?.scrollerTableViewCell(tableView: tableView, indexPath: indexPath) {
            return adCell;
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsItemCell") as! NewsTableCell;
        if (indexPath.row < 6) {
            
            cell.configure(item: self.items[indexPath.row]);
        } else {
            
            cell.configure(item: self.items[indexPath.row - 1]);
        }
        
        return cell;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        cell?.setSelected(false, animated: false);
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
