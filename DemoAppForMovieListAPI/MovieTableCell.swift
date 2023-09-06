//
//  CustomTableViewCell.swift
//  DemoAppForMovieListAPI
//
//  Created by Teasw on 16/12/20.
//

import UIKit

class MovieTableCell: UITableViewCell {

    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var movieImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
