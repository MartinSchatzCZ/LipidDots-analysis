function fcn_drawAll(outputDots,Ag,outputCells,A,Path,Name,B_Files)
Dots=zeros(size(A));
Cells=Dots;

for i=1:length(outputDots)
    for j=1:size(outputDots(i).PixelList,1)
        Dots(outputDots(i).PixelList(j,2),outputDots(i).PixelList(j,1),outputDots(i).PixelList(j,3))=1;
    end
end

for i=1:size(Dots,3)
        [BB,~] = bwboundaries(Dots(:,:,i),'noholes');

        f2=figure(2);
        set(2,'units','normalized','outerposition',[0 0.1 .55 .45])
        imagesc(Ag(:,:,i)), colorbar
                hold on
                    for k = 1:length(BB)
                       boundary = BB{k};
                       plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1)
                    end
                hold off
        title(['Z:',num2str(i),'/',num2str(size(Dots,3)),' -> Dots detection under mask'])
        for dt=1:length(outputDots)
            if round(outputDots(dt).CentroidZ) == i
               text(round(outputDots(dt).CentroidX),round(outputDots(dt).CentroidY),num2str(outputDots(dt).id)) 
            end
        end
        drawnow;
        
        %% save
        % a = getframe(f1);
% if z==1
% imwrite(rgb2gray(a.cdata), ['OUT/POM/',B_Files(i).name(1:end-4) 'B.TIFF']);
% else
% imwrite(rgb2gray(a.cdata), ['OUT/POM/',B_Files(i).name(1:end-4) 'B.TIFF'], 'writemode', 'append');
% end
% 
b = getframe(f2);
if i==1
imwrite(rgb2gray(b.cdata), [Path Name 'G.TIFF']);
else
imwrite(rgb2gray(b.cdata), [Path Name 'G.TIFF'], 'writemode', 'append');
end
end

for i=1:length(outputCells)
    for j=1:length(outputCells(i).PixelList)
        Cells(outputCells(i).PixelList(j,2),outputCells(i).PixelList(j,1),outputCells(i).PixelList(j,3))=1;
    end
end

for i=1:size(Cells,3)
    [B2,~] = bwboundaries(Cells(:,:,i),'noholes');
    figure(1)
    set(1,'units','normalized','outerposition',[0 0.5 .55 .45])
    f1=figure(1);  imagesc(A(:,:,i)), colorbar
            hold on
                for k = 1:length(B2)
                   boundary = B2{k};
                   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
                end
            hold off
            title(['Z:',num2str(i),'/',num2str(size(Cells,3)),' -> Segmentation on filtered image'])
            for dt=1:length(outputCells)
                if round(outputCells(dt).CentroidZ) == i
                   text(round(outputCells(dt).CentroidX),round(outputCells(dt).CentroidY),num2str(outputCells(dt).id)) 
                end
            end
            drawnow;
    %% save
a = getframe(f1);
if i==1
imwrite(rgb2gray(a.cdata), [Path Name 'B.TIFF']);
else
imwrite(rgb2gray(a.cdata), [Path Name 'B.TIFF'], 'writemode', 'append');
end

% b = getframe(f2);
% if z==1
% imwrite(rgb2gray(b.cdata), ['OUT/POM/',B_Files(i).name(1:end-4) 'G.TIFF']);
% else
% imwrite(rgb2gray(b.cdata), ['OUT/POM/',B_Files(i).name(1:end-4) 'G.TIFF'], 'writemode', 'append');
% end
end
end

