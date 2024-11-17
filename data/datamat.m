% �����ļ���·��
data_folder = 'pie05_01';
save_folder = 'pie05_68';

% ����ÿ���ļ�����ͼƬ������
num_images_per_folder = 49;

% �������������ļ����ļ���
mkdir(save_folder);

% ��ʼ���վ����������

% ����ÿ���ļ���
for folder_id = 1:68
    % ��ʼ���վ����������
    fts = [];
    labels = [];
    % ��ʼ���������ڱ��浱ǰ�ļ����е�����ͼƬ
    image_matrix = zeros(num_images_per_folder, 64*64);
    
    % ������ǰ�ļ����е�����ͼƬ
    
        for img_id = 1:num_images_per_folder
            % ��ȡͼƬ
            img = imread(fullfile(data_folder, sprintf('%d/%d.jpg', folder_id, img_id)));
            %��rgbͼתΪ�Ҷ�ͼ
            %img_gray=rgb2gray(img);
            % ��ͼƬת��Ϊһά������ӵ�ͼƬ������
            image_matrix(img_id,:) = img(:)';
        end
    
    
    % ����ǰ�ļ����е�����ͼƬ������ӵ����� fts ��
    fts = [fts; image_matrix];
    % ����ǰ�ļ��ж�Ӧ�ı����ӵ������� labels ��
    labels = [labels; repmat(folder_id, [num_images_per_folder,1])];
    
    % ����ǰ�ļ����е�����ͼƬ����Ϊ .mat �ļ�
    save(fullfile(save_folder, sprintf('pie05_%d.mat', folder_id)), 'fts','labels');
end
