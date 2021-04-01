%% group clusters by frame number; 
% if points are more than 5 frames apart, then they belong to different
% cluster
function pointsCluster1 = connectedTrajectory(pwAllm)
[~,~,clustersXY1] = clusterXYpoints(pwAllm(:,6),3,[],'point','merge');
ncluster = length(clustersXY1);
%%
frameStamp = {};
for k = 1:ncluster
    clusterTemp = clustersXY1{k};
    frameTemp = unique(clusterTemp);
    frameStamp{k} = frameTemp;
    [a1,b1] = ismember(pwAllm(:,6),frameTemp);
    pointsTemp = pwAllm(a1,:);
    [~,~,pointsCluster{k}] = clusterXYpoints(pointsTemp(:,1:2),50,[],'geometric median','merge');
end
    
%%
pointsCluster1 = cat(1,pointsCluster{:});
for kk = 1:length(pointsCluster1)
    pTemp = pointsCluster1{kk};
    if size(pTemp,1)<3
        pointsCluster1{kk} = [];
    end
end
pointsCluster1 = pointsCluster1(~cellfun('isempty',pointsCluster1));
%%
% figure; 
% for i = 1:length(pointsCluster1)
% % for i = 1:50
%     pointInteration = pointsCluster1{i};
%     plot(pointInteration(:,1),pointInteration(:,2),'k');
%     hold on
% end
% addAllenCtxOutlines(bregma,lambda, 'r', pixSize)
% set(gca,'Ydir','reverse')
end