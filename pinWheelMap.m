figure;
ax1 = subplot(2,3,1)
im = imagesc(signMap);
set(im, 'AlphaData', mimg, 'AlphaDataMapping', 'scaled');
set(ax1, 'Color', 'k');
xlim([0 512])
ylim([0 512])
set(ax1, 'XTickLabel', '', 'YTickLabel', '');
axis image
box off
colormap(ax1,colormap_RedWhiteBlue)
bregma = [243.7749  236.2895];
lambda = [508.7573  234.7924];
addAllenCtxOutlines(bregma,lambda, 'r', pixSize)
title('Receptive Field Map')
%%
[pwAllm] = pinwheel_filter(pwAll,1);
pwAllm1 = cat(1,pwAllm{:});

minus1 = pwAllm1(:,4)-pwAllm1(:,3);
index1 = find(minus1>=10);
pwAllm1 = pwAllm1(index1,:);

pwAllm2 = pwAllm1;
ra = normrnd(0,5,[size(pwAllm2,1),2]);
pwAllm2(:,1:2) = pwAllm2(:,1:2)+ra;
%%
ax2 = subplot(2,3,2)
% imagesc(signMap);
% hold on
scatter_kde(pwAllm2(:,1),pwAllm2(:,2),'filled', 'MarkerSize', 5')
set(gca,'Ydir','reverse')
xlim([0 512])
ylim([0 512])
set(ax2, 'XTickLabel', '', 'YTickLabel', '');
axis off
axis image
box off
colormap(ax2,parula)
% colormap(ax2,flipud(cbrewer('div','Spectral',40)))
addAllenCtxOutlines(bregma,lambda, 'k', pixSize)
% colorbar
title('All PW center')
%%
indx = (pwAllm2(:,4)>=50);
pwAllm3 = pwAllm2(indx,:);
ax2 = subplot(2,3,3)
scatter_kde(pwAllm3(:,1),pwAllm3(:,2),'filled', 'MarkerSize', 5')
set(gca,'Ydir','reverse')
xlim([0 512])
ylim([0 512])
set(ax2, 'XTickLabel', '', 'YTickLabel', '');
axis off
axis image
box off
colormap(ax2,parula)
% colormap(ax2,flipud(cbrewer('div','Spectral',40)))
addAllenCtxOutlines(bregma,lambda, 'k', pixSize)
% colorbar
title('PW footprint >= 50pixels')
%%
sizeAll = [4,5,6];
for i = 1:3
    clear pwAllm1 pwAllm2
    sizeN = sizeAll(i);
    [pwAllm] = pinwheel_filter(pwAll,sizeN);
    pwAllm1 = cat(1,pwAllm{:});
    %%
    minus1 = pwAllm1(:,4)-pwAllm1(:,3);
    index1 = find(minus1>=10);
    pwAllm1 = pwAllm1(index1,:);
%%
    ra = normrnd(0,5,[size(pwAllm1,1),2]);
    pwAllm2 = pwAllm1(:,1:2)+ra;
    ax3 = subplot(2,3,i+3)
    scatter_kde(pwAllm2(:,1),pwAllm2(:,2),'filled', 'MarkerSize', 5)
    set(gca,'Ydir','reverse')
    xlim([0 512])
    ylim([0 512])
    set(ax3, 'XTickLabel', '', 'YTickLabel', '');
    axis off
    axis image
    box off
    colormap(ax3,parula)
    % colormap(ax3,flipud(cbrewer('div','Spectral',40)))
    addAllenCtxOutlines(bregma,lambda, 'k', pixSize)
%     colorbar
    title(['PW neighbour ' num2str(sizeAll(i)) 'of 6'])
end
savefig('PinWheelCenterWithOutline')
saveas(gcf,'PinWheelCenterWithOutline.png')
