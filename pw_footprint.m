pw = cat(1,pwAll{:});
radius = pw(:,4)-pw(:,3);
pw1 = pw(find(radius>35),:);
pw1(:,1:2) = pw1(:,1:2)+normrnd(0,3,[size(pw1,1),2]);
%%
figure; 
ax=subplot(1,1,1)
scatter_kde(pw1(:,1),pw1(:,2),'filled', 'MarkerSize', 20)
set(gca,'Ydir','reverse')
xlim([0 512])
ylim([0 512])
set(ax, 'XTickLabel', '', 'YTickLabel', '');
axis off
axis image
box off
colormap(ax,parula)
% colormap(ax3,flipud(cbrewer('div','Spectral',40)))
% ZYE12
bregma = [243.7749  236.2895];
lambda = [508.7573  234.7924];
pixSize = 3.45/1000/0.6*3;  % mm / pix
addAllenCtxOutlines(bregma,lambda, 'k', pixSize)

