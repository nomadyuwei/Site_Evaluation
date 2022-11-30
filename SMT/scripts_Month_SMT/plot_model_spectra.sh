#for SEASON in DJF MAM JJA SON annual; do
for Month in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do

    paste ${OUTDIR_AM}/${SITE}_${Month}_25.out ${OUTDIR_AM}/${SITE}_${Month}_75.out > ${OUTDIR_AM}/${SITE}_${Month}_25_75.out

# Read pwv from output files
PWV_25=$(awk -f get_pwv.awk ${OUTDIR_AM}/${SITE}_${Month}_25.err)
PWV_50=$(awk -f get_pwv.awk ${OUTDIR_AM}/${SITE}_${Month}_50.err)
PWV_75=$(awk -f get_pwv.awk ${OUTDIR_AM}/${SITE}_${Month}_75.err)

    gnuplot \
        -e "Month='${Month}'"\
        -e "site='${SITE}'"\
        -e "site_label='${SITE_LABEL}'"\
        -e "site_lat=${SITE_LAT}"\
        -e "site_long=${SITE_LONG}"\
        -e "outdir='${OUTDIR_AM}'"\
        -e "f_min=${F_MIN}"\
        -e "f_max=${F_MAX}"\
        -e "pwv_25='${PWV_25}'"\
        -e "pwv_50='${PWV_50}'"\
        -e "pwv_75='${PWV_75}'"\
        plot_model_spectra.gnu
done
