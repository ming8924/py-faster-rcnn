# --------------------------------------------------------
# Fast R-CNN
# Copyright (c) 2015 Microsoft
# Licensed under The MIT License [see LICENSE for details]
# Written by Ross Girshick
# --------------------------------------------------------

"""Factory method for easily getting imdbs by name."""

__sets = {}

from datasets.pascal_voc import pascal_voc
from datasets.coco import coco
from datasets.pipa import pipa
from datasets.pascal_voc_person import pascal_voc_person
import numpy as np

# Set up voc_<year>_<split> using selective search "fast" mode
for year in ['2007', '2012']:
    for split in ['train', 'val', 'trainval', 'test']:
        name = 'voc_{}_{}'.format(year, split)
        __sets[name] = (lambda split=split, year=year: pascal_voc(split, year))

for year in ['2007', '2012']:
    for split in ['person_train', 'person_val', 'person_trainval', 'person_test']:
        name = 'voc_{}_{}'.format(year, split)
        __sets[name] = (lambda split=split, year=year: pascal_voc_person(split, year))

# Set up coco_2014_<split>
for year in ['2014']:
    for split in ['train', 'val', 'minival']:
        name = 'coco_{}_{}'.format(year, split)
        __sets[name] = (lambda split=split, year=year: coco(split, year))

# Set up coco_2015_<split>
for year in ['2015']:
    for split in ['test', 'test-dev']:
        name = 'coco_{}_{}'.format(year, split)
        __sets[name] = (lambda split=split, year=year: coco(split, year))

# Set up pipa_<split>
pipa_devkit_path = '/home/hpl/work/py-faster-rcnn/data/pipa'
for split in ['train', 'test']:
  name = 'pipa_{}'.format(split)
  __sets[name] = (lambda split=split: pipa(split, pipa_devkit_path))

def get_imdb(name):
  """Get an imdb (image database) by name."""
  if not __sets.has_key(name):
    raise KeyError('Unknown dataset: {}'.format(name))
  return __sets[name]()
    

def list_imdbs():
	"""List all registered imdbs."""
	return __sets.keys()
