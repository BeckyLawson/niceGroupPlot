# niceGroupPlot
% Background 
This plotting function is useful for people who tend to run experiments 
with two groups of participants and multiple conditions. I was going to 
call it GroupByConditionPlot, but niceGroupPlot has a better ring to it.
In reality, it is just a function to implement a split violin plot using 
violinPlot.m from the great Ann Urai 
(https://anneurai.net/2016/06/13/prettier-plots-in-matlab/),
and also notBoxPlot.m by the ever brilliant Rob Campbell 
(https://uk.mathworks.com/matlabcentral/fileexchange/26508-notboxplot). 
Split violin plot smooths a histogram of the data to show the
distrubution of the datapoints. notBoxPlot plots the mean, 
95% SEM and SD to show summary statistics. You may also choose to scatter 
the raw data on top of this.
             
Both Ann and Rob selflessly shared their plotting code for others to use 
and edit; I just mashed it together into a function with 
inputs for all the things I usually want to change or add to a plot when 
running clinical studies with two groups. Feel free to use, take, edit 
and make your own!
