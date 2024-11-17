% 设置原始图片文件夹路径和缩放后图片保存的文件夹路径
img_folder = 'pie05';
resize_folder = 'pie05_01';

% 设置每个文件夹中存放的图片数量
num_images_per_folder = 49;

% 遍历每一张图片
for i = 1:3332
    % 读取原始图片
    img = imread(fullfile(img_folder, sprintf('%d.jpg', i)));
    % 计算图片应该保存到哪个文件夹中
    folder_id = ceil(i / num_images_per_folder);
    % 如果文件夹不存在，则创建文件夹
    folder_path = fullfile(resize_folder, sprintf('%d', folder_id));
    if ~exist(folder_path, 'dir')
        mkdir(folder_path);
    end
    % 保存的图片
    img_name = mod(i-1, num_images_per_folder) + 1;
    imwrite(img, fullfile(folder_path, sprintf('%d.jpg', img_name)));
end