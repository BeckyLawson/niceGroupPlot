# niceGroupPlot
% Written by Rebecca Lawson, May 2016.
% Edited by Rebecca Lawson, Aug 2018.
% This code relies on additional functions (included in the 'EssentialCode'
% folder. Please add to path).
% This code is not supported, but has been tested on Matlab 2018a.

Background 
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
