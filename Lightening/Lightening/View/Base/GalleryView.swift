//
//  GalleryView.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

protocol GalleryViewDelegate: AnyObject {

    func sizeForItem(_ galleryView: GalleryView) -> CGSize
}

class GalleryView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var delegate: GalleryViewDelegate? {

        didSet {

            collectionView.dataSource = self

            collectionView.delegate = self

            collectionView.reloadData()
        }
    }

    private lazy var collectionView: UICollectionView = {

        let layoutObject = UICollectionViewFlowLayout()

        layoutObject.minimumInteritemSpacing = 20

        layoutObject.minimumLineSpacing = 20

        layoutObject.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3 / 375 * 500)

        layoutObject.sectionInset = UIEdgeInsets.init(top: 40, left: 20, bottom: 20, right: 20)
        
        layoutObject.scrollDirection = .horizontal

        let collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layoutObject
        )

        collectionView.register(
            GalleryViewCell.self,
            forCellWithReuseIdentifier: String(describing: GalleryViewCell.self)
        )

        collectionView.backgroundColor = UIColor.white

//        collectionView.isPagingEnabled = true

        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

//    private lazy var pageControl: UIPageControl = {
//
//        let control = UIPageControl()
//
//        control.numberOfPages = datas.count
//
//        control.pageIndicatorTintColor = UIColor.black
//
//        control.currentPageIndicatorTintColor = UIColor.white
//
//        return control
//    }()

    var datas: [String] = [] {

        didSet {

            collectionView.reloadData()

//            pageControl.numberOfPages = datas.count
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initView()
    }

    private func initView() {

        backgroundColor = UIColor.white

        stickSubView(collectionView)

//        pageControl.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(pageControl)
//
//        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0).isActive = true
//
//        pageControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {

        return 4
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: GalleryViewCell.self),
            for: indexPath
        )

        guard let galleryCell = cell as? GalleryViewCell else { return cell }

        galleryCell.galleryImg.loadImage(datas[indexPath.row], placeHolder: UIImage(systemName: "video"))

        return galleryCell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        return delegate?.sizeForItem(self) ?? bounds.size
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {

//        pageControl.currentPage = indexPath.row
    }
}

private class GalleryViewCell: UICollectionViewCell {

    let galleryImg = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initView()
    }

    private func initView() {

        stickSubView(galleryImg)

        galleryImg.contentMode = .scaleAspectFill

        galleryImg.clipsToBounds = true
    }
}

