% 设置文件夹路径
data_folder = 'pie05_01';
save_folder = 'pie05_68';

% 设置每个文件夹中图片的数量
num_images_per_folder = 49;

% 创建保存数据文件的文件夹
mkdir(save_folder);

% 初始化空矩阵和列向量

% 遍历每个文件夹
for folder_id = 1:68
    % 初始化空矩阵和列向量
    fts = [];
    labels = [];
    % 初始化矩阵用于保存当前文件夹中的所有图片
    image_matrix = zeros(num_images_per_folder, 64*64);
    
    % 遍历当前文件夹中的所有图片
    
        for img_id = 1:num_images_per_folder
            % 读取图片
            img = imread(fullfile(data_folder, sprintf('%d/%d.jpg', folder_id, img_id)));
            %将rgb图转为灰度图
            %img_gray=rgb2gray(img);
            % 将图片转换为一维矩阵并添加到图片矩阵中
            image_matrix(img_id,:) = img(:)';
        end
    
    
    % 将当前文件夹中的所有图片按行添加到矩阵 fts 中
    fts = [fts; image_matrix];
    % 将当前文件夹对应的标号添加到列向量 labels 中
    labels = [labels; repmat(folder_id, [num_images_per_folder,1])];
    
    % 将当前文件夹中的所有图片保存为 .mat 文件
    save(fullfile(save_folder, sprintf('pie05_%d.mat', folder_id)), 'fts','labels');
end
