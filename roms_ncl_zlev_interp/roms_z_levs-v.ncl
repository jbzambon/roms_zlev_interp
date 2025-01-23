load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/shared/forecast/coawst_nf_nonest/Projects/useast/scripts/namelists/ROMS_utils.ncl"

in = addfile(infile,"r")                                     ; define output file
out = addfile(outfile,"w")                                   ; define input file
z = (/0,5,10,15,20,30,40,50,75,100,125,150,200,250,\         ; define z-levels, dimensions must equal N
      300,400,500,600,800,1000,1200,1500,2000/)              ;   in CDL file called above

z = z*-1  ;upward positive convention

max_S = dimsizes(in->temp(0,:,0,0))
ntimes = dimsizes(in->temp(:,0,0,0))
nlevs = dimsizes(z)

do time = 0,ntimes-1,1
    ;print(time)
    do lev = 0,nlevs-1,1
        ;print(z(lev))
        if (z(lev).eq.0)             ; z = 0, surface fields
            out->v(time,lev,:,:) = (/ v2rho(in->v(time, max_S-1,:,:)) /)
        else                         ; z < 0, subsurface interpolation
            out->v(time,lev,:,:) = (/ roms_3d_interp(in,"v",time,z(lev)) /)
        end if
    end do
end do

