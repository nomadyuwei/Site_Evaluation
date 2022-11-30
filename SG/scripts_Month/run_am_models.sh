# set up a local cache directory for am (speeds up re-runs):
if [ ! -d ${OUTDIR_AM}/am_cache ]; then
    mkdir ${OUTDIR_AM}/am_cache
fi
export AM_CACHE_PATH=${OUTDIR_AM}/am_cache
export AM_CACHE_HASH_MODULUS=7001

#for SEASON in DJF MAM JJA SON annual; do
for Month in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do
am ${OUTDIR_AM}/${SITE}_${Month}_5.amc  $F_MIN GHz $F_MAX GHz $DF MHz 0 deg 1.0 > ${OUTDIR_AM}/${SITE}_${Month}_5.out  2>${OUTDIR_AM}/${SITE}_${Month}_5.err
am ${OUTDIR_AM}/${SITE}_${Month}_25.amc $F_MIN GHz $F_MAX GHz $DF MHz 0 deg 1.0 > ${OUTDIR_AM}/${SITE}_${Month}_25.out 2>${OUTDIR_AM}/${SITE}_${Month}_25.err
am ${OUTDIR_AM}/${SITE}_${Month}_50.amc $F_MIN GHz $F_MAX GHz $DF MHz 0 deg 1.0 > ${OUTDIR_AM}/${SITE}_${Month}_50.out 2>${OUTDIR_AM}/${SITE}_${Month}_50.err
am ${OUTDIR_AM}/${SITE}_${Month}_75.amc $F_MIN GHz $F_MAX GHz $DF MHz 0 deg 1.0 > ${OUTDIR_AM}/${SITE}_${Month}_75.out 2>${OUTDIR_AM}/${SITE}_${Month}_75.err
am ${OUTDIR_AM}/${SITE}_${Month}_95.amc $F_MIN GHz $F_MAX GHz $DF MHz 0 deg 1.0 > ${OUTDIR_AM}/${SITE}_${Month}_95.out 2>${OUTDIR_AM}/${SITE}_${Month}_95.err
done
