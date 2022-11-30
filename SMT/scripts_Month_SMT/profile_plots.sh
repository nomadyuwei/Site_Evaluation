# To facilitate plotting quantile profiles using filled regions, concatenate the
# quantile profile data with a reverse-sorted version of itself.  Then call
# gnuplot to generate the plot.

#for SEASON in DJF MAM JJA SON annual; do
for Month in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do

# Read pwv from am output files
PWV_5=$(awk -f get_pwv.awk ${OUTDIR_AM}/${SITE}_${Month}_5.err)
PWV_25=$(awk -f get_pwv.awk ${OUTDIR_AM}/${SITE}_${Month}_25.err)
PWV_50=$(awk -f get_pwv.awk ${OUTDIR_AM}/${SITE}_${Month}_50.err)
PWV_75=$(awk -f get_pwv.awk ${OUTDIR_AM}/${SITE}_${Month}_75.err)
PWV_95=$(awk -f get_pwv.awk ${OUTDIR_AM}/${SITE}_${Month}_95.err)

echo $Month PWV $PWV_25 $PWV_50 $PWV_75

sort -g ${OUTDIR_PROFILES}/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles_ex.txt | awk '
/#/ { print; next }
{ printf("%8s %s %s %s %s %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s\n",
$1, $6, $5, $4, $3, $2, $11, $10, $9, $8, $7, $16, $15, $14, $13, $12)
}
' > temp_1
cat ${OUTDIR_PROFILES}/${SITE}_${Month}_${DATERANGE}_MERRA_quantiles_ex.txt temp_1 > temp_2
    gnuplot \
        -e "site='${SITE}'"\
        -e "site_label='${SITE_LABEL}'"\
        -e "Month='${Month}'"\
        -e "daterange='${DATERANGE}'"\
        -e "site_lat=${SITE_LAT}"\
        -e "site_long=${SITE_LONG}"\
        -e "psurf=${PSURF}"\
        -e "outdir='${OUTDIR_PROFILES}'"\
        -e "T_min='${T_MIN}'"\
        -e "T_max='${T_MAX}'"\
        -e "xh2o_min='${XH2O_MIN}'"\
        -e "xh2o_max='${XH2O_MAX}'"\
        -e "xo3_min='${XO3_MIN}'"\
        -e "xo3_max='${XO3_MAX}'"\
        -e "pwv_5='${PWV_5}'"\
        -e "pwv_25='${PWV_25}'"\
        -e "pwv_50='${PWV_50}'"\
        -e "pwv_75='${PWV_75}'"\
        -e "pwv_95='${PWV_95}'"\
        profile_plots.gnu
done

rm -f temp_1 temp_2
