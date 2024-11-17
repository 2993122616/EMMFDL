folder = 'AR_all_60x50';  % �滻Ϊ����ļ���·��
filePattern = fullfile(folder, '*.bmp');  % �滻Ϊ����ļ���չ��
jpegFiles = dir(filePattern);

for i = 1:length(jpegFiles)
    oldName = fullfile(folder, jpegFiles(i).name);
    newName = fullfile(folder, [num2str(i) '.bmp']);
    movefile(oldName, newName);
end