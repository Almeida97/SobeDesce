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
    var randomColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
        cellColletionView.register(UINib(nibName: "PointsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        cellColletionView.dataSource = self
        cellColletionView.delegate = self
        
        cellColletionView.layer.masksToBounds = true
        cellColletionView.layer.cornerRadius = 8
        backgroundStackView.layer.cornerRadius = 8
        
        
        //add shadow to the background
        backgroundStackView.clipsToBounds = true
        backgroundStackView.layer.masksToBounds = false
        backgroundStackView.layer.shadowRadius = 5
        backgroundStackView.layer.shadowOpacity = 0.6
        backgroundStackView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        backgroundStackView.layer.shadowColor = UIColor.black.cgColor
    }
}

extension PointsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configure(with player:Player, randomColor: UIColor){
        self.player = player
        self.randomColor = randomColor
        backgroundStackView.backgroundColor = randomColor
        cellColletionView.backgroundColor = randomColor
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
        if player.rounds[indexPath.row].contains("-") {
            cell.pointsPerRoundLabel.textColor = .systemGreen
        }else{
            cell.pointsPerRoundLabel.textColor = .red
        }
        if player.rounds[indexPath.row] == " " {
            cell.pointsPerRoundLabelBackground.backgroundColor = self.randomColor
            cell.pointsPerRoundLabelBackground.isHidden = true
            return cell
        }
        cell.pointsPerRoundLabelBackground.backgroundColor = .white
        cell.pointsPerRoundLabelBackground.isHidden = false
        collectionView.reloadData()
        self.scrollLast()
        return cell
    }
    
     func scrollLast() {
         let lastItemIndex = self.cellColletionView.numberOfItems(inSection: 0) - 1
         let indexPath:IndexPath = IndexPath(item: lastItemIndex, section: 0)
         self.cellColletionView.scrollToItem(at: indexPath, at: .right, animated: false)
        }
    
}
