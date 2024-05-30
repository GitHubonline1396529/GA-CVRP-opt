%% 通过遗传算法解决 CVRP 问题
% 示例脚本，该脚本包含了使用 GA_VRP_optimize 求解问题的示例代码

%% 问题描述
% CVRP 问题，即包含容量限制的车辆路径问题（Capacity Vehicle Routing Problem），
% 是物流和运输领域中的一个经典优化问题。其目标是确定一组车辆从一个配送中心出发，访
% 问一系列客户节点并返回配送中心的 最优路径方案。该问题的目的是在满足所有客户需求
% 和车辆运载能力限制的同时，最小化总行驶距离或总成本。

%% 清理工作区
% 清空终端内容；清空变量空间；关闭所有窗口

clc; clear; close all;
%% 初始化算例
% 算例通过随机数字生成，代码来自 MATLAB 官网文档。文章及网址为：
% 
% Capacitated Vehicle Routing Problem
% https://www.mathworks.com/help/matlab/math/quantum-capacitated-vehicle-ro
% uting.html 

%% 算例生成
% 下面的代码可以生成算例

% Capacitated Vehicle Routing Problem
rng(1) % For reproducibility
numCustomers = 24; % Depot at [0 0] makes 25 locations
depot = [0 0]; % Depot at the origin
loc = [depot; randi([-50, 50],numCustomers,2)]; 
% Integers from -50 to 50, 24-by-2
demands = 100*randi([1, 25],numCustomers,1);
capacity = 6000;

%% 可视化算例数据
% 使用下面的代码，可以对生成的数据进行可视化，绘制散点图。其中，Depot 为中央仓库的
% 位置，位于坐标 (0, 0) 点。

% Plot the locations with demands overlaid
% figure;
scatter(loc(:,1),loc(:,2),'filled','SizeData',25);
text(loc(:,1),loc(:,2),["Depot"; num2str((1:numCustomers)')]);
title("Customer Locations and Demands");
hold off;

%% 初始化参数
% 首先生成距离矩阵
% OD_mat = squareform(pdist(loc));

% 鉴于一些人的电脑里可能没有统计与机器学习工具箱，pdist 函数有可能无法使用
% 下面的代码也可以获取原问题的距离矩阵
Dis_mat = zeros(numCustomers, numCustomers);
for i = 1:numCustomers+1
    for j = 1:numCustomers+1
        Dis_mat(i, j) = sqrt(sum((loc(i, :) - loc(j, :)).^2));
    end
end

% 然后设置各项其他参数
popSize = 3000; % 种群个数
numVehicles = 5; % 可用的车辆数
maxIter = 1000; % 限制的最大迭代次数
pc = 0.9; % 交叉概率
pm = 0.09; % 变异概率

%% 调用求解器求解问题
% 此求解器为本人 100% 纯手工匠心打造。为了保证兼容性（MATLAB 终端在切换字体之后可
% 能出现中文乱码），提示信息使用了英文。
% 
% 为了简化问题的建模，采用整型数据编码的形式。编码方式参考了博客：
% 
% 用遗传算法解决VRP问题
% https://blog.csdn.net/panbaoran913/article/details/128250015 
% 
% 算法采用了精英策略，保存、记录和返回历代中的最精英个体及其适应度。同时，交叉、变
% 异过程采用了带约束的交叉变异策略，如果交叉编译产生的新的个体无法满足模型约束的要
% 求，则交叉、变异将不会发生。尽管算法无法确保找到全局最优解，但经多次测试，求解器
% 在一些情况下能够取得的最小路径距离为 732.00。该结果保存为 ./data/solution.mat 
% 文件。

[bestIndividual, minCost, iterPop, fitnessVales] = GA_CVRP_optimize( ...
    Dis_mat, numVehicles, demands, capacity, ...
    popSize, maxIter, pc, pm, true);

%% 可视化结果
% 这个函数能够读取优化的结果，并且在图中用不同颜色绘制卡车的行驶路径。

plot_route(loc, bestIndividual)
