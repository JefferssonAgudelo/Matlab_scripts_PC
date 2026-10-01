function params = parse_cxx_params(cxx_path)
% PARSE_CXX_PARAMS  Extract physics parameters from a PSC .cxx setup file.
%
%   params = parse_cxx_params('psc_turbulence_2D_maxwellian_3.cxx')
%
% HOW IT WORKS
%   The PSC setup files declare parameters as plain member assignments,
%   e.g.  g.BB = 1.0;  g.B0 = g.vA_over_c;  g.Te_par = g.beta_e_par*sqr(g.B0)/2.;
%   That is *already valid MATLAB* struct-assignment syntax (g.field = value;),
%   so rather than regex-matching every variable name individually, we pull
%   out the body of setupParameters() (plus the g.d_i line from setupGrid())
%   and literally eval() it into a fresh struct `g`. This survives you
%   adding/renaming/reordering parameters in future .cxx files, as long as
%   the assignments stay simple arithmetic on g.* fields.
%
% CAVEATS (please verify against your actual .cxx if something looks off)
%   - Only handles straight-line arithmetic assignments (+,-,*,/,^, sqr(),
%     sqrt(), M_PI). Conditional/branching parameter setup would need
%     more work.
%   - g.d_i is pulled from setupGrid() specifically because it depends on
%     g.mass_ratio and g.n which are only defined in setupParameters().
%
% OUTPUT
%   params: struct with all g.* fields from the file, plus:
%     .mass_ratio, .Zi, .B0, .vA_over_c, .n
%     .Ti_par, .Ti_perp, .Te_par, .Te_perp
%     .Ti_perp_over_Ti_par, .Te_perp_over_Te_par   (initial imposed ratios)
%     .mi, .me, .d_i
%     .source_file

    if ~isfile(cxx_path)
        error('parse_cxx_params:notfound', 'File not found: %s', cxx_path);
    end

    txt = fileread(cxx_path);

    % ---- pull the setupParameters() body -------------------------------
    body = extract_function_body(txt, 'setupParameters');
    if isempty(body)
        error('parse_cxx_params:nofunc', ...
            'Could not locate setupParameters() in %s', cxx_path);
    end

    % ---- pull the g.d_i line from setupGrid() (may depend on g.n, g.mass_ratio)
    grid_body = extract_function_body(txt, 'setupGrid');
    d_i_line = '';
    if ~isempty(grid_body)
        m = regexp(grid_body, 'g\.d_i\s*=\s*[^;]+;', 'match', 'once');
        if ~isempty(m)
            d_i_line = m;
        end
    end

    code = [body, newline, d_i_line];

    % ---- keep only g.<field> = <expr>; assignment lines ----------------
    lines = regexp(code, '[^\r\n]+', 'match');
    keep = {};
    for i = 1:numel(lines)
        l = strtrim(lines{i});
        % strip // comments
        l = regexprep(l, '//.*$', '');
        l = strtrim(l);
        if isempty(l), continue; end
        if regexp(l, '^g\.\w+\s*=\s*.+;$', 'once')
            keep{end+1} = l; %#ok<AGROW>
        end
    end

    if isempty(keep)
        error('parse_cxx_params:noassign', ...
            'Found setupParameters() but no g.* assignments inside it.');
    end

    code_clean = strjoin(keep, newline);

    % ---- C++ -> MATLAB token translation --------------------------------
    code_clean = regexprep(code_clean, 'std::', '');
    code_clean = regexprep(code_clean, 'M_PI', 'pi');
    % sqr(x) -> local helper defined below
    % (leave sqrt(), pow-free arithmetic as-is; MATLAB understands them)

    % ---- eval into a fresh struct g -------------------------------------
    g = struct(); %#ok<NASGU> (built by eval below)
    try
        eval(code_clean);
    catch ME
        error('parse_cxx_params:eval', ...
            'Failed evaluating extracted parameter code from %s.\nOffending code:\n%s\n\nMATLAB error: %s', ...
            cxx_path, code_clean, ME.message);
    end

    params = g;
    params.source_file = cxx_path;

    % ---- sanity checks / friendly aliases --------------------------------
    required = {'mass_ratio','B0','n'};
    for i = 1:numel(required)
        if ~isfield(params, required{i})
            warning('parse_cxx_params:missing', ...
                'Expected field g.%s not found after parsing %s.', ...
                required{i}, cxx_path);
        end
    end

    if isfield(params,'vA_over_c') && ~isfield(params,'B0')
        params.B0 = params.vA_over_c;
    end
end

% =========================================================================
function body = extract_function_body(txt, fname)
% Extract the { ... } body of the first function named fname (naive brace
% matching -- fine for the simple, non-nested-string setup files PSC uses).
    body = '';
    pat = sprintf('%s\\s*\\([^\\)]*\\)\\s*\\{', fname);
    m = regexp(txt, pat, 'once', 'start');
    if isempty(m)
        return;
    end
    % find the opening brace position
    brace_start = regexp(txt(m:end), '\{', 'once') + m - 1;
    depth = 0;
    i = brace_start;
    n = length(txt);
    body_start = brace_start + 1;
    while i <= n
        c = txt(i);
        if c == '{'
            depth = depth + 1;
        elseif c == '}'
            depth = depth - 1;
            if depth == 0
                body = txt(body_start:i-1);
                return;
            end
        end
        i = i + 1;
    end
end

function y = sqr(x)
    y = x.^2;
end
