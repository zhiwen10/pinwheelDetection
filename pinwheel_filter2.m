function [pwAllm] = pinwheel_filter2(pwAll,sizeN)
nframe = length(pwAll);
cellAll = [];
for cc = 1:nframe
    cells = pwAll{cc};
    cells(:,6) = cc*ones(size(cells,1),1);
    cellAll = [cellAll; cells];
end
%%
cellKeep = [];
for cc = 1:nframe
    cellPoints = cellAll(cellAll(:,6)==cc,:);
    nf = 3;
    if ~isempty(cellPoints)
        if cc > nf && cc <= (nframe-nf)
            iNeighbor = [(cc-nf):(cc-1),(cc+1):(cc+nf)];
        elseif cc<=nf
            iNeighbor = [1:(cc-1),(cc+1):(cc+nf)];
        else
            iNeighbor = [(cc-nf):(cc-1),(cc+1):nframe];
        end
        [a,b] = ismember(cellAll(:,6),iNeighbor);
        pointsTemp = cellAll(a,:);
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
pwAllm = unique(cellKeep,'rows','stable');
pwAllm = sortrows(pwAllm,6);
end