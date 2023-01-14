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
    
    var player = Player(name: "")
    override func awakeFromNib() {
        super.awakeFromNib()
        cellColletionView.register(UINib(nibName: "PointsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        cellColletionView.dataSource = self
        cellColletionView.delegate = self
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return player.totalPoints.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellColletionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! PointsCollectionViewCell
        cell.pointsPerRoundLabel.text = "\(player.rounds[indexPath.row])"
        cell.pointsPerRoundLabel.textColor = player.roundColor[indexPath.row]
        cell.totalPointsLabel.text = "\(player.totalPoints[indexPath.row])"
        
        return cell
    }
    
     func scrollLast() {
         let lastItemIndex = self.cellColletionView.numberOfItems(inSection: 0) - 1
         let indexPath:IndexPath = IndexPath(item: lastItemIndex, section: 0)
         self.cellColletionView.scrollToItem(at: indexPath, at: .right, animated: false)
        }
    
}
