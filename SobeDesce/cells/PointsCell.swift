//
//  PointsCell.swift
//  SobeDesce
//
//  Created by PAULO ALMEIDA on 21/12/2022.
//

import UIKit

class PointsCell: UITableViewCell {
    
    @IBOutlet weak var cellColletionView: UICollectionView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var backgroundStackView: UIStackView!
    
    var player = Player(name: "")
    var myColorArray = myColor.allCases.count
    var randomColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
        cellColletionView.register(UINib(nibName: "PointsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        cellColletionView.dataSource = self
        cellColletionView.delegate = self
        cellColletionView.layer.masksToBounds = true
        cellColletionView.layer.cornerRadius = 8
        backgroundStackView.layer.cornerRadius = 8
        backgroundStackView.clipsToBounds = true
        backgroundStackView.layer.masksToBounds = false
        backgroundStackView.layer.shadowRadius = 5
        backgroundStackView.layer.shadowOpacity = 0.6
        backgroundStackView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        backgroundStackView.layer.shadowColor = UIColor.black.cgColor
    }
}

extension PointsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configure(with player:Player){
        self.player = player
        cellColletionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return player.totalPoints.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellColletionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! PointsCollectionViewCell
        cell.pointsPerRoundLabel.text = "\(player.rounds[indexPath.row])"
        cell.totalPointsLabel.text = "\(player.totalPoints[indexPath.row])"
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.backgroundColor = self.randomColor
        if player.rounds[indexPath.row] == " " {
            cell.pointsPerRoundLabelBackground.backgroundColor = self.randomColor
            cell.pointsPerRoundLabelBackground.isHidden = true
            return cell
        }
        cell.pointsPerRoundLabelBackground.backgroundColor = .white
        cell.pointsPerRoundLabelBackground.isHidden = false
        backgroundStackView.backgroundColor = randomColor
        cellColletionView.backgroundColor = randomColor
       // cell.pointsPerRoundLabel.textColor =
        self.myColorArray = self.myColorArray - 1
        return cell
    }
    
     func scrollLast() {
         let lastItemIndex = self.cellColletionView.numberOfItems(inSection: 0) - 1
         let indexPath:IndexPath = IndexPath(item: lastItemIndex, section: 0)
         self.cellColletionView.scrollToItem(at: indexPath, at: .right, animated: false)
        }
    
}

extension UICollectionView {

    // MARK: - UICollectionView scrolling/datasource
    /// Last Section of the CollectionView
    var lastSection: Int {
        return numberOfSections - 1
    }

    /// IndexPath of the last item in last section.
    var lastIndexPath: IndexPath? {
        guard lastSection >= 0 else {
            return nil
        }

        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else {
            return nil
        }

        return IndexPath(item: lastItem, section: lastSection)
    }

    /// Islands: Scroll to bottom of the CollectionView
    /// by scrolling to the last item in CollectionView
    func scrollToBottom(animated: Bool) {
        guard let lastIndexPath = lastIndexPath else {
            return
        }
        scrollToItem(at: lastIndexPath, at: .bottom, animated: animated)
    }
}
