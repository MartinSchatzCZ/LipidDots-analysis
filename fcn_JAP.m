function [ outputDots, outputCells] = fcn_JAP(B_Files,N_B,G_Files,~,Z,dir)
% Function to process JAPONICUS
outputDots = [];
outputCells = [];

% FIR filter parameters
b = fir1(200,0.001);
h = ftrans2(b);

for i=1:N_B
    tic
    %% SET detection threshold [TH_cell] from the middle slice 
        I=imread(B_Files(i).name,floor(Z/2));
        I(I>median(I(:)))=median(I(:));
            figure(3)
            imagesc(I)
            title('MIDDLE SLICE: Original image')
        background = filter2(h,I);
            figure(4)
            imagesc(background)
            title('MIDDLE SLICE:Background - quality depends on the filter size')
        I2 = double(I) - background;
        I2(I2 > 2*median(I2(:))) = median(I2(:));
            figure(5)
            I2(I2 > 2*median(I2(:))) = median(I2(:));
            imagesc(medfilt2(I2,[7 7]))
            title('MIDDLE SLICE:Subtracted background from image + median smoothing')
        
        TH_cell=floor(((min(I2(:))-max(I2(:)))*0.30));
        oBW2 = zeros(size(I2));
        oBW2(I2 < TH_cell)=1;
        oBW2 = imclearborder(oBW2);
        oBW2 = imclose(oBW2,strel('disk',3));
        oBW2 = bwareaopen(oBW2,200);  % Remove cells smaller than 200px
        oBW2 = imfill(oBW2,'holes');
        
            figure(6), imagesc(oBW2)
            title('MIDDLE SLICE:BW - Segmentation')
            
    % Allocate the space in memory for processing  
    A = zeros(size(I,1),size(I,2),Z);
    Ag = zeros(size(I,1),size(I,2),Z);
    Cells = false(size(I,1),size(I,2),Z);
    Dots = false(size(I,1),size(I,2),Z);
    
    for z = 1:Z % GO SLICE BY SLICE
        I = imread(B_Files(i).name,z);
        A(:,:,z) = I;
    
    %% BACKGROUND REMOVAL
    background = filter2(h,I);
    I2 = double(I) - background;

    
    %% Segmentation
    oBW2 = zeros(size(I2));
    oBW2(I2 < TH_cell)=1;
    oBW2 = imclearborder(oBW2);
    oBW2 = imclose(oBW2,strel('disk',3));
    oBW2 = bwareaopen(oBW2,200);   % Remove cells smaller than 200px      
        
    %% Find area of cells
    [B2,~] = bwboundaries(oBW2,'noholes');
    sb2 = regionprops(logical(oBW2),'All');

    % Remove small cells 
    idx = ( [sb2.Area] < 1000);
    % Remove big cells 
    idx2 = ( [sb2.Area] > 10000);
    % Remove cells with Solidity < 50%
    % Solidity is area fraction of the region as compared to its convex hull. 
    idx3 = ( [sb2.Solidity] < 0.5);

    B2((idx+idx2+idx3) >= 1 )=[];       
        
    % Update cells
    tmpBW = zeros(size(oBW2));
    for k = 1:length(B2)
        boundary = B2{k};
        for pix = 1:size(boundary,1)
            tmpBW(boundary(pix,1), boundary(pix,2))=1;
        end
    end
    tmpBW = imfill(tmpBW);
    Cells(:,:,z) = tmpBW;

%% Droplets detection 
    Ig = imread(G_Files(i).name,z);
    Ag(:,:,z) = Ig;

 %% Segmentation
        th=300;
        jump = 25;
        MaxArea = 100;
        BW = Ig>th(1);       
        BWdots = fcn_goThArea(BW,Ig,1,jump,MaxArea);
        BWdots = BWdots.*tmpBW;
        BWdots = bwareaopen(BWdots,4);      % Remove dots smaller than 4 px       
        sbBW = regionprops(BWdots,'Area');
        idxBW = ( [sbBW.Area] > MaxArea);        
        [BB,~] = bwboundaries(BWdots,'noholes');
        BB(idxBW==1)=[];
        Dots(:,:,z) = BWdots;
    
    end
%% OUTPUT DATA   
Name = B_Files(i).name(1:end-4); % Name of file
[Cellso,Aout]=fcn_intCells(Cells,1); % Interpolation of the space between detected slices
[ outputDots, outputCells] = fcn_ComVstats( Dots, Ag, Cellso, A ); % Volume stats

% For each dot prepare name
for m = 1:length(outputDots)
    outputDots(m).fileName=Name;
end
% For each cell prepare name, DotsID and 2D area
for n = 1:length(outputCells)
    outputCells(n).fileName=Name;
    outputCells(n).dotsId=mat2str(outputCells(n).dotsId);
    outputCells(n).Area2D=sum(sum(logical(sum(outputCells(n).Image,3))));
end
% Directory to save data
Path=[dir '/JAP/'];
% Draw output tiff file
fcn_drawAll(outputDots,Ag,outputCells,A,Path,Name,B_Files);

% Export results to csv file
fcn_exportStruct2csvDots( outputDots, [dir '/CSV/' Name '_dots'] );
fcn_exportStruct2csvCells( outputCells, [dir '/CSV/' Name '_cells'] );

% Save matlab data
save(Name,'outputDots','outputCells','B_Files','Ag','A','Path','Name','Cells','Dots');
% Print overview of detection to Command window
t = toc;
disp(['Name: ' Name ', Cells: ' num2str(length(outputCells)) ', Dots: ' num2str(length(outputDots)) ', in ' num2str(t) ' s'])

end

