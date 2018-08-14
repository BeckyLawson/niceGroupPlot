
%% if no data entered, generate some for an example plot
function [data, cond] = generatedata(numpts)

numpts=250;
rand_w = randn(numpts ,1);
rand_x = 2+randn(numpts ,1);
rand_y = -0.4+2*randn(numpts ,1);
rand_z= -4+randn(numpts,1);
data{1}= [rand_w;rand_x; rand_y ; rand_z];
data{2} = [rand_x+0.5; rand_y+3 ;rand_z+0.5;rand_x-4;];



conds(1:numpts,1)=1;
conds(numpts+1:numpts+numpts,1)=2;
conds(numpts+numpts+1:numpts+numpts+numpts,1)=3;
conds(numpts+numpts+numpts+1:numpts+numpts+numpts+numpts,1)=4;
cond{1}=conds;
cond{2}=conds;

end