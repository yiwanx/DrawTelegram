//
// Created by Ivan Petukhov on 13/10/2022.
//

import Foundation
import PhotosUI

class PhotoCollectionViewController: UIViewController {
    private var allPhotos = PHFetchResult<PHAsset>()

    private var manager = PhotoCollectionManager()
    var gridCollectionView: UICollectionView!

    let initialRowCount: CGFloat = 3

    private var rowCount: CGFloat = 3

    var sideLength: CGFloat {
        view.bounds.size.width / rowCount - 1
    }

    var sideLengthPoints: CGFloat {
        sideLength * UIScreen.main.scale
    }

    var batchSize: CGSize {
        .init(width: sideLengthPoints, height: sideLengthPoints)
    }

    lazy var imageRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true
        return options
    }()

    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let sideLength = sideLength
        layout.itemSize = CGSize(width: sideLength, height: sideLength)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        return layout
    }

    let gesture = UIPinchGestureRecognizer()

    func setGridCollectionView() -> UICollectionView {
        var gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gridCollectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: PhotoCollectionCell.reuseId)
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.prefetchDataSource = self
        return gridCollectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        allPhotos = manager.loadPhotosObjects()
        gridCollectionView = setGridCollectionView()
        view.addSubview(gridCollectionView)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        gridCollectionView.constraint(to: view)
        gesture.addTarget(self, action: #selector(scalePiece))
        view.addGestureRecognizer(gesture)
    }

    @objc func scalePiece(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            var newRowCount = Int(initialRowCount * (1 / gestureRecognizer.scale))
            if newRowCount < 1 {
                newRowCount = 1
            } else if newRowCount > 10 {
                newRowCount = 10
            }
            rowCount = CGFloat(newRowCount)
            print(rowCount)
            print(gestureRecognizer.scale)
            gridCollectionView.setCollectionViewLayout(layout, animated: true)
        } else if gestureRecognizer.state == .ended {
            gestureRecognizer.scale = 1.0
        }
    }

}

extension PhotoCollectionViewController: UIGestureRecognizerDelegate {

}

extension PhotoCollectionViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = models[indexPath.row]
//        routeToDetailedPhoto(model)
    }
}

extension PhotoCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
        let indexPathRows = indexPaths.filter { $0.section == 0  }.map { $0.row }
        let prefetchAssets = allPhotos.objects(at: .init(indexPathRows))
        manager.imageManager.startCachingImages(for: prefetchAssets,
                targetSize: .init(width: sideLength, height: sideLength),
                contentMode: .aspectFill, options: imageRequestOptions)
    }

    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let indexPathRows = indexPaths.filter { $0.section == 0  }.map { $0.row }
        let prefetchAssets = allPhotos.objects(at: .init(indexPathRows))
        manager.imageManager.stopCachingImages(for: prefetchAssets,
                targetSize: batchSize,
                contentMode: .aspectFill, options: imageRequestOptions)
    }
}

extension PhotoCollectionViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allPhotos.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.reuseId, for: indexPath)
                as? PhotoCollectionCell, indexPath.row < allPhotos.count  else { return .init() }
        let asset = allPhotos[indexPath.row]
        manager.imageManager.requestImage(for: asset, targetSize: batchSize,
                contentMode: .aspectFill, options: imageRequestOptions) { (image: UIImage?, dictionary: [AnyHashable: Any]?) in
            DispatchQueue.main.async { [weak cell] in
                cell?.imageView.image = image
                cell?.imageView.contentMode = .scaleToFill
            }
        }
        return cell
    }
}

extension CGSize {
    static func rect(_ length: CGFloat) -> Self {
        .init(width: length, height: length)
    }
}