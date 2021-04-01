%% first use big radius=20 to find potential points 'pwAll'
function wheelsAll = spiralAlg(tracePhase)
%%
totalframes = size(tracePhase,1);
wheelsAll = [];
startframe = 1;
for frame = startframe:totalframes
    A = squeeze(tracePhase(frame,:,:));
    th = 1:6:360; 
    rs = 15:5:30;
    gridsize = 15;
    [xx,yy] = meshgrid(max(rs)+1:gridsize:size(A,1)-max(rs)-1, max(rs)+1:gridsize:size(A,2)-max(rs)-1);
    pwAlla = [];
    for rn = 1:numel(rs)
        for idx = 1:numel(xx)    
            px = xx(idx); py = yy(idx);
            r = rs(rn);
            [pw,pwsign] = checkpw(A,px,py,r);
            pwAlla = [pwAlla;pw];
        end
    end
    pwAlla = unique(pwAlla,'rows');
    %% find center point of all potential points
    % cluster potential points automatically
    % pinwheel center is closest to the previous points where a smallest circle of phase gradient is found
    % if multiple of points are found in a cluster, center is the mean of all points
    [~,~,clustersXY] = clusterXYpoints(pwAlla,50,[],'geometric median','merge');
    ncluster = length(clustersXY);   
    mpoint = [];
    for nn =  1:ncluster
        allpoints = clustersXY{nn};
        mpoint(nn,:) = findcenterpoint(A,allpoints);
    end 
    %% identify pinwheel footprint radius and sign
    if ~isempty(mpoint)
        for kk = 1:size(mpoint,1)
            num1 = 1;
            for rs1 = 5:5:50
                px3 = mpoint(kk,1); py3 = mpoint(kk,2); r3 = rs1;
                [pw,pwsign] = checkpw(A,px3,py3,r3);
                if isempty(pwsign)
                    r3 = nan;
                    pwsign = nan;
                end
                pwRadius(num1) = r3;
                pwSign(num1) = pwsign;
                num1 = num1+1;
            end
            mpoint(kk,3) = min(pwRadius); mpoint(kk,4) = max(pwRadius); 
            if not(all(isnan(pwSign))) && all(pwSign)
                mpoint(kk,5) = 1;
            elseif not(all(isnan(pwSign))) && not(any(pwSign))
                mpoint(kk,5) = 0;
            else
                mpoint(kk,5) = nan;
            end
        end
        mpoint(isnan(mpoint(:,5)),:) = [];
        filter = mpoint(:,4)-mpoint(:,3);
        mpoint(find(filter <=5),:) = [];
    end
    wheelsAll{frame} = mpoint;
end
% id = find(~cellfun(@isempty,wheelsAll));
wheelsAll1 = cat(1,wheelsAll{:});
% ncell = length(wheelsAll);
% for cc = 1:ncell
%     cellPoints = wheelsAll{cc};
%     cellTemp = {};
%     nf = 3;
%     if ~isempty(cellPoints)
%         if cc > nf && cc <= (ncell-nf)
%             cellTemp = wheelsAll([(cc-nf):(cc-1),(cc+1):(cc+nf)]);
%         elseif cc<=nf
%             cellTemp = wheelsAll([1:(cc-1),(cc+1):(cc+nf)]);
%         else
%             cellTemp = wheelsAll([(cc-nf):(cc-1),(cc+1):ncell]);
%         end
%         pointsTemp = cat(1,cellTemp{:});
%         if ~isempty(pointsTemp)
%             ppkeep = [];
%             for pp = 1:size(cellPoints,1)
%                 norm1 = []; norm2 = []; 
%                 norm1 = pointsTemp-cellPoints(pp,:);
%                 norm2 = hypot(norm1(:,1),norm1(:,2));
%                 pwindx = find(norm2<=30);
%                 if length(pwindx)>=3
%                     ppkeep = [ppkeep;pp];
%                 end
%             end
%             cellPoints = cellPoints(ppkeep,:);
%         else 
%             cellPoints = [];
%         end
%     else cellPoints = [];           
%     end
%     wheelsAllm{cc} = cellPoints;   
% end
% wheelsAllm1 = cat(1,wheelsAllm{:});
end

% figure; 
% imagesc(squeeze(tracePhase1(id(3),:,:)));
% colormap(hsv); 
% axis image; axis off;
% hold on;
% scatter(wheelsAllm1(:,1),wheelsAllm1(:,2),30,'k','filled');
% saveas(gcf,[foldername 'm.tiff']);
% save(foldername,'wheelsAllm','wheelsAllm1');
 
