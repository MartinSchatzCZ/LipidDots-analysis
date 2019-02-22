function [Cellsout,Aout]=fcn_intCells(Cells,stSize)
% Function for interpolation of the space between detected slices
[m, n, k]=size(Cells); % TIFF image dimension
Cellsout=zeros(size(Cells)); % Output file preallocation
AB3=zeros(size(Cells));
AC3=zeros(size(Cells));
AD3=zeros(size(Cells));
AE3=zeros(size(Cells));

vect=zeros(1,k);
ABm=zeros(m,n);
ACm=zeros(m,n);
ADm=zeros(m,n);
AEm=zeros(m,n);

Ac=0;
Ab=0;
Ad=0;
Ae=0;

B=[ ones(1,stSize) 0 0 0 ones(1,stSize) ];
C=[ ones(1,stSize) 0 0 0 0 ones(1,stSize) ];
D=[ ones(1,stSize) 0 0 ones(1,stSize) ];
E=[ ones(1,stSize) 0 ones(1,stSize) ];

for i=1:m
    for j=1:n
        vect=squeeze(Cells(i,j,:))';
       
        AB = strfind(vect,B);
        AC = strfind(vect,C);
        AD = strfind(vect,D);
        AE = strfind(vect,E);
        if AB>0
            for k=1:length(AB)
                vect(AB(k)+stSize:AB(k)+(stSize+2))=1;
            end
            Ab=Ab+1;
            ABm(i,j)=1;
            AB3(i,j,:)=vect;
        end

        if AC>0
            for k=1:length(AC)
                vect(AC(k)+stSize:AC(k)+(stSize+3))=1;
            end
            Ac=Ac+1;
            ACm(i,j)=1;
            AC3(i,j,:)=vect;
        end
        
        if AD>0
            for k=1:length(AD)
                vect(AD(k)+stSize:AD(k)+(stSize+1))=1;
            end
            Ad=Ad+1;
            ADm(i,j)=1;
            AD3(i,j,:)=vect;
        end
        
        if AE>0
            for k=1:length(AE)
                vect(AE(k)+stSize)=1;
            end
            Ae=Ae+1;
            AEm(i,j)=1;
            AE3(i,j,:)=vect;
        end
    end
end

maxSize=400;
[ VB ] = fcnAnV( AB3, maxSize*4 );
[ VC ] = fcnAnV( AC3, maxSize*3 );
[ VD ] = fcnAnV( AD3, maxSize*2 );
[ VE ] = fcnAnV( AE3, maxSize*1 );

disp(['Encountred: ' num2str(Ae) ', ' num2str(Ad) ', ' num2str(Ab) ', ' num2str(Ac)]);
disp(['Cells out: ' num2str(length(VE)) ', ' num2str(length(VD)) ', ' num2str(length(VB)) ', ' num2str(length(VC))]);


for i=1:length(VB)
    for j=1:size(VB(i).PixelList,1)
        Cells(VB(i).PixelList(j,2),VB(i).PixelList(j,1),VB(i).PixelList(j,3))=1;
        AB3(VB(i).PixelList(j,2),VB(i).PixelList(j,1),VB(i).PixelList(j,3))=1;
    end
end

for i=1:length(VC)
    for j=1:size(VC(i).PixelList,1)
        Cells(VC(i).PixelList(j,2),VC(i).PixelList(j,1),VC(i).PixelList(j,3))=1;
        AC3(VC(i).PixelList(j,2),VC(i).PixelList(j,1),VC(i).PixelList(j,3))=1;
    end
end

for i=1:length(VD)
    for j=1:size(VD(i).PixelList,1)
        Cells(VD(i).PixelList(j,2),VD(i).PixelList(j,1),VD(i).PixelList(j,3))=1;
        AD3(VD(i).PixelList(j,2),VD(i).PixelList(j,1),VD(i).PixelList(j,3))=1;
    end
end

for i=1:length(VE)
    for j=1:size(VE(i).PixelList,1)
        Cells(VE(i).PixelList(j,2),VE(i).PixelList(j,1),VE(i).PixelList(j,3))=1;
        AE3(VE(i).PixelList(j,2),VE(i).PixelList(j,1),VE(i).PixelList(j,3))=1;
    end
end

Cellsout=Cells;

Aout(:,:,1)=sum(AE3,3);
Aout(:,:,2)=sum(AD3,3);
Aout(:,:,3)=sum(AB3,3);
Aout(:,:,4)=sum(AC3,3);
end