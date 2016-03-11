clear
load data.mat
split_sets = {'train', 'test'};
for set_id = 1: numel(split_sets)
  split_set = split_sets{set_id};
  fid = fopen(sprintf('%s.txt', split_set), 'w');
  d = dir(sprintf('%s/*.jpg', split_set));
  for i = 1: numel(d)
    cur_name = d(i).name;
    fprintf(fid, '%s\n', cur_name(1:end-4));
  end
  fclose(fid);
end
