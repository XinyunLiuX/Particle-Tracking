clc; clear all;
addpath('Matlab routines')
addpath('frames')
%% effective frames
f_start = 5;
f_end = 45;
%% estimated sizes, important input
sz = 25;    
%%
poslist = Ftrack('bgrem_frame',f_start, f_end, sz);
pos = poslist(:, [1:2, 5]);
param = struct('mem',2,'good',5,'dim',2,'quiet',0);
linked = track(pos,100,param);
max(linked(:,4))

%%
mkdir('traj_frame')
i = 1;
for frame_i = f_start:f_end
    I = imread(['bgrem_frame',num2str(frame_i,'%04d'),'.tif']);
    figure
    imshow(I);
    hold on
    if i == 1
        scatter(linked(1:i,1), linked(1:i,2), 'r.')
    else
        plot(linked(1:i,1), linked(1:i,2), 'r', 'Linewidth',1.2)
    end
    %saveas(gcf,)
    exportgraphics(gca,['traj_frame\', num2str(i,'%04d'), '.tif'],'Resolution',300)
    i = i+1;
    pause(1)
    close all
end 

%% Focus on one trajectory

% for i = ispan(1):ispan(end)
%     I = imread(['frame',num2str(linked(i,3),'%04d'),'.tif']);
%     imshow(I);
%     hold on
%     text(100,200,['frame',num2str(linked(i,3))])
%     plot(linked(i,1), linked(i,2), 'ro')
%     hold off
%     pause(1)
% end