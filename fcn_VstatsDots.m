function [ output ] = fcn_VstatsDots( BW_seg, Orig_stack)
%VstatsFn gets statistics from segmented part and ads mean and sum of
%values of segmented parts from stack of images
%   BW_seg        3D binnary array of segmented Orgig_stack 
%   Orig_stack    original 3D uint8/uint16 stack of images
%   output        

Seg = bwlabeln(BW_seg,26);
% everything I can get from 3D
Vstats = regionprops(Seg,'Area', 'BoundingBox', 'Centroid', 'FilledArea', 'FilledImage', 'Image', 'PixelIdxList', 'PixelList', 'SubarrayIdx');
for i = 1:length(Vstats)
    Im_part = Orig_stack(Vstats(i).SubarrayIdx{1,1},Vstats(i).SubarrayIdx{1,2},Vstats(i).SubarrayIdx{1,3});
    Vstats(i).IntensitySum = sum(Im_part(:));
    Vstats(i).IntensityMean = mean(Im_part(:));
    Vstats(i).IntensityMedian = median(Im_part(:));
    Vstats(i).id = i;
    Vstats(i).CentroidX = Vstats(i).Centroid(1);
    Vstats(i).CentroidY = Vstats(i).Centroid(2);
    Vstats(i).CentroidZ = Vstats(i).Centroid(3);
    Vstats(i).idCellObject = -1;
end
output = Vstats;
end

