#!/bin/sh

# works with GMT 5.x

OUT=kerch
# -R[unit]xmin/xmax/ymin/ymax[r] (more ...)
TOPO_RECT=35.0/38.0/43.0/46.0
IMG_RECT=36.0/36.8/44.7/45.5
# (Transverse Mercator)
PROJ=T36/10
GMT=gmt

# To plot a green Africa with white outline on blue background, with
# permanent major rivers in thick blue pen, additional major rivers in
# thin blue pen, and national borders as dashed lines on a ${PROJ} map
${GMT} pscoast -R${IMG_RECT} -J${PROJ} -Dh -Ba0g4 -I1/1p,blue -N1/0.25p,- \
       -I2/0.25p,blue -W0.25p,white -Ggreen -Sblue -P -K > ${OUT}.ps

# Отримання берегової лінії в районі карти з високою роздільною
# здатністю для подальшого аналізу
if [ ! -f kerch_coast.gmt ] ; then
    ${GMT} pscoast -R${IMG_RECT} -Dh -W -M > kerch_coast.gmt
fi

# Територіальні води України, лінія створена в qGIS як "Буферна зона"
# інструментами MMQGIS, зайві лінії прибрані, залишено лише та частина
# морського кордону, яка стосується даної події. Буфер на відстані
# 22,2 км від берегової лінії. Берегова лінія отримана з даних pscoast
# в файл kerch_coast.gmt (див. вище)
${GMT} psxy ukraine_maritime_zone_22_2km_kerch.gmt -R${IMG_RECT} -J${PROJ} \
       -Wgreen -O -K >> ${OUT}.ps

iconv -t ISO-8859-5 < points.txt > points_iso.txt

# ${GMT} gmtset PS_CHAR_ENCODING ISO-8859-5

${GMT} psxy points_iso.txt -J${PROJ} -R${IMG_RECT} \
       -Ss0.08c -G245/45/45 -P -K -O >>${OUT}.ps
${GMT} pstext points_iso.txt -J${PROJ} -R${IMG_RECT} \
       -Dj0.08c/0.08c -F+f+a+j -P -O >> ${OUT}.ps

# finish proessing, convert output data to a more portable format
${GMT} psconvert -Tf -P -A ${OUT}.ps

# конвертування в формат JPEG
convert -density 150 ${OUT}.pdf -flatten -trim -antialias kerch_incident.png
echo check kerch_incident.png
