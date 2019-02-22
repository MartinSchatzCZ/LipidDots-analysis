function [ outputDots,outputCells] = fcn_ComVstats( BW_segDots, Orig_stackDots, BW_segCell, Orig_stackCell )
%ComVstats compute volume characteristics of detected cells and dots
%   BW_segDots        3D binnary array of segmented dots Orgig_stackT 
%   Orig_stackDots    original 3D uint8/uint16 stack of images
%   BW_segCell        3D binnary array of segmented cells Orgig_stack 
%   Orig_stackCell    original 3D uint8/uint16 stack of images

[ outputDots ] = fcn_VstatsDots( BW_segDots, Orig_stackDots);
[ outputCells ] = fcn_VstatsCell( BW_segCell, Orig_stackCell, Orig_stackDots);

% Remove small dots
% idx = ([outputDots.Area] < 10);
% Remove dots from one slice only
% idx2 = (mod([outputDots.CentroidZ],1) == 0);
% outputDots((idx+idx2) >= 1 )=[];
% outputDots((idx) >= 1 )=[];

% Remove small cells
idx3 = ([outputCells.Area] < 200);
% Remove big cells
% idx4 = ([outputCells.Area] > 300000);
% Remove dots from one slice only
idx5 = (mod([outputCells.CentroidZ],1) == 0);
outputCells((idx3+idx5) >= 1 )=[];

% outputDots(1).idCell=[];
for b=1:length(outputCells)
    outputCells(b).numDots=0;
    outputCells(b).dotsId=[];
    outputCells(b).Dot_intensity_sum_per_cell=0; 
end
for i=1:length(outputCells)
    for j=1:length(outputDots)
        if outputDots(j).idCellObject == -1
            if sum((ismember(outputDots(j).PixelList(:,1),outputCells(i).PixelList(:,1)))) && sum((ismember(outputDots(j).PixelList(:,2),outputCells(i).PixelList(:,2)))) && sum((ismember(outputDots(j).PixelList(:,3),outputCells(i).PixelList(:,3)))) %logical 1 (true) where the data in A is found in B
                outputDots(j).idCellObject=outputCells(i).id;         % add id of cell to info about dot
                outputCells(i).dotsId=[outputCells(i).dotsId; outputDots(j).id]; % add id number to array of dots ids
                outputCells(i).numDots=outputCells(i).numDots+1; % increment number of dots in cell info
                outputCells(i).Dot_intensity_sum_per_cell = outputCells(i).Dot_intensity_sum_per_cell + ...
                outputDots(j).IntensitySum;
            end
        end
    end
end
idxE = ([outputDots.idCellObject] == -1);
outputDots((idxE) == 1 )=[];
end

