function [ outputCells ] = fcn_VstatsCell( BW_segCell, Orig_stackCell,Orig_stackDots)
%VstatsFn gets statistics from segmented part and ads mean and sum of
%values of segmented parts from stack of images
%   BW_seg        3D binnary array of segmented Orgig_stack 
%   Orig_stack    original 3D uint8/uint16 stack of images
%   output        

Seg = bwlabeln(BW_segCell,26);
% everything I can get from 3D
Vstats = regionprops(Seg,'Area', 'BoundingBox', 'Centroid', 'FilledArea', 'FilledImage', 'Image', 'PixelIdxList', 'PixelList', 'SubarrayIdx');
for i = 1:length(Vstats)
    Im_partBlue = Orig_stackCell(Vstats(i).SubarrayIdx{1,1},Vstats(i).SubarrayIdx{1,2},Vstats(i).SubarrayIdx{1,3});
    Im_partGreen = Orig_stackDots(Vstats(i).SubarrayIdx{1,1},Vstats(i).SubarrayIdx{1,2},Vstats(i).SubarrayIdx{1,3});
    Vstats(i).IntensitySumBlue = sum(Im_partBlue(:));
    Vstats(i).IntensitySumGreen = sum(Im_partGreen(:));
    Vstats(i).IntensityMeanBlue = mean(Im_partBlue(:));
    Vstats(i).IntensityMeanGreen = mean(Im_partGreen(:));
    Vstats(i).IntensityMedianBlue = median(Im_partBlue(:));
    Vstats(i).IntensityMedianGreen = median(Im_partGreen(:));
    Vstats(i).id = i;
    Vstats(i).CentroidX = Vstats(i).Centroid(1);
    Vstats(i).CentroidY = Vstats(i).Centroid(2);
    Vstats(i).CentroidZ = Vstats(i).Centroid(3);
end
outputCells = Vstats;
end

