//
//  PopularMoviesViewController+CollectionView+Extension.swift
//  Muvi
//
//  Created by Ivan Nur Ilham Syah on 15/10/24.
//

import Foundation
import UIKit

extension PopularMoviesViewController {
  internal func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createMovieGridFlowLayout())
    
    view.addSubview(collectionView)
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(searchField.snp.bottom).offset(24)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    collectionView.register(MovieGridCell.nib(), forCellWithReuseIdentifier: MovieGridCell.reusableId)
    collectionView.backgroundColor = .systemBackground
  }
  
  internal func createMovieGridFlowLayout() -> UICollectionViewFlowLayout {
    let width = view.bounds.width
    let padding: CGFloat = 20
    let minimumItemSpacing: CGFloat = 5
    let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
    let itemWidth = availableWidth / 2
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding * 2, right: padding)
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 88)
    
    return flowLayout
  }
  
  internal func configureDataSource() {
    datasource = MovieDataSource(collectionView: collectionView) { collectionView, indexPath, movie in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieGridCell.reusableId, for: indexPath) as? MovieGridCell
      
      guard let cell else { return UICollectionViewCell() }
      
      cell.updateData(with: movie)
      
      return cell
    }
    
  }
  
  internal func updateCollectionViewData(
    with movies: [Movie]
  ) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
    snapshot.appendSections([0])
    snapshot.appendItems(movies)
    
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      
      self.datasource.apply(snapshot)
      
    }
    
  }
  
}
