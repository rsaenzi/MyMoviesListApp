//
//  CellPopularItem.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/27/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class CellPopularItem: UITableViewCell {
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelOverview: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
