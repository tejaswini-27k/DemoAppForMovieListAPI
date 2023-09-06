//
//  DetailsViewController.swift
//  DemoAppForMovieListAPI
//
//  Created by Teasw on 17/12/20.
//

import UIKit

class MovieDetailsController: UIViewController {

    @IBOutlet weak var lblSynopsis: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRelaseDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var movieDetails :MovieDetailsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
        setGradientColour(self: self)
        configureAllData()

        self.navigationItem.title = movieDetails?.movieName
    }

    func configureAllData() {
        lblTitle.text = movieDetails?.movieName
        lblRelaseDate.text = movieDetails?.releaseDate
        
        lblRating.text = String(movieDetails?.rating ?? 0.0)
        lblSynopsis.text = movieDetails?.movieSynopsis
        if let url = URL(string: "\(baseImageURl)" + "\(movieDetails?.thumbnail ?? "")") {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                imgView.image  = UIImage(data: data)
            }
        }
    }
}
