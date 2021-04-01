function [pwAllm] = pinwheel_filter3(pwAll,sizeN)
nframe = length(pwAll);
%%
cellKeep = [];
for cc = 1:nframe
    cellPoints = pwAll{cc};
    nf = 3;
    if ~isempty(cellPoints)
        if cc > nf && cc <= (nframe-nf)
            iNeighbor = [(cc-nf):(cc-1),(cc+1):(cc+nf)];
        elseif cc<=nf
            iNeighbor = [1:(cc-1),(cc+1):(cc+nf)];
        else
            iNeighbor = [(cc-nf):(cc-1),(cc+1):nframe];
        end
        cellPoints(:,6) = cc*ones(size(cellPoints,1),1);
        pointsTemp = [];
        for k = 1:length(iNeighbor)
            NeighborTemp = pwAll{iNeighbor(k)};
            NeighborTemp(:,6) = iNeighbor(k)*ones(size(iNeighbor,1),1);
            pointsTemp = [pointsTemp;NeighborTemp];
        end
        if ~isempty(pointsTemp)
            for pp = 1:size(cellPoints,1)
                norm1 = []; norm2 = []; 
                norm1 = pointsTemp-cellPoints(pp,:);
                norm2 = hypot(norm1(:,1),norm1(:,2));
                pwindx = find(norm2<=50);
                pwNeighbor = pointsTemp(pwindx,:);
                if length(pwindx)>=sizeN
                    cellKeep = [cellKeep; cellPoints(pp,:); pwNeighbor];
                end
            end
        end         
    end
end
%%
    pwAllm = cellKeep;
if not(isempty(pwAllm))
    pwAllm = unique(cellKeep,'rows','stable');
    pwAllm = sortrows(pwAllm,6);
end
end