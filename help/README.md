# Train Faster-RCNN on Another Dataset

This is inspired by the modification made in https://github.com/zeyuanxy/fast-rcnn to train Fast R-CNN for another dataset.
Here we illustrate how to train a Faster R-CNN model with the Person in Personal Albums (PIPA) dataset 

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
We convert the annotations of PIPA to xml file to be consistent with Pascal VOC. This is done by 

The `train.txt` contains all the names(without extensions) of images files that will be used for training. For example, there are a few lines in `train.txt` below.

```
crop_000011
crop_000603
crop_000606
crop_000607
crop_000608
```

### Construct IMDB

You need to add a new python file describing the dataset we will use to the directory `$FRCNN_ROOT/lib/datasets`, see `inria.py`. Then the following steps should be taken.
  - Modify `self._classes` in the constructor function to fit your dataset.
  - Be careful with the extensions of your image files. See `image_path_from_index` in `inria.py`.
  - Write the function for parsing annotations. See `_load_inria_annotation` in `inria.py`.
  - Do not forget to add `import` syntaxes in your own python file and other python files in the same directory.

Then you should modify the `factory.py` in the same directory. For example, to add **INRIA Person**, we should add

```sh
inria_devkit_path = '/home/szy/INRIA'
for split in ['train', 'test']:
    name = '{}_{}'.format('inria', split)
    __sets[name] = (lambda split=split: datasets.inria(split, inria_devkit_path))
```

See the example `inria.py` at https://github.com/EdisonResearch/fast-rcnn/blob/master/lib/datasets/inria.py.

### Modify Prototxt

For example, if you want to use the model **VGG16**, then you should modify `train.prototxt` in `$FRCNN_ROOT/models/VGG16`, it mainly concerns with the number of classes you want to train. Let's assume that the number of classes is `C (do not forget to count the `background` class). Then you should 
  - Modify `num_classes` to `C`;
  - Modify `num_output` in the `cls_score` layer to `C`
  - Modify `num_output` in the `bbox_pred` layer to `4 * C`

See https://github.com/rbgirshick/fast-rcnn/issues/11 for more details. 

### Train!

In the directory **$FRCNN_ROOT**, run the following command in the shell.

```sh
./tools/train_net.py --gpu 0 --solver models/VGG_CNN_M_1024/solver.prototxt \
    --weights data/imagenet_models/VGG_CNN_M_1024.v2.caffemodel --imdb inria_train
```

Be careful with the **imdb** argument as it specifies the dataset you will train on. Then just drink a cup of coffee and take a break to wait for the training.

### References

[Fast-RCNN] https://github.com/rbgirshick/fast-rcnn
[Train Fast-RCNN on Another Dataset] https://github.com/zeyuanxy/fast-rcnn