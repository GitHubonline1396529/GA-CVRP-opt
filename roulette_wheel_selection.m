function selected_pop = roulette_wheel_selection(pop, fitness_values)
% ROULETTE_WHEEL_SELECTION 遗传算法中根据轮盘赌方式选择个体
% 
%    selected_pop = ROULETTE_WHEEL_SELECTION(pop, fitness_values)
% 
%    输入参数
%        pop - 种群矩阵，每一行表示一个个体
%        fitness_values - 每个个体的适应度值数组
%
%    返回参数
%        selected_pop - 选择的个体构成的新种群矩阵

% 计算总适应度值
total_fitness = sum(fitness_values);

% 计算每个个体的选择概率
selection_prob = fitness_values / total_fitness;

% 计算累积概率
% 
% 在轮盘赌选择法中，判断选择的个体时使用的不是选择概率，而是累积概率。这是因为轮盘
% 赌就好比扔飞镖，把各个个体被选中的概率映射到连续的 [0, 1] 中间去，然后生成一个
% 0-1 之间的随机数，落在谁的概率区间里面就选择谁。为了方便理解这种逻辑，我们假设现
% 在存在 A、B、C 三个个体，它们的选择概率依次为 [0.4, 0.1, 0.5]，而它们的累计概
% 率就是 [0.4, 0.5, 1]。我们生成 0-1 之间的随机数 r，也就是：
% 
% - 当 r 落在 [0.0, 0.4] 选择 A
% - 当 r 落在 (0.4, 0.1] 选择 B
% - 当 r 落在 (0.5, 1.0] 选择 C

cumulative_prob = cumsum(selection_prob);
% cumsum 是累计和函数。e.g.
% cumsum(1:5)
% ans =
%      1     3     6    10    15

% 初始化选择后的新种群
[num_individuals, num_genes] = size(pop);
selected_pop = zeros(num_individuals, num_genes);

% 轮盘赌选择

% 由于经过自然选择的种群在规模上应当等于原始种群，所以这里的逻辑就是开展次数相当于
% 原始种群个体数量的次数的循环，然后在每一轮循环中选择处一个个体。需要注意的是，在
% 这种方法当中，通过多轮循环，完全可能会从原始种群里数次重复挑选出同一个个体。这会
% 导致新的种群中存在该个体的多个副本。这是完全合理的。

for i = 1:num_individuals % 开展次数相当于原始种群个体数量的次数的循环
    r = rand; % 获得 0~1 之间的均匀标量
    selected_index = find(cumulative_prob >= r, 1, 'first');

    % 有可能出现所有的个体可能都被淘汰了，从而导致 selected_index 为空的情况
    % 如果未找到符合条件的个体，随机选择一个个体
    if isempty(selected_index)
        selected_index = randi(num_individuals);
    end
    % 最后还要将选择的个体
    selected_pop(i, :) = pop(selected_index, :);
end

end
