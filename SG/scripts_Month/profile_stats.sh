# This script computes percentile profile statistics for a given site by
# first horizontally interpolating a set of MERRA-2 NetCDF files to the
# site longitude and latitude, then using a set of nco scripts to compute
# the percentile profiles for temperature, water vapor, ozone, and
# geopotential height.

# Find data files by Month, and concatenate
for Month in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do

echo $SITE $Month $DATADIR

case $Month in
Jan)
    find $DATADIR  -name *Np.????01??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Jan:-${PSURF}}
    ;;

Feb)
    find $DATADIR  -name *Np.????02??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Feb:-${PSURF}}
    ;;

Mar)
    find $DATADIR  -name *Np.????03??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Mar:-${PSURF}}
    ;;

Apr)
    find $DATADIR  -name *Np.????04??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Apr:-${PSURF}}
    ;;

May)
    find $DATADIR  -name *Np.????05??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_May:-${PSURF}}
    ;;

Jun)
    find $DATADIR  -name *Np.????06??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Jun:-${PSURF}}
    ;;

Jul)
    find $DATADIR  -name *Np.????07??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Jul:-${PSURF}}
    ;;

Aug)
    find $DATADIR  -name *Np.????08??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Aug:-${PSURF}}
    ;;

Sep)
    find $DATADIR  -name *Np.????09??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Sep:-${PSURF}}
    ;;

Oct)
    find $DATADIR  -name *Np.????10??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Oct:-${PSURF}}
    ;;

Nov)
    find $DATADIR  -name *Np.????11??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Nov:-${PSURF}}
    ;;

Dec)
    find $DATADIR  -name *Np.????12??.nc4*  -print  | sort -t '.' -k 5 | ncrcat -3 -h -O -o 0.nc
    PS=${PSURF_Dec:-${PSURF}}
    ;;
esac

# split into one file for each neighboring MERRA grid point
ncks -O -d lon,0 -d lat,0 0.nc 1.nc
ncks -O -d lon,1 -d lat,0 0.nc 2.nc
ncks -O -d lon,0 -d lat,1 0.nc 3.nc
ncks -O -d lon,1 -d lat,1 0.nc 4.nc

# Interpolate to the site position (ncflint segfaults with -i option, so
# give explicit weights with -w.) Start by computing the weighting factors.
W1=$(awk -v x=$SITE_LONG -v x0=$MERRA_LONG0 -v x1=$MERRA_LONG1 'BEGIN {print (x1 - x) / (x1 - x0)}')
W2=$(awk -v w1=$W1 'BEGIN {print 1.0 - w1}')
W3=$(awk -v y=$SITE_LAT -v y0=$MERRA_LAT0 -v y1=$MERRA_LAT1 'BEGIN {print (y1 - y) / (y1 - y0)}')
W4=$(awk -v w3=$W3 'BEGIN {print 1.0 - w3}')

# Do the interpolation, then use ncap2 to set the lon and lat
# fields in the NetCDF file to the interpolated coordinates.
ncflint -O -w ${W1},${W2} 1.nc 2.nc 7.nc
ncap2 -O -s "lon={${SITE_LONG}}" 7.nc 5.nc
ncflint -O -w ${W1},${W2} 3.nc 4.nc 7.nc
ncap2 -O -s "lon={${SITE_LONG}}" 7.nc 6.nc
ncflint -O -w ${W3},${W4} 5.nc 6.nc 7.nc
ncap2 -O -s "lat={${SITE_LAT}}" 7.nc ${SITE}_${Month}_${DATERANGE}.nc
rm [0-7].nc 

# Compute quantiles
ncap2 -O -S T_quantiles.nco ${SITE}_${Month}_${DATERANGE}.nc ${SITE}_${Month}_${DATERANGE}.nc
ncap2 -O -S QV_quantiles.nco ${SITE}_${Month}_${DATERANGE}.nc ${SITE}_${Month}_${DATERANGE}.nc
ncap2 -O -S O3_quantiles.nco ${SITE}_${Month}_${DATERANGE}.nc ${SITE}_${Month}_${DATERANGE}.nc
ncap2 -O -S H_quantiles.nco ${SITE}_${Month}_${DATERANGE}.nc ${SITE}_${Month}_${DATERANGE}.nc

