#!/bin/sh
           fermi=$(gawk '/E-fermi/ {print $3}' OUTCAR)                      # rip fermi energy from OUTCAR
           nbands=$(gawk '/NBANDS/ {print $15}' OUTCAR)                      # rip nbands from OUTCAR
           kpts=$(gawk 'NR==2 {print $1;exit}' IBZKPT)                      # rip # of k points from IBZKPT
           nbands2='{print $nbands+2}'                                    # set line to skip    
           gawk 'NR > 8 {print $2}' EIGENVAL > band_gaptempfile1            # skip first 8 lines
           gawk -v s=$nbands2 'NR%s != 0 {print $1}' band_gaptempfile1 > band_gaptempfile2   # skip k points
           for i in `cat band_gaptempfile2` ; do                            # subtract 
           j='{print $i - $fermi}'                                        #    fermi
           echo "$j" >> band_gaptempfile3                                   #    energy
           done                                                             #    from EIGENVALS
           gawk '/<r>/ min==""|| $1 > 0 {print $1}' band_gaptempfile3 > band_gaptempfile4    # rip + eigenvals
           top=$(gawk 'min==""||min>$1{min=$1}END{print min}' band_gaptempfile4)             # cond band min
           gawk '/<r>/ max==""|| $1 < 0 {print $1}' band_gaptempfile3 > band_gaptempfile5    # rip - eigenvals
           bottom=$(gawk 'max==""||max<$1{max=$1}END{print max}' band_gaptempfile5)          # val band max
           gap='{print $top - $bottom}'                                   # calculate band gap
rm band_gaptempfile*
echo "Written for VASP versions 5.2.2 and 5.3.5"     #not guaranteed for any other version, nor for collinear calculations...
echo "Fermi energy = $fermi"
echo "Number of bands = $nbands"
echo "Number of k points = $kpts"
echo "CBM = $top"
echo "VBM = $bottom"
echo "band gap = $gap"

# This script works only for noncollinear calculations (i.e. LSORBIT = .TRUE.)
# Proceed with a band structure calculation and then run this script in the same directory as OUTCAR, IBZKPT, and EIGENVAL files.
# Written by John Petersen johnpetersen@utexas.edu (2012)

# This 2026 update ought to speed the script up dramatically. I eliminated bc_calc in favor of awk addition, which is instant.
# These loops occur on servers under submission scripts, where the core calculations take minutes, hours, or even days, and
# the extra minute was unnoticeable in my research. I may pipe the calculations to condense commands and eliminate the need for
# temp files entirely, but they serve as helpful files for debugging. This can be inserted into a loop for machine learning
# (see README).
