# Gnuplot script to generate plots of am model spectra based on MERRA-2 profiles
# over a given site.
#
# Define the following variables as gnuplot -e options when calling this
# file:
#
#   Month - 'Jan', 'Feb', ..
#   site - name of site
#   site_long - site longitude (positive E, negative W)
#   site_lat - site latitude (positive N, negative S)
#   f_min - minimum frequency [GHz]
#   f_max - maximum frequency [GHz]
#   outdir - directory containing spectrum files to be plotted
#   pwv_25 - 25th percentile pwv [mm]
#   pwv_50 - median pwv [mm]
#   pwv_75 - 75th percentile pwv [mm]
#

set border 15 lw 8
set style line 1 lt 1 lw 4 ps 10 lc rgbcolor "gray0"
set style line 2 lt 1 lw 4 ps 10 lc rgbcolor "gray70"
set style data lines

# common settings

set terminal pngcairo rounded size 1620,1620 enhanced font "Times New Roman, 40"
set size 1.0,1.0

set lmargin at screen 0.12
set tmargin at screen 0.92
set bmargin at screen 0.12
set rmargin at screen 0.92

long_txt = sprintf("%.1f %s", abs(site_long), site_long < 0.0 ? "W" : "E")
lat_txt = sprintf("%.1f %s", abs(site_lat), site_lat < 0.0 ? "S" : "N")

unset key

set tics front

# Zenith Transmittance

set output outdir.'/'.site.'_'.Month.'_tx.png'

set title site_label.' ('.long_txt.', '.lat_txt.') ⋄ '.Month.' Transmittance Quartiles' font "Times New Roman, 44"

set yrange [0.0 to 1.0]
set ylabel 'Zenith Transmittance' offset 1.5 font "Times New Roman, 44"
set xrange [f_min to f_max]
set xlabel 'Frequency [GHz]' font "Times New Roman, 44"

set object 1 rectangle from graph 0.55,0.73 to graph 0.6,0.87 fc rgbcolor "gray70"
set arrow 1 from graph 0.55,0.8 to graph 0.6,0.8 nohead ls 1
set label 1 "PWV [mm]" at graph 0.61,0.94 left front
set label 2 pwv_25." (25%)" at graph 0.61,0.87 left front
set label 3 pwv_50." (median)" at graph 0.61,0.8 left front
set label 4 pwv_75." (75%)" at graph 0.61,0.73 left front

plot \
    outdir.'/'.site.'_'.Month.'_25_75.out' using 1:3:8 with filledcurves ls 2, \
    outdir.'/'.site.'_'.Month.'_50.out' using 1:3 ls 1

set output

# Zenith Tb

set output outdir.'/'.site.'_'.Month.'_Tb.png'

set title site_label.' ('.long_txt.', '.lat_txt.') ⋄ '.Month.' T_{b} quartiles' font "Times New Roman, 44"

set yrange [0 to 300] 
set ylabel 'Brightness temperature [K]' offset 1.5 font "Times New Roman, 44"
set xrange [f_min to f_max]
set xlabel 'Frequency [GHz]' font "Times New Roman, 44"

set object 1 from graph 0.55,0.1 to graph 0.6,0.24
set arrow 1 from graph 0.55,0.17 to graph 0.6,0.17
set label 1 at graph 0.61,0.31
set label 2 at graph 0.61,0.1
set label 3 at graph 0.61,0.17
set label 4 at graph 0.61,0.24

plot \
    outdir.'/'.site.'_'.Month.'_25_75.out' using 1:5:10 with filledcurves ls 2, \
    outdir.'/'.site.'_'.Month.'_50.out' using 1:5 ls 1

set output
