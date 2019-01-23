function [y_mode] = get_mode(labels, window)



for k = 1:1:floor(length(labels)/40)
    if k == 1
        y_mode(k) = mode(labels(1:40));
    elseif k == floor(length(labels)/40)
        y_mode(k) = mode(labels(k:end));
    else
        y_mode(k) = mode(labels(k:k + window));
    end    
end

end

