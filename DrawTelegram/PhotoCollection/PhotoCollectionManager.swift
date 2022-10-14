//
// Created by Ivan Petukhov on 13/10/2022.
//

import Foundation
import PhotosUI

class PhotoCollectionManager {

    func loadPhotosObjects() -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                    key: "creationDate",
                    ascending: false)
        ]
        allPhotosOptions.fetchLimit = 1000
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }

    let imageManager = PHCachingImageManager()
}
