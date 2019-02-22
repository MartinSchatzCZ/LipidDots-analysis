function seg_out = fcn_goThArea(seg_I,Ap,count,jump,MaxArea)
seg_out=zeros(size(seg_I));
if count < 10  % Maximum 10 iteration
    sb = regionprops(seg_I,'Area','SubarrayIdx'); % load the object
    if count <= 1 % Remove small dots
        idx = ( [sb.Area] < 4);
        sb(idx==1)=[];
    end
    for i=1:length(sb) % For each object mask copy the image under mask 
       Ipp = Ap(sb(i).SubarrayIdx{1,1},sb(i).SubarrayIdx{1,2}); 
       if sb(i).Area < MaxArea % Check the maximum size of the object
           seg_out(sb(i).SubarrayIdx{1,1},sb(i).SubarrayIdx{1,2})=seg_I(sb(i).SubarrayIdx{1,1},sb(i).SubarrayIdx{1,2});
       else % Otherwise increase TH and check the object size
           sub_seg=zeros(size(Ipp));
           th = min(Ipp(:)) + jump;
           Nseg = zeros(size(Ipp));
           Nseg(Ipp > th) = 1;
           Nseg = logical(Nseg);
           sb2 = regionprops((Nseg),'Area','SubarrayIdx');
           if size(sb2)>0
               for j=1:length(sb2)
                  if sb2(j).Area < MaxArea % Object size in the limits -> result
                      sub_seg(sb2(j).SubarrayIdx{1,1},sb2(j).SubarrayIdx{1,2})=Nseg(sb2(j).SubarrayIdx{1,1},sb2(j).SubarrayIdx{1,2});
                  else % otherwise start recursive processing
                      sub_seg(sb2(j).SubarrayIdx{1,1},sb2(j).SubarrayIdx{1,2})=...
                          fcn_goThArea(Nseg(sb2(j).SubarrayIdx{1,1},sb2(j).SubarrayIdx{1,2}),Ipp(sb2(j).SubarrayIdx{1,1},sb2(j).SubarrayIdx{1,2}),count+1,jump*1.3,MaxArea);
                  end
               end
               seg_out(sb(i).SubarrayIdx{1,1},sb(i).SubarrayIdx{1,2})=sub_seg;
           else
                seg_out(sb(i).SubarrayIdx{1,1},sb(i).SubarrayIdx{1,2})=...
                          fcn_goThArea(Nseg,Ipp,count+1,jump*0.7,MaxArea);
           end
       end
    end
else
   seg_out(Ap>prctile(Ap(:),97)) = 1;
end
end

