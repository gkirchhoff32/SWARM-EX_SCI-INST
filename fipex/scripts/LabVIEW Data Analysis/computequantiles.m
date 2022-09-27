function [t_unique, quartiles] = computequantiles(t, sig, num_quantiles)
    % Function to compute quartiles from stacked cycle signal with
    % inconsistent timestamps.
    % Inputs:
    % t  : Time matrix [nxm]
    % sig: Signal of interest (stacked segments comprising each cycle)
    % e.g., current for FIPEX [nxm]
    % num_quantiles: Number of desired quantiles [scalar]
    % Outputs:
    % quartiles: Quartile values [n x num_quantiles]

    % Set up order statistics
    [t_unique, ia, ic] = unique(t);
    t_unique = t_unique(~isnan(t_unique));
    quartiles = zeros(length(t_unique), num_quantiles);
    for i=1:length(t_unique)
        idx = t==t_unique(i);
        quartiles(i, :) = quantile(sig(idx), num_quantiles);
    end
end