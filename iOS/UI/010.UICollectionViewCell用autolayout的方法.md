# UICollectionViewCell用autolayout的方法：

```
if let collectionViewLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
```

