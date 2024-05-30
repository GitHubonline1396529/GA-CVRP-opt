%% ͨ���Ŵ��㷨��� CVRP ����
% ʾ���ű����ýű�������ʹ�� GA_VRP_optimize ��������ʾ������

%% ��������
% CVRP ���⣬�������������Ƶĳ���·�����⣨Capacity Vehicle Routing Problem����
% �����������������е�һ�������Ż����⡣��Ŀ����ȷ��һ�鳵����һ���������ĳ�������
% ��һϵ�пͻ��ڵ㲢�����������ĵ� ����·���������������Ŀ�������������пͻ�����
% �ͳ��������������Ƶ�ͬʱ����С������ʻ������ܳɱ���

%% ��������
% ����ն����ݣ���ձ����ռ䣻�ر����д���

clc; clear; close all;
%% ��ʼ������
% ����ͨ������������ɣ��������� MATLAB �����ĵ������¼���ַΪ��
% 
% Capacitated Vehicle Routing Problem
% https://www.mathworks.com/help/matlab/math/quantum-capacitated-vehicle-ro
% uting.html 

%% ��������
% ����Ĵ��������������

% Capacitated Vehicle Routing Problem
rng(1) % For reproducibility
numCustomers = 24; % Depot at [0 0] makes 25 locations
depot = [0 0]; % Depot at the origin
loc = [depot; randi([-50, 50],numCustomers,2)]; 
% Integers from -50 to 50, 24-by-2
demands = 100*randi([1, 25],numCustomers,1);
capacity = 6000;

%% ���ӻ���������
% ʹ������Ĵ��룬���Զ����ɵ����ݽ��п��ӻ�������ɢ��ͼ�����У�Depot Ϊ����ֿ��
% λ�ã�λ������ (0, 0) �㡣

% Plot the locations with demands overlaid
% figure;
scatter(loc(:,1),loc(:,2),'filled','SizeData',25);
text(loc(:,1),loc(:,2),["Depot"; num2str((1:numCustomers)')]);
title("Customer Locations and Demands");
hold off;

%% ��ʼ������
% �������ɾ������
% OD_mat = squareform(pdist(loc));

% ����һЩ�˵ĵ��������û��ͳ�������ѧϰ�����䣬pdist �����п����޷�ʹ��
% ����Ĵ���Ҳ���Ի�ȡԭ����ľ������
Dis_mat = zeros(numCustomers, numCustomers);
for i = 1:numCustomers+1
    for j = 1:numCustomers+1
        Dis_mat(i, j) = sqrt(sum((loc(i, :) - loc(j, :)).^2));
    end
end

% Ȼ�����ø�����������
popSize = 3000; % ��Ⱥ����
numVehicles = 5; % ���õĳ�����
maxIter = 1000; % ���Ƶ�����������
pc = 0.9; % �������
pm = 0.09; % �������

%% ����������������
% �������Ϊ���� 100% ���ֹ����Ĵ��졣Ϊ�˱�֤�����ԣ�MATLAB �ն����л�����֮���
% �ܳ����������룩����ʾ��Ϣʹ����Ӣ�ġ�
% 
% Ϊ�˼�����Ľ�ģ�������������ݱ������ʽ�����뷽ʽ�ο��˲��ͣ�
% 
% ���Ŵ��㷨���VRP����
% https://blog.csdn.net/panbaoran913/article/details/128250015 
% 
% �㷨�����˾�Ӣ���ԣ����桢��¼�ͷ��������е��Ӣ���弰����Ӧ�ȡ�ͬʱ�����桢��
% ����̲����˴�Լ���Ľ��������ԣ�����������������µĸ����޷�����ģ��Լ����Ҫ
% ���򽻲桢���콫���ᷢ���������㷨�޷�ȷ���ҵ�ȫ�����Ž⣬������β��ԣ������
% ��һЩ������ܹ�ȡ�õ���С·������Ϊ 732.00���ý������Ϊ ./data/solution.mat 
% �ļ���

[bestIndividual, minCost, iterPop, fitnessVales] = GA_CVRP_optimize( ...
    Dis_mat, numVehicles, demands, capacity, ...
    popSize, maxIter, pc, pm, true);

%% ���ӻ����
% ��������ܹ���ȡ�Ż��Ľ����������ͼ���ò�ͬ��ɫ���ƿ�������ʻ·����

plot_route(loc, bestIndividual)
