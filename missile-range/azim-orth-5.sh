#!/bin/sh

# Example 5 from http://gmt.soest.hawaii.edu/doc/latest/GMT_Tutorial.html

# The azimuthal orthographic projection (-JG) is one of several
# projections with similar syntax and behavior; the one we have chosen
# mimics viewing the Earth from space at an infinite distance; it is
# neither conformal nor equal-area. The syntax for this projection is

#  -JGlon_0/lat_0/width

# where (lon_0, lat_0) is the center of the map (projection). As an
# example we will try

gmt pscoast -Rg -JG280/30/6i -Bag -Dc -A5000 -Gwhite -SDarkTurquoise -P > GMT_tut_5.ps
