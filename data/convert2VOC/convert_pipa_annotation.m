% This code converts the PIPA dataset into VOC format
% Index starts from 1 to make it consistent with VOC

clear 
close all
load data.mat
A = data.photo_ids;
[C, IA, IC] = unique(A);

if exist('Annotations', 'dir')~=7
  mkdir('Annotations');
end

for i = 1: length(C)
  disp(sprintf('%d/%d', i, length(C)));
  file_path = ['JPEGImages/', data.photoset_ids{IA(i)}, '_', data.photo_ids{IA(i)}, '.jpg'];
  filename = [data.photoset_ids{IA(i)}, '_', data.photo_ids{IA(i)}];
  if exist(file_path, 'file')
    im = imread(file_path);
    [h, w, c] = size(im);
    bbox = data.head_boxes(IC == IC(IA(i)), :);
    
    new_bbox = bbox;
    for j = 1: size(new_bbox, 1)
      new_bbox(j, 1) = max(new_bbox(j, 1), 1);
      new_bbox(j, 2) = max(new_bbox(j, 2), 1);
      new_bbox(j, 3) = min(new_bbox(j, 1) + new_bbox(j, 3), w);
      new_bbox(j, 4) = min(new_bbox(j, 2) + new_bbox(j, 4), h); 
      if new_bbox(j,3) > w
        disp('error');
      end
    end
    xml_data = [];
    xml_data.annotation.filename = filename;
    xml_data.annotation.size.width = num2str(w);
    xml_data.annotation.size.height = num2str(h);
    xml_data.annotation.size.depth = num2str(c);
    xml_data.annotation.segmented = '0';
    for obj_ind = 1: size(new_bbox, 1)
      xml_data.annotation.object(obj_ind).name = 'head';
      xml_data.annotation.object(obj_ind).pose = 'Unspecified';
      xml_data.annotation.object(obj_ind).truncated = '0';
      xml_data.annotation.object(obj_ind).difficult = '0';
      xml_data.annotation.object(obj_ind).bndbox.xmin = num2str(new_bbox(obj_ind, 1));
      xml_data.annotation.object(obj_ind).bndbox.ymin = num2str(new_bbox(obj_ind, 2));
      xml_data.annotation.object(obj_ind).bndbox.xmax = num2str(new_bbox(obj_ind, 3));
      xml_data.annotation.object(obj_ind).bndbox.ymax = num2str(new_bbox(obj_ind, 4));
    end  
    VOCwritexml(xml_data, sprintf('Annotations/%s.xml', xml_data.annotation.filename));
  end
end
  