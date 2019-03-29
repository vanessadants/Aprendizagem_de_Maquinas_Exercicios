C1=[0 1 1 1;0 0 0 1;0 0 1 0];
C2=[0 0 0 1;0 1 1 1;1 1 0 1];
C=[C1 C2]';
t=[0 0 0 0 1 1 1 1];
t1=[{0};{0};{0};{0};{1};{1};{1};{1}];
svmStruct=svmtrain(C,t,'showplot','false','kernel_function','rbf',...
'boxconstraint',1,'kktviolationlevel',0.05,'tolkkt',5e-3)
svm_3d_matlab_vis(svmStruct,C,t1)