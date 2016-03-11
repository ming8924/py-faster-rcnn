# Train Faster-RCNN on Another Dataset

This is inspired by the modification made in https://github.com/zeyuanxy/fast-rcnn to train Fast R-CNN for another dataset.
Here we illustrate how to train a Faster R-CNN model with the Person in Personal Albums (PIPA) dataset 

### Prepare Dataset
We convert the annotations of PIPA to xml file to be consistent with Pascal VOC. This is done by convert_pipa_annotation.m, which calls VOCwritexml.m from the Pascal VOC devkit.

### Format Your Dataset

At first, the dataset must be reorganized to the following structure.
```
pipa
|-- data
    |-- Annotations
         |-- *.xml (Annotation files)
    |-- Images
         |-- *.jpg (Image files)
    |-- ImageSets
         |-- train.txt
```

The `train.txt` contains all the names(without extensions) of images files that will be used for training. For example, there are a few lines in `train.txt` below.

```
1023628_46942247
1023628_46942306
1023628_46942388
1023628_46942439
```

### Construct IMDB

You need to add a new python file describing the dataset we will use to the directory `$FRCNN_ROOT/lib/datasets`, see `pipa.py`. Then the following steps should be taken.
  - Modify `self._classes` in the constructor function to fit your dataset.
  - Be careful with the extensions of your image files. See `image_path_from_index` in `pipa.py`.
  - Since the format is consistent with Pascal VOC, we can reuse the function for parsing annotations. See `_load_pascal_annotation` in `pipa.py`.

Then you should modify the `factory.py` in the same directory. For example, to add **pipa**, we should add

```sh
pipa_devkit_path = '/home/ming/work/py-faster-rcnn/data/pipa'
for split in ['train', 'test']:
  name = 'pipa_{}'.format(split)
  __sets[name] = (lambda split=split: pipa(split, pipa_devkit_path))
```
Once the dataset is format to be consistent with Pascal VOC, the above guidelines are pretty much all that is needed.


### Modify Prototxt

For example, if you want to use the model **VGG16**, then you should modify `train.prototxt` in `$FRCNN_ROOT/models/VGG16`, it mainly concerns with the number of classes you want to train. Let's assume that the number of classes is `C (do not forget to count the `background` class). Then you should 
  - Modify `num_classes` to `C`;
  - Modify `num_output` in the `cls_score` layer to `C`
  - Modify `num_output` in the `bbox_pred` layer to `4 * C`

Remeber to modify `solver.prototxt` to call the corresponding trai.prototxt file. 

See https://github.com/rbgirshick/fast-rcnn/issues/11 for more details. 

### Train!

In the directory **$FRCNN_ROOT**, run the following command in the shell.

```sh
./experiments/scripts/faster_rcnn_end2end.sh 0 ZF pipa
```

### References

[Fast-RCNN] https://github.com/rbgirshick/fast-rcnn

[Train Fast-RCNN on Another Dataset] https://github.com/zeyuanxy/fast-rcnn