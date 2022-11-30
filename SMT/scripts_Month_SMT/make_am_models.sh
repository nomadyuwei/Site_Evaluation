# Make am models for the site, corresponding to 5,25,50,75,95 percentile
# H2O profiles.  For O3, use the median profile in all models.

#for SEASON in DJF MAM JJA SON annual ; do
for Month in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do

#export SEASON
export Month

for PERCENTILE in 5 25 50 75 95 ; do
./am_file_header.sh ${PERCENTILE} > \
    ${OUTDIR_AM}/${SITE}_${Month}_${PERCENTILE}.amc
done

awk -f MERRA_to_am.awk T_col=2 x_H2O_col=7  x_O3_col=14 P_ground=$PSURF ../profile_stats/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles_ex.txt >> ${OUTDIR_AM}/${SITE}_${Month}_5.amc

awk -f MERRA_to_am.awk T_col=3 x_H2O_col=8  x_O3_col=14 P_ground=$PSURF ../profile_stats/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles_ex.txt >> ${OUTDIR_AM}/${SITE}_${Month}_25.amc

awk -f MERRA_to_am.awk T_col=4 x_H2O_col=9  x_O3_col=14 P_ground=$PSURF ../profile_stats/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles_ex.txt >> ${OUTDIR_AM}/${SITE}_${Month}_50.amc

awk -f MERRA_to_am.awk T_col=5 x_H2O_col=10 x_O3_col=14 P_ground=$PSURF ../profile_stats/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles_ex.txt >> ${OUTDIR_AM}/${SITE}_${Month}_75.amc

awk -f MERRA_to_am.awk T_col=6 x_H2O_col=11 x_O3_col=14 P_ground=$PSURF ../profile_stats/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles_ex.txt >> ${OUTDIR_AM}/${SITE}_${Month}_95.amc

done
