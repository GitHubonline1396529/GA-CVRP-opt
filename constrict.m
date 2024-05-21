function isFeasible = constrict( ...
    individual, numCustomers, numVehicles, demands, capacity)
% CONSTRICT 模型的约束，检验遗传算法中的一个个体是否可行
%    返回一个 Bool 变量 isFeasible，表征传入的个体 individual 是否是当前问题的
%    一个可行的解。
% 
%    isFeasible = CONSTRICT(individual, numCustomers, numVehicles)
%    
%    输入参数
%        individual - 当前接受约束检验的个体
%        numCustomers - CVRP 问题中顾客节点的数量
%        numVehicles - CVRP 问题中运载工具的数量
%        demands - CVRP 问题中各个顾客节点的需求量的一维向量
%        capacity - CVRP 问题中运载工具的容量限制
%
%    输出参数
%        isFeasible - 一个 Bool 变量 isFeasible，表示传入的个体 individual 是
%            否是当前问题的一个可行的解。

% 初始化 flag 为 true
isFeasible = true;
% 获取所有节点的编号数组（从 0 开始）
allNodes = 0:numCustomers;

% 禁止产生使用的汽车数量超过限制的配送方案
% 检验汽车数量是否超限，如果是的话就强制令适应度函数为 0
if length(find(individual == 0)) > (numVehicles - 1)
    isFeasible = false;
end

% 要求汽车必须遍历所有的节点
% 如果没有遍历所有的节点，就强制令适应度函数为 0
if ~all(ismember(allNodes, individual))
    isFeasible = false;
end

% 检验配送方案是否超出了汽车运载能力限制
total_demands = 0;
for i = 1 : length(individual)
    if individual(i) == 0
        if total_demands > capacity
            isFeasible = false;
            break;
        end
        total_demands = 0;
    else
        total_demands = total_demands + demands(individual(i));
    end
end

% 实践发现这个地方存在一个逻辑漏洞
% 对方案的检验过程中只在遇到 0 的时候检验 total demands，这样就会造成始终不检验最
% 后一辆车。因此要在遍历结束之后加这三行代码进行最后的检验
if total_demands > capacity
    isFeasible = false;
end

end
