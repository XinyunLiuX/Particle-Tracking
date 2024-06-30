clc; clear all;
% import the video file 
obj = VideoReader('sciadv.ade0320_movie_s2.avi'); 
vid = read(obj); 
  
 % read the total number of frames 
frames = obj.NumberOfFrames; 
  
% file format of the frames to be saved in 
ST ='.tif'; 

% dir
mkdir('frames');
  
% reading and writing the frames  
for x = 1 : frames 
    
    Prefix = 'frame';
  
    % converting integer to string 
    Sx = num2str(x,'%04d'); 
  
    % concatenating 2 strings 
    Strc = strcat(Prefix, Sx, ST); 
    Vid = vid(:, :, :, x); 
    cd frames 
  
    % exporting the frames 
    %imwrite(rgb2gray(Vid), Strc); 
    imwrite(Vid, Strc); 
    cd ..   
end