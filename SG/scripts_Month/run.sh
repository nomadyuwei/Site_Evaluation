# Master script to compute profile statistics, generate am models, and compute
# spectra.

# Site name, date range, and path to directory containing the  data files.
export SITE=SG
export SITE_LABEL='SG'
# export DATERANGE=2006-2015
export DATERANGE=2018-2021
# export DATADIR=../${DATERANGE}
# random subset of data files to speed up demo/testing
# export DATADIR=../${DATERANGE}_rnd_subset
export DATADIR=../New_Data_SG_2018-2021


# Site coordinates, and bracketing MERRA-2 grid coordinates
export SITE_LAT=29.2
export SITE_LONG=88.63

export MERRA_LAT0=29.0
export MERRA_LAT1=29.5
export MERRA_LONG0=88.125
export MERRA_LONG1=88.75

# The surface pressure at the MERRA-2 grid points may not match the nominal
# site surface pressure.  The following constants control truncation
# of the MERRA-2 profiles to some point above the surface (such that all
# levels have valid data), and interpolation or extrapolation to the
# nominal surface pressure.

# include levels above this pressure level:
#export PTRUNC=651. # truncation point [mbar] of MERRA-2 profiles
# default site surface pressure [mbar]
#export PSURF=625.
# seasonal values override default if set
#export PSURF_annual=625.
#export PSURF_DJF=624.
#export PSURF_MAM=625.
#export PSURF_JJA=626.
#export PSURF_SON=625.5

export PTRUNC=590. # truncation point [mbar] of MERRA-2 profiles
# default site surface pressure [mbar]
export PSURF=580.
# seasonal values override default if set
export PSURF_annual=580.
export PSURF_DJF=579.
export PSURF_MAM=580.
export PSURF_JJA=581.
export PSURF_SON=580.5

export PSURF_Dec=579.
export PSURF_Jan=579.
export PSURF_Feb=579.

export PSURF_Mar=580.
export PSURF_Apr=580.
export PSURF_May=580.

export PSURF_Jun=581.
export PSURF_Jul=581.
export PSURF_Aug=581.

export PSURF_Sep=580.5
export PSURF_Oct=580.5
export PSURF_Nov=580.5

# Plot ranges for profiles.  T in K, mixing ratios in ppm
export T_MIN=190
export T_MAX=310
export XH2O_MIN=1
export XH2O_MAX=30000
export XO3_MIN=0.01
export XO3_MAX=20

# Frequency range [GHz] for am models
#export F_MIN=0.
#export F_MAX=1000.

export F_MIN=200.
export F_MAX=500.

# Frequency interval [MHz]
# export DF=10.
# coarse resolution option to speed up demo/testing
export DF=250.

# Compute profile statistics.
export OUTDIR_PROFILES=../profile_stats
if [ ! -d $OUTDIR_PROFILES ]; then
    mkdir $OUTDIR_PROFILES
fi
echo computing seasonal statistics ...
./profile_stats.sh

# Generate am model files and compute spectra.
export OUTDIR_AM=../am_models
if [ ! -d $OUTDIR_AM ]; then
    mkdir $OUTDIR_AM
fi
echo generating am model files ...
./make_am_models.sh
echo computing am models ...
./run_am_models.sh

# Generate plots.  Note that the water vapor profile plots use the am runs
# to get data for the pwv labels.
echo generating profile plots ...
./profile_plots.sh
echo plotting model spectra ...
./plot_model_spectra.sh
echo done.
