%%
function mpoint = findcenterpoint(A,allpoints)
rs1 = 5:5:30;
npoints = size(allpoints,1);
pointr = [];
for p = 1:npoints
    px1 = allpoints(p,1); py1 = allpoints(p,2);
    noPWFound = true; ridx = 1;    
    while noPWFound && ridx<=numel(rs1)
        r1 = rs1(ridx);
        [pw,pwsign] = checkpw(A,px1,py1,r1);
        if ~isempty(pw)
            noPWFound = false; pointr(p,1) = r1;               
        else
            pointr(p,1) = nan;
        end
        ridx = ridx+1; 
    end
end
mInx = find(pointr==min(pointr));
% pw center coordinates
mpointc = mean(allpoints(mInx,:),1);
mpoint(1,1:2) = round(mpointc);
end