figure;
%%
ax1 = subplot(2,3,1)
cla
im = imagesc(signMap);
set(im, 'AlphaData', mimg, 'AlphaDataMapping', 'scaled');
set(ax1, 'Color', 'k');
xlim([0 512])
ylim([0 512])
set(ax1, 'XTickLabel', '', 'YTickLabel', '');
axis image
box off
axis off
colormap(ax1,colormap_RedWhiteBlue)
bregma = [243.7749  236.2895];
lambda = [508.7573  234.7924];
addAllenCtxOutlines(bregma,lambda, 'k', pixSize)
title('Receptive Field Map')
%%
sizeAll = [2,3,4,5,6];
for i = 1:5
    clear pwAllm pwAllm1 pwAllm2
    sizeN = sizeAll(i);
    [pwAllm1] = pinwheel_filter3(pwAll,sizeN);
    %%
    color1 = zeros(size(pwAllm1,1),3);
    color1(:,1) = pwAllm1(:,5);
    color1(:,2) = double(not(pwAllm1(:,5)));
%%
    ra = normrnd(0,5,[size(pwAllm1,1),2]);
    pwAllm2(:,1:2) = pwAllm1(:,1:2)+ra;
    ax3 = subplot(2,3,i+1)
    scatter(pwAllm2(:,1),pwAllm2(:,2),3, color1,'filled')
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
%%
savefig('PinWheelCenterWithOutline_direction')
saveas(gcf,'PinWheelCenterWithOutline_direction.jpg')