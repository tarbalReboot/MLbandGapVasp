MLbandGapVasp 0.2.0

# This script works only for noncollinear calculations (i.e. LSORBIT = .TRUE.)
# Proceed with a band structure calculation and then run this script in the same directory as OUTCAR, IBZKPT, and EIGENVAL files.
# Written by John E. Petersen III, johnpetersen@utexas.edu (2012)

# Renewed interest in this research led me to update this script.
# This 2026 update ought to speed the script up dramatically. I eliminated bc_calc in favor of awk addition, which is instant.
# These loops occur on servers under submission scripts, where the core calculations take minutes, hours, or even days, and
# the extra minute was unnoticeable in my research. I may pipe the calculations to condense commands and eliminate the need for
# temp files entirely, but they serve as helpful files for debugging. This can be inserted into a loop for machine learning.
# 
# For example, exerting strain on a unit cell in one direction by altering the POSCAR multiple and comparing the band gap result
# with the previous one or two can yield a trend, and the multiple can continue in that direction or the opposite, depending on 
# how the band gap is intended to be engineered. The resulting stress **will** modify the band gap for better or for worse.
# An appropriate substrate can then be chosen for lattice matching and epitaxial growth. 

# Loop further over multiple materials, integrating into a much larger search.

# Written by John E. Petersen III, johnpetersen@utexas.edu (2012-2026)
