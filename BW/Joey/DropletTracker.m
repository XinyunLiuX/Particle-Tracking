%% Input
clc;
clear all;

THRESHOLD = 0.02;
RADIUSRANGE = [5 15];
AREATHRESHOLD = 500;

RADIUSMASK = 430;

DATE = '2024-02-12';
RUNINDEX = '01';
VIDINDEX = '00';

DEBUGEXPECTEDCOUNT = 16;
%<<<>>>
DEBUG = 1;

%% Setup
clear figure;

instanceDirectory = fullfile('Runs', DATE, RUNINDEX);
pathId = fullfile(instanceDirectory, VIDINDEX);

files = dir([pathId '*.avi']);
data = [];
%droplets = [];
%% Multiple
for i = 1:numel(files)
    
    fileName = fullfile(files(i).folder, files(i).name);

    reader = VideoReader(fileName);

    frameCount = reader.NumFrames;
    frameWidth = reader.Width;
    frameHeight = reader.Height;
    
    frameIndex = 0;
    
    while reader.hasFrame()
        frameIndex = frameIndex + 1;
        originalFrame = reader.readFrame();
        frame = single(originalFrame(:,:, 1)) / 255;

        frame = imclearborder(frame);
        frame = imfill(frame, "holes");

            BW = imbinarize(frame, THRESHOLD);

            BW = bwareaopen(BW, AREATHRESHOLD);
            BW = imfill(BW, "holes");

            D = -bwdist(~BW);
            D(~BW) = -Inf;
            
            mask = imextendedmin(D, 1);
            D2 = imimposemin(D,mask);

            L = watershed(D2);

        props = regionprops("table", L, "Centroid", "MajorAxisLength", "MinorAxisLength");
        centers = props.Centroid;
        radii = mean([props.MinorAxisLength, props.MajorAxisLength], 2) / 2;
        
        centers = centers(radii<100,:);
        radii = radii(radii<100);

        foundCount = 0;
        for j = 1:size(centers, 1)
            
            %droplet = droplets(j);  <<<OLD>>>
            

            radius = radii(j);

            if radius > RADIUSRANGE(1) && radius < RADIUSRANGE(2)       
                data = [data; [centers(j,1) centers(j,2) j frameIndex]];
                foundCount = foundCount + 1;
            end
        end

        if DEBUG && foundCount ~= DEBUGEXPECTEDCOUNT
            clear figure;
            imshowpair(originalFrame, originalFrame, 'montage');
            viscircles(centers,2*ones(length(centers),1));
            waitforbuttonpress;
        end
    end
end

save('location.mat', 'data');
