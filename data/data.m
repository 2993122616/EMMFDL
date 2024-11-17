% ����ԭʼͼƬ�ļ���·�������ź�ͼƬ������ļ���·��
img_folder = 'pie05';
resize_folder = 'pie05_01';

% ����ÿ���ļ����д�ŵ�ͼƬ����
num_images_per_folder = 49;

% ����ÿһ��ͼƬ
for i = 1:3332
    % ��ȡԭʼͼƬ
    img = imread(fullfile(img_folder, sprintf('%d.jpg', i)));
    % ����ͼƬӦ�ñ��浽�ĸ��ļ�����
    folder_id = ceil(i / num_images_per_folder);
    % ����ļ��в����ڣ��򴴽��ļ���
    folder_path = fullfile(resize_folder, sprintf('%d', folder_id));
    if ~exist(folder_path, 'dir')
        mkdir(folder_path);
    end
    % �����ͼƬ
    img_name = mod(i-1, num_images_per_folder) + 1;
    imwrite(img, fullfile(folder_path, sprintf('%d.jpg', img_name)));
end