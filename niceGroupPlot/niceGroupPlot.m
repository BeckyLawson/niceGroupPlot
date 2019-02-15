function a = niceGroupPlot(data, cond, varargin)
% Written by Rebecca Lawson, May 2016.
% Edited by Rebecca Lawson, Aug 2018.
% This code relies on additional functions (included in the 'EssentialCode'
% folder. Please add to path).
% This code is not supported, but has been tested on Matlab 2018a.

%% Background 
% This plotting function is useful for people who tend to run experiments 
% with two groups of participants and multiple conditions. I was going to 
% call it GroupByConditionPlot, but niceGroupPlot has a better ring to it.
% In reality, it is just a function to implement a split violin plot using 
% violinPlot.m from the great Ann Urai 
% (https://anneurai.net/2016/06/13/prettier-plots-in-matlab/),
% and also notBoxPlot.m by the ever brilliant Rob Campbell 
% (https://uk.mathworks.com/matlabcentral/fileexchange/26508-notboxplot). 
% Split violin plot smooths a histogram of the data to show the
% distrubution of the datapoints. notBoxPlot plots the mean, 
% 95% SEM and SD to show summary statistics. You may also choose to scatter 
% the raw data on top of this.
%              
% Both Ann and Rob selflessly shared their plotting code for others to use 
% and edit; I just mashed it together into a function with 
% inputs for all the things I usually want to change or add to a plot when 
% running clinical studies with two groups. Feel free to use, take, edit 
% and make your own!

%% niceGroupPlot Function info
% - Required Inputs -
% data - a 1x2 cell array that contains the data for the two groups of ppts.  
%        data{1} holds the data to be plotted for group 1 and should be a
%        1xn double, where the length of n is equal to the number of
%        participants in group 1 x the number of conditions.
%        e.g. if you have 20 ppts in each group and 3 conditions then data {1} 
%        would be a cell array that contains a 60 x 1 double. data{2} is the
%        same for group 2, but may be a different length if the two groups
%        contained different numbers of ppts.
% cond - a 1x2 cell aray that contains the condition labels for each entry in 
%        the data cell array (e.g. 1, 2, 3 etc) for each entry in data.
%        Should handle 1 to n conditions. 

% > See the example 'data' and 'cond' variables to see how to set up these
%   inputs for yourself.

% - optional inputs -
% 'dotsize' - a number from 0.001 to n, indicating how large to make the dots
%             in the boxplot. If you're plotting thousands of datapoints make 
%             the dotsize smaller (e.g. 1). Set to a really small value 
%             (e.g. 0.001) if you don't want to see the raw data at all.
% 'col1' -    the colour to plot group 1 in. An integer from 1 to 8. Indexes
%             the rows in the 'color brewer' colourmap (set on line 97 below) 
%             Default = 1 (pink). Check out colourmap.tif in the main script 
%             folder to see the colour options.
% 'col2' -    the colour to plot group 2 in. An integer from 1 to 8. Indexes
%             the rows in the 'color brewer' colourmap. Choose a different 
%             colour from group 1. Default = 2 (green)
% 'gplab' -   a cell array with the names of your two groups (e.g. {'ASD', 'NT'}.
%             Defaults to to 'group 1' and 'group 2'.
% 'condlab' - a cell array with the names of your conditions (e.g. {'Pre', 'Post'}.
%             Should have as many entries as there are unique elements of 'cond'. 
%             i.e. if you have three conditions, please supply three
%             condition labels. Defaults to 'cond 1 - n' if no labels are
%             supplied.
% 'transp' -  The transparency applied to all the colour patches in the
%             plot. An integer from 0 (no colour) to 1 (full colour).
%             Defaults to 1.
% 'whatplot'- 1 = both splitViolin AND notBoxPlot,2 = just splitViolin, 
%             3 = just notBoxPlot. Defaults to 1. 
% 'fitline' - Do you want to add a linear trend line across the conditions
%             for each group? Set to '1' for yes and 0 leave blank for 'no'.
%             Defaults to 0. Only an option where 
%             'whatplot' = 1 or 3 (i.e. where there is a boxplot)

%% defaults if no input passed to function
d.dotsize=1;
for c=1:length(unique(cell2mat(cond(1))));
d.condlab(1,c)={['cond ' num2str(c)]};
end
d.gplab={'group 1', 'group 2'};
d.col1=1;
d.col2=2;
d.alpha=1;
d.whatplot=1;
d.fitline=0;

%% parse the inputs to the function
p = inputParser;
validScalarPosNum = @(x) isnumeric(x);
addRequired(p,'data',@iscell);
addRequired(p,'cond',@iscell);
addOptional(p,'dotsize',d.dotsize, validScalarPosNum);
addParameter(p,'condlab',d.condlab,@iscell);
addParameter(p,'gplab',d.gplab,@iscell);
addOptional(p,'col1',d.col1,validScalarPosNum);                                                                
addOptional(p,'col2',d.col2,validScalarPosNum);
addOptional(p,'transp',d.alpha,validScalarPosNum);
addOptional(p,'whatplot',d.whatplot,validScalarPosNum);
addOptional(p,'fitline',d.fitline, @(n)validateattributes(n,{'numeric'},{'nonnegative'}));
parse(p,data,cond,varargin{:});    

%% make the colours nice
colors = cbrewer('qual', 'Set2', 8);

%% notBoxPlot and splitViolinPlot together
%%
if p.Results.whatplot==1   
% plot the half violin(s)

% for group 1
violinPlot(p.Results.data{1}, 'histOri', 'left', 'widthDiv', [2 1], 'showMM', 0, ...
'color',  mat2cell(colors(p.Results.col1, : ), 1), 'xValues', unique(cell2mat(cond(1)))-0.2, 'groups', p.Results.cond{1})
% for group 2
violinPlot(p.Results.data{2}, 'histOri', 'right', 'widthDiv', [2 1], 'showMM', 0, ...
'color',  mat2cell(colors(p.Results.col2, : ), 1), 'xValues', unique(cell2mat(cond(2)))+0.3, 'groups', p.Results.cond{2})
hold on

%% plot the notBoxPlot(s) (box and scatter)
condL=cond{1}-0.1;
condR=cond{2}+0.1;
% for group 1
H=notBoxPlot(p.Results.data{1},condL,'jitter',0.11, 'style', 'patch');
set([H.data],...
    'MarkerFaceColor',colors(p.Results.col1, : ),... 
    'markerEdgeColor',colors(p.Results.col1, : ),...
    'MarkerSize',p.Results.dotsize);

% change the overall alpha
alpha(p.Results.transp); 

set([H.semPtch], 'FaceColor',[1,1,1]);
set([H.semPtch], 'EdgeColor', [0,0,0]);
set([H.semPtch], 'FaceAlpha',0);
set([H.sdPtch], 'FaceColor',[1,1,1]);
set([H.sdPtch], 'FaceAlpha',0);
set([H.sdPtch], 'EdgeColor', [0,0,0]);
set([H.mu], 'Color', [0 0 0]);

% for group 2
H2=notBoxPlot(p.Results.data{2},condR,'jitter',0.11, 'style', 'patch');
set([H2.data],...
    'MarkerFaceColor',colors(p.Results.col2, : ),...
    'markerEdgeColor',colors(p.Results.col2, : ),...
    'MarkerSize',p.Results.dotsize);

set([H2.semPtch], 'FaceColor',[1,1,1]);
set([H2.semPtch], 'EdgeColor', [0,0,0]);
set([H2.semPtch], 'FaceAlpha',0);
set([H2.sdPtch], 'FaceColor',[1,1,1]);
set([H2.sdPtch], 'FaceAlpha',0);
set([H2.sdPtch], 'EdgeColor', [0,0,0]);
set([H2.mu], 'Color', [0,0,0]);
end

%% Just splitViolinPlot
%%
if p.Results.whatplot==2
% plot the half violin(s)
%figure;
% for group 1
violinPlot(p.Results.data{1}, 'histOri', 'left', 'widthDiv', [2 1], 'showMM', 0, ...
'color',  mat2cell(colors(p.Results.col1, : ), 1), 'xValues', unique(cell2mat(cond(1)))-0.05, 'groups', p.Results.cond{1})
% for group 2
violinPlot(p.Results.data{2}, 'histOri', 'right', 'widthDiv', [2 1], 'showMM', 0, ...
'color',  mat2cell(colors(p.Results.col2, : ), 1), 'xValues', unique(cell2mat(cond(2)))+0.1, 'groups', p.Results.cond{2})
hold on

% change the overall alpha
alpha(p.Results.transp); 

end

%% Just notBoxPlot
%%
if p.Results.whatplot==3
%figure;
condL=cond{1}-0.1;
condR=cond{2}+0.1;
% for group 1
H=notBoxPlot(p.Results.data{1},condL,'jitter',0.1, 'style', 'patch');
set([H.data],...
    'MarkerFaceColor',colors(p.Results.col1, : ),... 
    'markerEdgeColor',colors(p.Results.col1, : ),...
    'MarkerSize',p.Results.dotsize);

% change the overall alpha
alpha(p.Results.transp); 

set([H.semPtch], 'FaceColor',[1,1,1]);
set([H.semPtch], 'EdgeColor', [0,0,0]);
set([H.semPtch], 'FaceAlpha',0);
set([H.sdPtch], 'FaceColor',[1,1,1]);
set([H.sdPtch], 'FaceAlpha',0);
set([H.sdPtch], 'EdgeColor', [0,0,0]);
set([H.mu], 'Color', [0 0 0]);

% for group 2
H2=notBoxPlot(p.Results.data{2},condR,'jitter',0.1, 'style', 'patch');
set([H2.data],...
    'MarkerFaceColor',colors(p.Results.col2, : ),...
    'markerEdgeColor',colors(p.Results.col2, : ),...
    'MarkerSize',p.Results.dotsize);

set([H2.semPtch], 'FaceColor',[1,1,1]);
set([H2.semPtch], 'EdgeColor', [0,0,0]);
set([H2.semPtch], 'FaceAlpha',0);
set([H2.sdPtch], 'FaceColor',[1,1,1]);
set([H2.sdPtch], 'FaceAlpha',0);
set([H2.sdPtch], 'EdgeColor', [0,0,0]);
set([H2.mu], 'Color', [0,0,0]);

end

%% Tidy up the axes
set(gca,'xlim', [0.5 max(cond{1})+0.5],'xtick', unique(p.Results.cond{1}), 'xticklabel', p.Results.condlab);

%% make a legend for the two groups with the correct colours.

a(1) = patch(NaN, NaN, colors(p.Results.col1,:), 'FaceAlpha', p.Results.transp);
a(2) = patch(NaN, NaN, colors(p.Results.col2,:), 'FaceAlpha', p.Results.transp);

legend(a, p.Results.gplab, 'Location', 'best');
legend('boxoff')

%% Set the figure background to white
set(gcf,'color','w');

%% Add a linear trend line if requested

if p.Results.fitline==1 && p.Results.whatplot==2
  
 warning('You cannot fit a line without a box plot. Change the plot type to 1 or 3 and try again');
else if p.Results.fitline==1   
%% get the means for each condition to fit the line
 x=get([H.mu],'XData'); y=get([H.mu],'YData');
 x2=get([H2.mu],'XData'); y=get([H2.mu],'YData');
 
 Xa=unique (cond{1}); Xc=unique (cond{2});
 Ya=accumarray(cond{1},data{1}(:,1),[],@mean); Yc=accumarray(cond{2},data{2}(:,1),[],@mean);
 
 %% fit and plot Group 1 line
 P = polyfit(Xa,Ya,1); 
 x2=0.1:7.9;
 yfit = P(1)*x2+P(2);
 hold on;
 plot(x2,yfit,'col', colors(p.Results.col1,1:3),'LineWidth',1.5,'LineStyle', '-.');
 
 
%% fit and plot Group 2 line
P = polyfit(Xc,Yc,1); 
x2=0.1:7.9;
yfit = P(1)*x2+P(2);
hold on;
plot(x2,yfit,'col',colors(p.Results.col2,1:3),'LineWidth',1.5,'LineStyle', '-.');

legend(a, p.Results.gplab, 'Location', 'best');
legend('boxoff')

end

end







