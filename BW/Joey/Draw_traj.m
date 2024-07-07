clc; clear all;
load('location.mat');
dictionary = 'frames';
dictionary_output = 'trajFrames';
mkdir(dictionary_output)
file = dir(fullfile(dictionary, '*.tif'));
res = track(data(:,[1 2 4]),50);
ParNum = res(end,end);
X = zeros(ParNum,size(file,1));
Y = X;
%% Save video
for i = 1:numel(file)
    filename = fullfile(dictionary,file(i).name);
    imshow(filename)
    hold on
    parLocj = res(res(:,3) == i,:);
    X(:,i) = parLocj(:,1);
    Y(:,i) = parLocj(:,2);
    for j = 1:ParNum
        plot(X(j,1:i),Y(j,1:i))  
    end
    exportgraphics(gca, fullfile(dictionary_output,[num2str(i,'%04d'), '.tif']), 'Resolution',300)
    hold off
end

%% Save Trajectory Picture

imshow(filename)
hold on
for j = 1:res(end,end)
    drop = res(res(:,4) == j,:);
    plot(drop(:,1), drop(:,2))  
end
hold off
exportgraphics(gca, fullfile(['trajectory', '.tif']), 'Resolution',300)
