function [Bx, By, Bz, Jx, Jy, Jz] = read_psc_fields(fname, field_group_override)
% READ_PSC_FIELDS  Read hx_fc/hy_fc/hz_fc and jx_ec/jy_ec/jz_ec from one
% PSC pfd.*.h5 file, correctly oriented as (nz, ny).
%
%   [Bx,By,Bz,Jx,Jy,Jz] = read_psc_fields(fname, field_group_override)
%
% field_group_override: if non-empty, used directly as the per-step HDF5
% group path (e.g. '/jeh-uid-0x18baef0'); if empty, auto-detected via
% find_group_with_subgroup.
%
% NOTE on orientation: the xdmf declares each dataset as (z,y,x), but
% MATLAB's h5read returns dimensions in REVERSE order relative to that
% declaration (row-major/C storage vs MATLAB's column-major convention)
% -- confirmed empirically. So squeeze(h5read(...)) comes out as (ny,nz),
% and this function transposes back to (nz,ny) before returning.

    if ~isempty(field_group_override)
        grp = field_group_override;
    else
        info = h5info(fname);
        grp = find_group_with_subgroup(info.Groups, 'hx_fc');
        if isempty(grp)
            error('read_psc_fields: could not locate the "hx_fc" group inside %s -- set field_group_override instead.', fname);
        end
    end

    Bx = squeeze(h5read(fname, strcat(grp, '/hx_fc/p0/3d'))).';
    By = squeeze(h5read(fname, strcat(grp, '/hy_fc/p0/3d'))).';
    Bz = squeeze(h5read(fname, strcat(grp, '/hz_fc/p0/3d'))).';
    Jx = squeeze(h5read(fname, strcat(grp, '/jx_ec/p0/3d'))).';
    Jy = squeeze(h5read(fname, strcat(grp, '/jy_ec/p0/3d'))).';
    Jz = squeeze(h5read(fname, strcat(grp, '/jz_ec/p0/3d'))).';
end
