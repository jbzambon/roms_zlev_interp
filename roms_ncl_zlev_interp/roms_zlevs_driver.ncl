load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

loadscript("/shared/forecast/coawst_nf_nonest/Projects/useast/scripts/namelists/ROMS_utils.ncl")

system("rm -rf " + file_out)

system("ncgen -o " + file_out + " " + cdl_file)

in = addfile(file_in,"r")                         ; define output file
out = addfile(file_out,"w")                        ; define input file
z = (/0,5,10,15,20,30,40,50,75,100,125,150,200,250,\         ; define z-levels, dimensions must equal N
     300,400,500,600,800,1000,1200,1500,2000/)               ;   in CDL file called above

z = z*-1  ;upward positive convention

out->mask_rho = (/ in->mask_rho /)
out->lat_rho = (/ in->lat_rho /)
out->lon_rho = (/ in->lon_rho /)
out->z_rho = (/ z /)
out->ocean_time = (/ in->ocean_time /)
out->h = (/ in->h /)
out->zeta = (/ in->zeta /)

pid_temp = subprocess("ncl 'infile=" + integertochar(34) + file_in + integertochar(34) +\
                      "' 'outfile=" + integertochar(34) + file_out + integertochar(34) +\
                      "' /shared/forecast/coawst_nf_nonest/Projects/useast/scripts/namelists/roms_z_levs-temp.ncl")
print("Running Temp Interpolation on: " + pid_temp)
pid_salt = subprocess("ncl 'infile=" + integertochar(34) + file_in + integertochar(34) +\
                      "' 'outfile=" + integertochar(34) + file_out + integertochar(34) +\
                      "' /shared/forecast/coawst_nf_nonest/Projects/useast/scripts/namelists/roms_z_levs-salt.ncl")
print("Running Salt Interpolation on: " + pid_salt)
pid_u    = subprocess("ncl 'infile=" + integertochar(34) + file_in + integertochar(34) +\
                      "' 'outfile=" + integertochar(34) + file_out + integertochar(34) +\
                      "' /shared/forecast/coawst_nf_nonest/Projects/useast/scripts/namelists/roms_z_levs-u.ncl")
print("Running U Interpolation on: " + pid_u)
pid_v    = subprocess("ncl 'infile=" + integertochar(34) + file_in + integertochar(34) +\
                      "' 'outfile=" + integertochar(34) + file_out + integertochar(34) +\
                      "' /shared/forecast/coawst_nf_nonest/Projects/useast/scripts/namelists/roms_z_levs-v.ncl")
print("Running V Interpolation on: " + pid_v)
a=subprocess_wait(pid_temp,True)
b=subprocess_wait(pid_salt,True)
c=subprocess_wait(pid_u,True)
d=subprocess_wait(pid_v,True)

print("Successfully completed ROMS Z-Levels NCL")
