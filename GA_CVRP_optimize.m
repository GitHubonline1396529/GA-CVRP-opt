function [bestIndividual, minCost, iterPop, fitnessValues] ...
    = GA_CVRP_optimize( ...
    OD_mat, numVehicles, demands, capacity, ...
    popSize, maxIter, pc, pm, ...
    dynamic_plot ...
    )

% GA_CVRP_OPTIMIZE 针对 CVRP 问题的遗传算法求解器
%    此 MATLAB 函数利用遗传算法优化解决 CVRP 问题，支持动态图实时显示迭代过程的全
%    局最优解搜索下降进度，会在命令行窗口输出提示信息。
% 
%    [bestIndividual, minCost] = GA_CVRP_OPTIMIZE( ...
%             OD_mat, numVehicles, demands, capacity, ...
%             popSize, maxIter, pc, pm)
% 
%    [bestIndividual, minCost, iterPop, fitnessValues] ...
%        = GA_CVRP_OPTIMIZE( ...
%             OD_mat, numVehicles, demands, capacity, ...
%             popSize, maxIter, pc, pm, ...
%             dynamic_plot ...
%     )
%
%    注意事项
%        1. 为了简化问题的建模，采用整型数据编码的形式。
%        2. 算法采用了精英策略，保存、记录和返回历代中的最精英个体及其适应度。
%        3. 交叉、变异过程采用了带约束的交叉编译过程，如果交叉变异产生的新的个体
%           无法满足模型约束的要求，交叉、变异将不会发生。
%        4. 无法确保找到全局最优解。
% 
%    输入参数
%        OD_mat - 所有节点之间的 OD 矩阵。此处要求 OD 矩阵中的第一个节点是 CVRP 
%            问题的配送中心节点，即 Depot 节点。
%        numVehicles - CVRP 问题中运载工具的数量
%        demands - CVRP 问题中各个顾客节点的需求量的一维向量
%        capacity - CVRP 问题中运载工具的容量限制
%        popSize - 遗传算法的种群大小
%        maxIter - 最大迭代次数限制
%        pc - 交叉概率
%        pm - 变异概率
%        dynamic_plot - 一个 Bool 值，表示是否弹窗并动态绘制模型求解的下降过程
% 
%    输出参数
%        bestIndividual - 遗传算法迭代产生的最优精英个体
%        minCost - 遗传算法优化的结果，即 CVRP 问题中汽车最终行驶的总里程数
%        iterPop - 最终次迭代的种群

% 这两行代码允许可变输入，其中 `nargin` 是一个特殊的变量，表示用户输入的参数数目。
% 这里检验当输入参数为 6 也就是不包含 `dynamic_plot` 的时候默认 `dynamic_plot`
% 为 False，也就是不需要实时动态打印过程。
if nargin == 6
    dynamic_plot = false;
end

% 展示欢迎和提示信息，通过终端输出的形式进行展示。
disp("====================================                                ")
disp("MATLAB Genetic Algorithm CVRP Solver                                ")
disp("====================================                                ")
disp("                                                                   ")
disp("Welcome using MATLAB Genetic Algorithm CVRP Solver. The solver uses")
disp("Genetic Algorithm to find minimal solution of CVRP problem. Use the")
disp("`help GA_VRP_optimize` in MATLAB cli to get more impormation.      ")
disp("                                                                   ")
disp("Author  : BOXonline_1396529                                        ")
disp("version : 0.1.0.0                                                  ")
disp("Date    : 2024-05-20                                               ")
disp("                                                                   ")
disp("Press Ctrl + C (For some reasons, maybe multi-times) to interupt.  ")
disp("                                                                   ")

% 开始遗传算法求解，首先初始化变量
disp("Optimitization Starting")
disp("-----------------------")
disp(" ")
disp("initializing variables...")

% 根据 OD 矩阵计算顾客数量
numNodes = length(OD_mat); % 计算出节点的总数量
numCustomers = numNodes - 1; % 第一个节点是 Depot，所以真实的顾客数量要减去 1

% 打印模型的基本参数
disp(" ")
disp("Model Description")
disp("-----------------")
fprintf("Number of Nodes: %d\n", numNodes)
fprintf("Number of Customers: %d\n", numCustomers)
fprintf("Available Vehicles: %d\n", numVehicles)
fprintf("Prob of crossover: %d\n", pc)
fprintf("Prob of mutation: %d\n", pm)

% 我们的染色体编码设计策略分为如下的两个步骤：
% 
% 1. 随机生成 1 到 numCustoms 的全排列。
% 2. 在排列中随机插入 numVehicles − 1 个 0。
%
% 被 0 隔绝开来的就是每一辆车的路径策略。

% 计算每个个体的染色体长度
% lenGenes = (numCustoms + (numVehicles - 1));

% 初始化种群
initialPop = initialize_pop(numCustomers, numVehicles, popSize);
disp(" ")
disp("Population Initialized.")

% 初始化适应度函数数组为全 0 数组
fitnessValues = zeros(popSize, 1);

% 如果选择了绘制实时动态图，就初始化几个向量来存储各迭代次数下的历史最优个体的最短
% 路程列表和当前种群最优个体的最短路程
if dynamic_plot
    record_minCost_elitist = [];
    record_minCost_pop = [];
    figure; % 初始化一个图对象以便绘制
end

% 开始主循环迭代
disp("Iteration start...")
iterPop = initialPop;

% 初始化假设精英个体的适应度函数值为 0，这个数值会在循环开始之后立即被初始种群中的
% 精英个体的适应度函数值覆盖
elitistFitnessValues = 0;
elitistFound = false; % 一个 Flag 变量，表示有没有找到精英个体

for i = 1:maxIter
    fitnessValues = fitness( ...
        iterPop, OD_mat, numCustomers, numVehicles, demands, capacity);

    % 有必要采用精英（elitism）策略，提取历史所有代际中的精英个体
    if max(fitnessValues) > elitistFitnessValues
        [elitistFitnessValues, elitistIndex] = max(fitnessValues);
        elitist = iterPop(elitistIndex, :);
        elitistFound = true;
    end

    if elitistFound
        [~, minFitnessIndex] = min(fitnessValues);
        iterPop(minFitnessIndex, :) = elitist;
    end

    if dynamic_plot % 如果选择了动态绘图
        record_minCost_elitist = [ 
            record_minCost_elitist, (1 / elitistFitnessValues)];
        record_minCost_pop = [
            record_minCost_pop, 1 / max(fitnessValues)];
        hold on;
        plot(record_minCost_elitist, ...
            'Color', 'r', ...
            'LineWidth', 1)
        plot(record_minCost_pop, ...
            'Color', 'b')
        title("Minimal Cost of Iterations")
        xlabel("Distance")
        ylabel("Iterations")
        grid on;
        legend('Elitist', 'Current Pop')
        drawnow;
        hold off; % 关闭 hold 以防止影响后续图片绘制
    end

    iterPop = roulette_wheel_selection(iterPop, fitnessValues);

    % 进行交叉和变异
    iterPop = crossover( ...
        iterPop, pc, numCustomers, numVehicles, demands, capacity);
    iterPop = mutation( ...
        iterPop, pm, numCustomers, numVehicles, demands, capacity);
end
disp("Iteration finished.")

% 提取最佳个体
bestIndividual = elitist;

% 计算最小花费（总距离的倒数为适应度值）
minCost = 1 / elitistFitnessValues;

disp(" ")
disp("Optimitization Finished")
disp("-----------------------")

if minCost == Inf
    disp("WARNING: No Feasible Solution Found.")
else
    fprintf("Minimal Cost: %.2f\n", minCost)
end
end