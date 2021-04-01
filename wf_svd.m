% add path for dependencies 
githubDir = 'C:\Users\Steinmetz lab\Documents\git';

addpath(genpath(fullfile(githubDir, 'widefield'))) % cortex-lab/widefield
addpath(genpath(fullfile(githubDir, 'Pipelines')))
addpath(genpath(fullfile(githubDir, 'wheelAnalysis'))) % cortex-lab/wheelAnalysis
addpath(genpath(fullfile(githubDir, 'spikes')))

%%
serverRoot = expPath(mn, td, en);
%%
%plot PCA components and traces for blue and purple channels
corrPath = fullfile(serverRoot, 'corr', 'svdTemporalComponents_corr.npy');
if ~exist(corrPath, 'file')
    colors = {'blue', 'violet'};
    computeWidefieldTimestamps(serverRoot, colors); % preprocess video
    nSV = 200;
    [U, V, t, mimg] = hemoCorrect(serverRoot, nSV); % process hemodynamic correction
else
    nSV = 200;
    [U, V, t, mimg] = loadUVt(serverRoot, nSV);
end
if length(t) > size(V,2)
  %t = t(1:end-1);
  t = t(1:size(V,2));
end
%%
pixelCorrelationViewerSVD(U,V)
dV = [zeros(size(V,1),1) diff(V,[],2)];
ddV = [zeros(size(dV,1),1) diff(dV,[],2)];