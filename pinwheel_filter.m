%% 
% only keep pinwheels, if there are other pinwheels 
% within euclidean distance (30pixels) in the nearby -3:3 frames.
function [pwAllm] = pinwheel_filter(pwAll,sizeN)
nframe = length(pwAll);
for cc = 1:nframe
    cellPoints = pwAll{cc};
    cellTemp = {};
    nf = 3;
    if ~isempty(cellPoints)
        if cc > nf && cc <= (nframe-nf)
            cellTemp = pwAll([(cc-nf):(cc-1),(cc+1):(cc+nf)]);
        elseif cc<=nf
            cellTemp = pwAll([1:(cc-1),(cc+1):(cc+nf)]);
        else
            cellTemp = pwAll([(cc-nf):(cc-1),(cc+1):nframe]);
        end
        pointsTemp = cat(1,cellTemp{:});
        if ~isempty(pointsTemp)
            ppkeep = [];
            for pp = 1:size(cellPoints,1)
                norm1 = []; norm2 = []; 
                norm1 = pointsTemp-cellPoints(pp,:);
                norm2 = hypot(norm1(:,1),norm1(:,2));
                pwindx = find(norm2<=50);
                if length(pwindx)>=sizeN
                    ppkeep = [ppkeep;pp];
                end
            end
            cellPoints = cellPoints(ppkeep,:);
        else 
            cellPoints = [];
        end
    else cellPoints = [];           
    end
    pwAllm{cc} = cellPoints;   
end
%%
% figure; 
% imagesc(squeeze(tracePhase(5,:,:)));
% colormap(hsv); 
% axis image; axis off;
% hold on;
% pwAllm1 = cat(1,pwAllm{:});
% scatter(pwAllm1(:,1),pwAllm1(:,2),20,'k','filled');
% saveas(gcf,[foldername 'm.tiff']);
% save(foldername,'wheelsAllm','wheelsAllm1');
end