function [y_agg] = get_agg(labels)

y_agg = labels;

idx = y_agg == 1 | y_agg == 2 | y_agg == 3;

y_agg(idx) = 3;

end

