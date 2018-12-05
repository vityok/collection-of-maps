#!/bin/sh

# works with GMT 5.x

OUT=kerch
# -R[unit]xmin/xmax/ymin/ymax[r] (more ...)
TOPO_RECT=35.0/38.0/43.0/46.0
IMG_RECT=36.0/37.0/44.7/45.5
# (Transverse Mercator)
PROJ=T37/13c
# PROJ=U37T/10c
GMT=gmt

# To plot a green Africa with white outline on blue background, with
# permanent major rivers in thick blue pen, additional major rivers in
# thin blue pen, and national borders as dashed lines on a ${PROJ} map
${GMT} pscoast -R${IMG_RECT} -J${PROJ} -Dh -Bafg -I1/1p,blue -N1/0.25p,- \
       -I2/0.25p,lightblue -W0.25p,white -Glightgreen -Scyan \
       -P -K > ${OUT}.ps

#bisque
UA_COLOR=lightbrown
${GMT} pscoast -R${IMG_RECT} -J${PROJ} -Wfaint -N1/0.25p,- -P \
       -EUA+g${UA_COLOR} -Glightbrown -Sazure1 -Dh -K -Xc \
       --FONT_ANNOT_PRIMARY=9p \
       --FORMAT_GEO_MAP=dddF > ${OUT}.ps

# рамка для вставки карти регіону
# ${GMT} psbasemap -R${IMG_RECT} -J${PROJ} -O -K \
#       -DjTR+w1.5i+o0.15i/0.1i+stmp -F+gwhite+p1p+c0.1c+s >> ${OUT}.ps

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
       -Wblack,-  -P -O -K >> ${OUT}.ps

iconv -t ISO-8859-5 < points.txt > points_iso.txt
iconv -t ISO-8859-5 < points_ua.txt > points_ua_iso.txt
iconv -t ISO-8859-5 < points_fsb.txt > points_fsb_iso.txt
# ${GMT} gmtset PS_CHAR_ENCODING ISO-8859-5

${GMT} psxy points_ua_iso.txt -J${PROJ} -R${IMG_RECT} \
       -Sc0.18c -Gbrown -P -K -O >>${OUT}.ps
${GMT} psxy points_fsb_iso.txt -J${PROJ} -R${IMG_RECT} \
       -St0.2c -Gbrown -P -K -O >>${OUT}.ps

${GMT} pstext points_iso.txt -J${PROJ} -R${IMG_RECT} \
       -M -Dj0.08c/0.08c -F+f+a+j -P -O >> ${OUT}.ps


# finish proessing, convert output data to a more portable format
${GMT} psconvert -Tf -P -A ${OUT}.ps
# unfortunately Ghostscript no longer supports output to SVG, using
# pdf2svg instead
pdf2svg ${OUT}.pdf ${OUT}.svg

# конвертування в формат JPEG
convert -density 150 ${OUT}.pdf -flatten -trim -antialias kerch_incident.png
echo check kerch_incident.png
