function fig = compare_runs(diag_list, labels)
% COMPARE_RUNS  Overlay diagnostics from multiple runs.
%
%   diag1 = compute_diagnostics(run1_path, cxx1_path);
%   diag2 = compute_diagnostics(run2_path, cxx2_path);
%   compare_runs({diag1, diag2}, {'run A', 'run B'});
%
% Time axis is t*Omega_i (ion gyroperiods) for every run, so runs with
% different mass ratios / B0 / vA are compared on a physically
% commensurate time axis rather than raw simulation steps.

    nrun = numel(diag_list);
    colors = lines(nrun);
    fs=18;

    fig = figure('Color','w','Position',[100 100 900 1100]);
    ax = gobjects(5,1);
    panel_titles = {'$J_{rms}$',... 
        '$|B_{in-plane}|_{rms}$',...
        '$|B_{tot}|_{rms}$',...
        '$E_{tot}$',...
        '$T_{\perp}/T_{\parallel} (i, so; e, da)$'};

    for p = 1:5
        ax(p) = subplot(5,1,p); hold on; grid on;
        ylabel(panel_titles{p},'Interpreter','latex','FontSize',fs);
    end

    for r = 1:nrun
        d0 = diag_list{r};
        d = d0.diag;
        c = colors(r,:);
        lbl = labels{r};

        plot(ax(1), d.t_Oi, d.Jrms,     'Color', c, 'LineWidth', 1.5, 'DisplayName', lbl);
        plot(ax(2), d.t_Oi, d.Bip_rms,  'Color', c, 'LineWidth', 1.5, 'DisplayName', lbl);
        plot(ax(3), d.t_Oi, d.Btot_rms, 'Color', c, 'LineWidth', 1.5, 'DisplayName', lbl);
        plot(ax(4), d.t_Oi, d.Etot,     'Color', c, 'LineWidth', 1.5, 'DisplayName', lbl);
        plot(ax(5), d.t_Oi, d.aniso_i,  'Color', c, 'LineStyle', '-',  'LineWidth', 1.5, 'HandleVisibility','off');
        plot(ax(5), d.t_Oi, d.aniso_e,  'Color', c, 'LineStyle', '--', 'LineWidth', 1.5, 'HandleVisibility','off');
    end
    
    %ax(4).YScale = 'log';
    ax(5).YScale = 'log';
    
    yline(ax(5), 1, ':', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');
    xlabel(ax(5), '$t \Omega_i$','Interpreter','latex','FontSize',fs);
    legend(ax(1), 'Location','best');
    title(ax(1), 'Run comparison');
    linkaxes(ax, 'x');
end
