//
//  ViewController.swift
//  DemoAppForMovieListAPI
//
//  Created by Teasw on 16/12/20.
//

import UIKit

enum MovieSelected: String {
    case nowPlayingMovie = "now_playing?"
    case mostPopularMovie = "popular?"
    case topRatedMovie = "top_rated?"
}

class MovieListController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var arrOfMovieData = [MovieDetailsModel]()
    var isSearching: Bool = false
    var searchTextTemp: String = ""
    var currentPage: Int = 1
    var totalPage: Int = 0
    var selectedMovieTab = MovieSelected.nowPlayingMovie.rawValue

    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientColour(self: self)
        self.getMovieData(forMovieList: MovieSelected.nowPlayingMovie.rawValue)
        self.activityIndicator.hidesWhenStopped = true
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
    }

    func getMovieData(forMovieList: String) {
        Service.sharedInstance.getMovieData(forMovie: forMovieList, pageNum: currentPage,  completion: {  [self] (data, error)  in
            if let data = data {
                if currentPage <= 1 {
                    self.arrOfMovieData = data.results
                } else {
                    self.arrOfMovieData.append(contentsOf: data.results)
                }
                self.currentPage = data.pageNumber ?? 1
                self.totalPage = data.totalPageNum ?? 1
                print(arrOfMovieData.count)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tblView.reloadData()
                    if currentPage <= 1 {
                        self.tblView.scrollRectToVisible(.zero, animated: true)
                    }
                }
            }
            else {
                print(error?.localizedDescription as Any)
            }
        })
    }

    @IBAction func segmentControlDidTap(_ sender: UISegmentedControl) {
        self.activityIndicator.startAnimating()
        currentPage = 1
        if sender.selectedSegmentIndex == 0 {
            selectedMovieTab = MovieSelected.nowPlayingMovie.rawValue
            getMovieData(forMovieList: MovieSelected.nowPlayingMovie.rawValue)
        } else if sender.selectedSegmentIndex == 1 {
            selectedMovieTab = MovieSelected.mostPopularMovie.rawValue
            getMovieData(forMovieList: MovieSelected.mostPopularMovie.rawValue)
        } else {
            selectedMovieTab = MovieSelected.topRatedMovie.rawValue
            getMovieData(forMovieList: MovieSelected.topRatedMovie.rawValue)
        }
    }
}

//MARK: UISearchBarDelegate
extension MovieListController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        currentPage = 1
        if searchText == "" {
            //self.getMovieData(forMovieList: MovieSelected.nowPlayingMovie.rawValue)
            self.segmentControl.isHidden = false
            getMovieData(forMovieList: selectedMovieTab)
            //self.segmentControlDidTap(UISegmentedControl())
        } else {
            self.activityIndicator.startAnimating()
            getSearchMovie(text: searchText)
            self.segmentControl.isHidden = true
        }
    }
    
    func getSearchMovie(text:String) {
        arrOfMovieData = []
        Service.sharedInstance.getSearchMovieDataList(ForString: text) { (searchData, error) in
            if let data = searchData {
                self.arrOfMovieData = data.results
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tblView.reloadData()
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = nil
        self.segmentControl.isHidden = false
        self.arrOfMovieData = []
        getMovieData(forMovieList: selectedMovieTab)
    }
}

//MARK: UITableViewDataSource & Delegate
extension MovieListController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfMovieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! MovieTableCell
        cell.movieNameLbl.text = arrOfMovieData[indexPath.row].movieName
        if let url = URL(string: "\(baseImageURl)" + "\(arrOfMovieData[indexPath.row].thumbnail ?? "")") {
            // Fetch Image Data
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.movieImgView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DetailsViewController") as? MovieDetailsController else {
            return
        }
        detailVC.movieDetails = arrOfMovieData[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MovieListController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        print(arrOfMovieData.count)
        if arrOfMovieData.count > 0,
           maximumOffset - currentOffset <= 20,
           currentPage < totalPage
        {
            currentPage += 1
            self.activityIndicator.startAnimating()
            getMovieData(forMovieList: selectedMovieTab)
        }
    }
}

func setGradientColour(self: UIViewController)  {
    let gradientColor = CAGradientLayer()
    gradientColor.frame = self.view.bounds
    gradientColor.colors = [UIColor.blue.cgColor, UIColor.orange.cgColor]
    self.view.layer.insertSublayer(gradientColor, at: 0)
    
}
