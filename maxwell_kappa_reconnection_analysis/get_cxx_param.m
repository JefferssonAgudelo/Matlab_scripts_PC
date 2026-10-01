function val = get_cxx_param(txt, varname, no_word_boundary)
% GET_CXX_PARAM  Extract a numeric value from a line like "g.foo = 1.23;"
% in the .cxx source text.
%
%   val = get_cxx_param(txt, 'g\.mass_ratio')
%       finds "g.mass_ratio = <number>" and returns <number>.
%
%   val = get_cxx_param(txt, 'Ly\s*=\s*([-+0-9.eEdD]+)\s*\*\s*g\.d_i', true)
%       treats the pattern as already complete (with its own capture
%       group) rather than appending "\s*=\s*(...)" automatically --
%       used for the "double Ly = 60.0 * g.d_i;" style lines.
%
% Keep this in its own file (rather than as a local function at the end
% of the calling script) for maximum portability across MATLAB versions
% and Octave.

    if nargin < 3
        no_word_boundary = false;
    end
    if no_word_boundary
        pat = varname;
    else
        pat = [varname '\s*=\s*([-+0-9.eEdD]+)'];
    end
    tok = regexp(txt, pat, 'tokens', 'once');
    if isempty(tok)
        error('get_cxx_param: could not find pattern "%s" in the .cxx file.', pat);
    end
    val = str2double(tok{1});
end
