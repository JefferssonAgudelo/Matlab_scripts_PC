function fig = plot_diagnostics(diag, label)
% PLOT_DIAGNOSTICS  5-panel time-series plot for one run.
%
%   fig = plot_diagnostics(diag, 'my_run_label')
%
% Panels: J_rms, B_inplane_rms, B_total_rms, E_tot, anisotropy (i & e).
% Bottom x-axis = t*Omega_i (ion gyroperiods), top x-axis = t*omega_pi
% (ion plasma periods) via a linked secondary axis.

fs=18;

    if nargin < 2, label = ''; end

    fig = figure('Color','w','Position',[100 100 900 1100]);
    tOi = diag.t_Oi;

    ax = gobjects(5,1);

    ax(1) = subplot(5,1,1);
    plot(tOi, diag.Jrms, 'LineWidth', 1.5);
    ylabel('$J_{rms}$','Interpreter','latex','FontSize',fs);
    %title(strtrim(sprintf('Diagnostics %s', label)),'Interpreter','latex','FontSize',fs);
    annotation('textbox', [0.13, 0.999, 0, 0], 'string', label)
    grid on;

    ax(2) = subplot(5,1,2);
    plot(tOi, diag.Bip_rms, 'LineWidth', 1.5);
    ylabel('$|B_{in-plane}|_{rms}$','Interpreter','latex','FontSize',fs);
    grid on;

    ax(3) = subplot(5,1,3);
    plot(tOi, diag.Btot_rms, 'LineWidth', 1.5);
    ylabel('$|B_{tot}|_{rms}$','Interpreter','latex','FontSize',fs);
    grid on;

    ax(4) = subplot(5,1,4);
    plot(tOi, diag.Etot, 'LineWidth', 1.5);
    ylabel('$E_{tot}$','Interpreter','latex','FontSize',fs);
    grid on;

    ax(5) = subplot(5,1,5);
    plot(tOi, diag.aniso_i, 'LineWidth', 1.5, 'DisplayName', 'ion'); hold on;
    plot(tOi, diag.aniso_e, 'LineWidth', 1.5, 'DisplayName', 'electron');
    yline(1, '--', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');
    ylabel('$T_{\perp}/T_{\parallel}$','Interpreter','latex','FontSize',fs);
    xlabel('$t \Omega_i$','Interpreter','latex','FontSize',fs);
    legend('Location','best');
    grid on;

    linkaxes(ax, 'x');

    % secondary top x-axis in omega_pi units on the top panel
    add_top_time_axis(ax(1), diag);
end

function add_top_time_axis(ax_top, diag)
fs=18;

% Adds a top x-axis showing t*omega_pi, aligned to the same data range as
% the bottom axis (t*Omega_i) on ax_top.
    pos = get(ax_top, 'Position');
    ax2 = axes('Position', pos, 'Color', 'none', ...
               'XAxisLocation','top', 'YAxisLocation','right', ...
               'YTick', [], 'Box','off');
    xlim(ax2, [min(diag.t_opi) max(diag.t_opi)]);
    xlabel(ax2, '$\omega_{pi} t$','Interpreter','latex','FontSize',fs);
    linkprop([ax_top, ax2], {'Position'});
end
