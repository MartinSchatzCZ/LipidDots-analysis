function [ VO ] = fcnAnV( Ain, maxSize )
Seg = bwlabeln(Ain,26);
VO = regionprops(Seg,'Area','PixelList');
idx3 = ([VO.Area] < maxSize);
VO((idx3) >= 1 )=[];
end

