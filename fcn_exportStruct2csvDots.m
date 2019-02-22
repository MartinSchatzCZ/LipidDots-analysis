function [ out ] = fcn_exportStruct2csvDots( struct, name )
% Create from the struct variable semicolon separated CSV file
out = isstruct(struct);
    if out == 1
        oldField = 'FilledArea';
        newField = 'Area3D';
        [struct.(newField)] = struct.(oldField);
        f={'BoundingBox','SubarrayIdx','Image','FilledImage','PixelIdxList',...
            'PixelList','Centroid','Area','FilledArea'};
        s = rmfield(struct,f);
        snew = orderfields(s, {'fileName', 'id', 'Area3D','IntensitySum','IntensityMean',...
            'IntensityMedian','CentroidX','CentroidY','CentroidZ','idCellObject'});
        writetable(struct2table(snew), [name '.csv'],'WriteVariableNames',1,'Delimiter','semi');
    end
end

