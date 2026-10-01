% f and PSD_B from your PSD computation (make sure PSD_B is per Hz)
Nbins = 40;
PSD_B = PSD_E_dt1_2;

f=f_2;

[f_bin, PSD_bin] = logbin_psd_conserve(f, PSD_B, Nbins);

% Plot original and binned (energy-conserving)
figure;
loglog(f, PSD_B, '.','Color',[0.7 0.7 0.7]); hold on;
loglog(f_bin, PSD_bin, '-k', 'LineWidth', 1.8);
xlabel('Frequency [Hz]'); ylabel('PSD [units^2/Hz]');
legend('Original PSD', 'Log-binned (energy-conserving)');
grid on;

% Inputs:
% f      - frequency vector (Hz), monotonically increasing, column
% PSD_B  - PSD(f) values (units^2/Hz), column
% Nbins  - number of log bins (scalar)
%
% Outputs:
% f_bin  - representative frequency for the bin (geometric mean)
% PSD_bin - energy-conserving binned PSD (units^2/Hz)
%
function [f_bin, PSD_bin] = logbin_psd_conserve(f, PSD_B, Nbins)

    % ensure column vectors and positive frequencies
    f = f(:);
    PSD_B = PSD_B(:);
    valid = (f > 0) & isfinite(f) & isfinite(PSD_B);
    f = f(valid); PSD_B = PSD_B(valid);

    % log-spaced bin edges
    edges = logspace(log10(min(f)), log10(max(f)), Nbins+1);

    f_bin = zeros(Nbins,1);
    PSD_bin = zeros(Nbins,1);

    for k = 1:Nbins
        fl = edges(k);
        fr = edges(k+1);

        % points in the bin
        idx = (f >= fl) & (f <= fr);

        if ~any(idx)
            % empty bin
            f_bin(k)   = sqrt(fl*fr);   % geometric mean of edges
            PSD_bin(k) = NaN;
            continue;
        end

        ff = f(idx);
        pp = PSD_B(idx);

        % representative frequency = geometric mean of present values
        f_bin(k) = exp(mean(log(ff)));

        % bin width in Hz
        width = fr - fl;

        % ---- ENERGY-CONSERVING PSD ----
        if numel(ff) == 1
            % only one point: approximate local df
            % use nearest-neighbor spacing
            if ff < f(1)
                df_local = abs(f(2) - f(1));
            elseif ff > f(end)
                df_local = abs(f(end) - f(end-1));
            else
                % find nearest frequency
                [~,I] = min(abs(f - ff));
                if I == 1
                    df_local = abs(f(2) - f(1));
                elseif I == numel(f)
                    df_local = abs(f(end) - f(end-1));
                else
                    df_local = 0.5 * abs(f(I+1) - f(I-1));
                end
            end

            E_bin = pp * df_local;  % approximate integrated energy

        else
            % normal integration
            E_bin = trapz(ff, pp);  
        end

        % energy-conserving PSD estimate
        PSD_bin(k) = E_bin / width;
    end

    % remove empty bins
    mask = ~isnan(PSD_bin);
    f_bin   = f_bin(mask);
    PSD_bin = PSD_bin(mask);

end