# Extract pressure levels into a single-column file

# As of version 4.6.8, ncks needs the new --trd switch to keep the
# traditional line-by-line format.  Otherwise the new default output
# format is CDL.
ncks --trd -H -v lev ${SITE}_${Month}_${DATERANGE}.nc |
awk 'BEGIN {FS="="} /lev/ {printf("%8.1f\n", $2)}' > lev.col

# Extract corresponding profiles vs. pressure into single-column files,
# converting mass mixing ratios to volume mixing ratios in parts per million.
for QUANTILE in q05 q25 med q75 q95; do
    ncks --trd -H -v T_${QUANTILE} ${SITE}_${Month}_${DATERANGE}.nc |
    awk 'BEGIN {FS="="} /T_/ {printf("%8.3f\n", $3 < 1000. ? $3 : 999.999)}' > T_${QUANTILE}.col
    ncks --trd -H -v QV_${QUANTILE} ${SITE}_${Month}_${DATERANGE}.nc |
    awk 'BEGIN {FS="="} /QV_/ {printf("%12.4e\n", $3 < 1e10 ? 1e6 * (28.964 / 18.015) * $3 / (1.0 - $3) : 9.9999e99)}' > h2o_vmr_${QUANTILE}.col
    ncks --trd -H -v O3_${QUANTILE} ${SITE}_${Month}_${DATERANGE}.nc |
    awk 'BEGIN {FS="="} /O3_/ {printf("%12.4e\n", $3 < 1e10 ? 1e6 * (28.964 / 47.997) * $3 : 9.9999e99)}' > o3_vmr_${QUANTILE}.col
    ncks --trd -H -v H_${QUANTILE} ${SITE}_${Month}_${DATERANGE}.nc |
    awk 'BEGIN {FS="="} /H_/ {printf("%12.4e\n", $3 < 1e10 ? $3 : 9.9999e99)}' > H_${QUANTILE}.col
done

rm -f ${SITE}_${Month}_${DATERANGE}.nc

# Paste all the columns together into a single file under a header line.
echo "#  P[mb]  T_05[K] T_25[K] T_50[K] T_75[K] T_95[K]  H2O_05[ppm] H2O_25[ppm] H2O_50[ppm] H2O_75[ppm] H2O_95[ppm]  O3_05[ppm] O3_25[ppm] O3_50[ppm] O3_75[ppm] O3_95[ppm]  H_05[m] H_25[m] H_50[m] H_75[m] H_95[m]" \
    > ${OUTDIR_PROFILES}/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles.txt

paste -d "\0" lev.col \
    T_q05.col T_q25.col T_med.col T_q75.col T_q95.col\
    h2o_vmr_q05.col h2o_vmr_q25.col h2o_vmr_med.col h2o_vmr_q75.col h2o_vmr_q95.col \
    o3_vmr_q05.col o3_vmr_q25.col o3_vmr_med.col o3_vmr_q75.col o3_vmr_q95.col\
    H_q05.col H_q25.col H_med.col H_q75.col H_q95.col\
    >> ${OUTDIR_PROFILES}/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles.txt

awk -f extrapolate_to_surface.awk Ptrunc=$PTRUNC Ps=$PS ${OUTDIR_PROFILES}/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles.txt > ${OUTDIR_PROFILES}/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles_ex.txt

done

rm -r lev.col \
    T_q05.col T_q25.col T_med.col T_q75.col T_q95.col\
    h2o_vmr_q05.col h2o_vmr_q25.col h2o_vmr_med.col h2o_vmr_q75.col h2o_vmr_q95.col \
    o3_vmr_q05.col o3_vmr_q25.col o3_vmr_med.col o3_vmr_q75.col o3_vmr_q95.col\
    H_q05.col H_q25.col H_med.col H_q75.col H_q95.col\
