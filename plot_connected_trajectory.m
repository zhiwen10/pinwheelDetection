%% plot tragectory
nframe = length(pwAll);
[pwAllm] = pinwheel_filter3(pwAll,3);
pointsCluster1 = connectedTrajectory(pwAllm);
%%
figure; 
ax1 = subplot(1,2,1)
for i = 1:length(pointsCluster1)
    pointInteration = pointsCluster1{i};
    plot(pointInteration(:,1),pointInteration(:,2),'k');
    hold on
end
pixSize = 3.45/1000/0.6*3;  % mm / pix
addAllenCtxOutlines(bregma,lambda, 'r', pixSize)
set(gca,'Ydir','reverse')
set(ax1, 'XTickLabel', '', 'YTickLabel', '');
axis image
box off
axis off

%%
clustersXY1 = clustersXY1(find(~cellfun(@isempty,clustersXY1)));
for kk2 = 1:length(clustersXY1)
    cTemp = clustersXY1{kk2};
    cLength(kk2) = max(cTemp)-min(cTemp);
end
clustersXY2 = clustersXY1(cLength>=20);

ax1 = subplot(1,2,2)
h2 = histogram(cLength)
h2.FaceColor = 'k';
xlabel('Temporal length')
ylabel('Counts');
xlim([0 30]);
ylim([0 900]);