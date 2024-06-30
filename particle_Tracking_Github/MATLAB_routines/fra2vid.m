clc; clear all
myobj = VideoWriter('traj.avi');
myobj.FrameRate = 10;
open(myobj)
filename = 'traj_frame\';
File = dir(filename);
FileNames = {File.name};
FileNames = FileNames(3:end);
for i = 1:length(FileNames)
    frame = imread([filename,FileNames{i}]);
    writeVideo(myobj, frame)
end
close(myobj)