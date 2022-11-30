# Gnuplot script to generate plots of MERRA-2 quantile profiles over a given
# site.  Define the following variables as gnuplot -e options when calling
# this file:
#
#   site - site name used in file names
#   site_label - site name for plot titles
#   Month - 'Jan', 'Feb', ..
#   daterange - text string like '2005-2014'
#   site_long - site longitude (positive E, negative W)
#   site_lat - site latitude (positive N, negative S)
#   psurf - surface pressure [mbar]
#   outdir - directory containing spectrum files to be plotted
#   pwv_5 - 5th percentile pwv [mm]
#   pwv_25 - 25th percentile pwv [mm]
#   pwv_50 - median pwv [mm]
#   pwv_75 - 75th percentile pwv [mm]
#   pwv_95 - 95th percentile pwv [mm]
#   T_min - minimum temperature [K]
#   T_max - maximum temperature [K]
#   xh2o_min - minimum H2O volume mixing ratio [ppm]
#   xh2o_max - maximum H2O volume mixing ratio [ppm]
#   xo3_min - minimum O3 volume mixing ratio [ppm]
#   xo3_max - maximum O3 volume mixing ratio [ppm]
#

set border 15 lw 8
set style line 1 lt 1 lw 4 ps 10 lc rgbcolor "gray0"
set style line 2 lt 2 lw 4 ps 10 lc rgbcolor "gray60"
set style line 3 lt 2 lw 4 ps 10 lc rgbcolor "gray80"
set style line 4 lt 2 lw 3 ps 10 lc rgbcolor "gray50"
set style line 5 lt 1 lw 4 ps 10 lc rgbcolor "gray0" dashtype 3

# common settings

set terminal pngcairo rounded size 1500,1500 enhanced font "Times New Roman, 36"
set size 1.0,1.0

set lmargin at screen 0.12
set tmargin at screen 0.90
set bmargin at screen 0.14
set rmargin at screen 0.88

long_txt = sprintf("%.1f %s", abs(site_long), site_long < 0.0 ? "W" : "E")
lat_txt = sprintf("%.1f %s", abs(site_lat), site_lat < 0.0 ? "S" : "N")

set title site_label.' ('.long_txt.', '.lat_txt.') ⋄ '.Month font "Times New Roman, 40"

set yrange [psurf to 0.1]
set log y
set yrange [psurf to 0.1]
set log y2
set ylabel 'Pressure [mbar]' offset 2 font "Times New Roman, 40"
set ytics nomirror
set y2label 'Approximate altitude [km]' offset -0.8 font "Times New Roman, 40" rotate by -90
set y2tics ("4.1" psurf, "17" 100, "31" 10, "48" 1, "64" 0.1)

set tics front

# Temperature

set output outdir.'/'.site.'_'.Month.'_'.daterange.'_MERRA_T_quantiles.png'

set xrange [T_min to T_max]
set xlabel 'Temperature [K]' font "Times New Roman, 40"


set label 1 "Statistics for ".daterange."\nfrom NASA MERRA-2 reanalysis" at graph 0.35,0.36 front 
set key at graph 0.34,0.28 left top reverse

plot 'temp_2' using 2:1 with filledcurves ls 3 t '5% - 95%', \
     'temp_2' using 3:1 with filledcurves ls 2 t '25% - 75%', \
     outdir.'/'.site.'_'.Month.'_'.daterange.'_MERRA_quantiles_ex.txt' using 4:1 with lines ls 1 t 'median'


set output

# Water vapor volume mixing ratio

set output outdir.'/'.site.'_'.Month.'_'.daterange.'_MERRA_H2O_quantiles.png'

set xrange [xh2o_min to xh2o_max]
set log x
set mxtics 10
set xlabel 'H_2O volume mixing ratio [ppm]' font "Times New Roman, 40"

set label 1 at graph 0.35,0.92
set key at graph 0.34,0.84 left top reverse

set style textbox opaque noborder
set label 2 "&{00 }PWV\n&{00 }[mm]\n&{0}5%    ".pwv_5."\n25%    ".pwv_25."\n50%    ".pwv_50."\n75%    ".pwv_75."\n95%    ".pwv_95 at graph 0.35,0.55  front


plot 'temp_2' using 7:1 with filledcurves ls 3 t '5% - 95%', \
     'temp_2' using 8:1 with filledcurves ls 2 t '25% - 75%', \
     outdir.'/'.site.'_'.Month.'_'.daterange.'_MERRA_quantiles_ex.txt' using 9:1 with lines ls 1 t 'median'

set output
unset label 2

# Ozone volume mixing ratio

set output outdir.'/'.site.'_'.Month.'_'.daterange.'_MERRA_O3_quantiles.png'

set xrange [xo3_min to xo3_max]
set xlabel 'O_3 volume mixing ratio [ppm]' font "Times New Roman, 40"

set label 1 at graph 0.1,0.83
set key at graph 0.09,0.74 left top reverse

plot 'temp_2' using 12:1 with filledcurves ls 3 t '5% - 95%', \
     'temp_2' using 13:1 with filledcurves ls 2 t '25% - 75%', \
     outdir.'/'.site.'_'.Month.'_'.daterange.'_MERRA_quantiles_ex.txt' using 14:1 with lines ls 1 t 'median'

set output
