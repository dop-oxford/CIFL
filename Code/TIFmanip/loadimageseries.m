function [imageseries,numberofimages,xsize,ysize,bitdepth] = loadimageseries(File)

% Load image series and store it in a 3D array
% Supported series are 8-bit, 16-bit and 24-bit .tif.

%h = waitbar(0,'Loading image series');

% Preallocation
infoserie = imfinfo(File);

if infoserie(1).BitDepth == 16
    imageseries = uint16(zeros(infoserie(1).Height,infoserie(1).Width,size(infoserie,2)));
    bitdepth = 16;
elseif infoserie(1).BitDepth == 8
    imageseries = uint8(zeros(infoserie(1).Height,infoserie(1).Width,size(infoserie,2)));
    bitdepth = 8;
 elseif infoserie(1).BitDepth == 24
    imageseries = uint8(zeros(infoserie(1).Height,infoserie(1).Width,3,size(infoserie,2)));
    bitdepth = 24;  
end
 
if size(infoserie,1) > size(infoserie,2)
    numberofimages = size(infoserie,1);
else
    numberofimages = size(infoserie,2);
end
xsize = infoserie(1).Width;
ysize = infoserie(1).Height;

% Read and store image series
if bitdepth == 8 || bitdepth == 16
    for frame = 1:numberofimages
        [imageseries(:,:,frame), ~] = imread(File, frame);
    %waitbar(frame/size(infoserie,2),h);
    end
elseif bitdepth == 24
    for frame = 1:numberofimages
        [imageseries(:,:,:,frame), ~] = imread(File, frame);
    %waitbar(frame/size(infoserie,2),h);
    end
end
%close(h);
