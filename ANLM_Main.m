%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File       : The main program of the ANLM filter 
% Authors    : Shen Peng;
% Creation   : 2018/07/11
% Update     : 2018/07/22
% Description: An Adaptive Nonlocal Mean Filter for PolSAR Data with
% Shape-Adaptive Patches Matching. The filtering method is descripted
% on the Sensors website in detail: http://www.mdpi.com/1424-8220/18/7/2215
% Reference  : Shen, P.; Wang, C.; Gao, H.; Zhu, J.	An Adaptive Nonlocal Mean Filter for PolSAR Data with Shape-Adaptive Patches Matching. Sensors 2018, 18, 2215.
% If the code of the ANLM filter is used, please cite the above references.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('T3Simulated.mat');
load('T3Real.mat');

%%
HomoArea1=20:50;
HomoArea2=110:140;
patch_radius=2;
Search_radius=[1 3 5 7];
NHP=[5 9 13 17];
h=[0.01 0.99];
Nh=4;
QuickFilter=0;

%% If you want to quick the progress, please select the following parameter setting.
% patch_radius=2;
% Search_radius=[3 5 7];
% NHP=[5 9 13];
% h=[0.01 0.99];
% Nh=4;
% QuickFilter=1;

%%
[T3ANLM_filtered,MaxENLANLM_filtered,oriENL]=Batch_T3_filter_ANLM(T3Simulated,HomoArea1,HomoArea2,patch_radius,Search_radius,NHP,h,Nh,QuickFilter);

%%
% Show SPAN
figure;
subplot(2,3,1);imagesc_T3SPAN(T3Real,0,400,'jet','T3Real-SPAN');set(gca,'xtick',[]);set(gca,'ytick',[])
subplot(2,3,2);imagesc_T3SPAN(T3Simulated,0,400,'jet','T3Simulated-SPAN');set(gca,'xtick',[]);set(gca,'ytick',[])
subplot(2,3,3);imagesc_T3SPAN(T3ANLM_filtered,0,400,'jet','T3ANLM-SPAN');set(gca,'xtick',[]);set(gca,'ytick',[])

% Show ENL
subplot(2,3,4);imagesc(MaxENLANLM_filtered);caxis([0 100]);colormap('jet');title('ENL-ANLM');axis image;set(gca,'xtick',[]);set(gca,'ytick',[])

% Calcilate the RMSE
[~,~,row,col]=size(T3Simulated);
RMSE1=zeros(row,col);
RMSE2=zeros(row,col);
for i=1:row
    for j=1:col
        
        RMSE1(i,j)=norm(T3Simulated(:,:,i,j)-T3Real(:,:,i,j),'fro');
        RMSE2(i,j)=norm(T3ANLM_filtered(:,:,i,j)-T3Real(:,:,i,j),'fro');
    end
end
TestArea_RMSE1=sqrt(RMSE1/(3*3));
TestArea_RMSE2=sqrt(RMSE2/(3*3));
subplot(2,3,5);imagesc(TestArea_RMSE1);caxis([0 5]);colormap('jet');title('RMSE-Simulated-Real');axis image;set(gca,'xtick',[]);set(gca,'ytick',[])
subplot(2,3,6);imagesc(TestArea_RMSE2);caxis([0 5]);colormap('jet');title('RMSE-ANLM-Real');axis image;set(gca,'xtick',[]);set(gca,'ytick',[])
linkaxes;