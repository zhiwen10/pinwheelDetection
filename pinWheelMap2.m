%%
nframe = length(pwAll);
for k = 1:nframe
    clear indx
    fTemp  = pwAll{k};
    if not(isempty(fTemp))
        indx = find((fTemp(:,4)-fTemp(:,3))<=15);
        fTemp(indx,:) = [];
        pwAll{k} = fTemp;
    end
end
%%
figure;
ax1 = subplot(2,3,1)
im = imagesc(signMap);
set(im, 'AlphaData', mimg, 'AlphaDataMapping', 'scaled');
set(ax1, 'Color', 'k');
% im = imagesc(mimg);
xlim([0 512])
ylim([0 512])
set(ax1, 'XTickLabel', '', 'YTickLabel', '');
axis image
box off
axis off
colormap(ax1,parula)
% colormap(ax1,colormap_RedWhiteBlue)
% ZYE12
% bregma = [243.7749  236.2895];
% lambda = [508.7573  234.7924];
% ZYE16
bregma = [227.3070  239.3940];
lambda = [505.7632  240.5737];
pixSize = 3.45/1000/0.6*3;  % mm / pix
addAllenCtxOutlines(bregma,lambda, 'k', pixSize)
title('Receptive Field Map')
sizeAll = [2,3,4,5,6];
for i = 1:5
    %%
    clear pwAllm pwAllm1 pwAllm2
    sizeN = sizeAll(i);
    [pwAllm] = pinwheel_filter3(pwAll,sizeN);
    %%
%     pointsCluster1 = connectedTrajectory(pwAllm);
%     pwAllm1 = cat(1,pointsCluster1{:});
    %%
    pwFilter{i} = pwAllm;
%     pwFilter1{i} = pwAllm1;
    pwAllm2 = pwAllm(:,1:2) + normrnd(0,5,[size(pwAllm,1),2]);
    %%
    ax3{i} = subplot(2,3,i+1)
    scatter_kde(pwAllm2(:,1),pwAllm2(:,2),'filled', 'MarkerSize', 5)
    set(gca,'Ydir','reverse')
    xlim([0 512])
    ylim([0 512])
    set(ax3{i}, 'XTickLabel', '', 'YTickLabel', '');
    axis off
    axis image
    box off
    colormap(ax3{i},parula)
    % colormap(ax3,flipud(cbrewer('div','Spectral',40)))
    addAllenCtxOutlines(bregma,lambda, 'k', pixSize)
    %colorbar
    title(['PW neighbour ' num2str(sizeAll(i)) 'of 6'])
end
%%
savefig('PinWheelCenterWithOutline')
saveas(gcf,'PinWheelCenterWithOutline.jpg')
