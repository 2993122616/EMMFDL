folder = 'AR_all_60x50';  % 替换为你的文件夹路径
filePattern = fullfile(folder, '*.bmp');  % 替换为你的文件扩展名
jpegFiles = dir(filePattern);

for i = 1:length(jpegFiles)
    oldName = fullfile(folder, jpegFiles(i).name);
    newName = fullfile(folder, [num2str(i) '.bmp']);
    movefile(oldName, newName);
end