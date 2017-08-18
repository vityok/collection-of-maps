#!/bin/sh

# [[:w:Піренейський півострів|Піренейський (або Іберійський)
# півострів]]&nbsp;— найбільший у Південній Європі. Топографічну карту
# цього півострова будемо створювати на основі двох наборів даних:
# [[Звідки взяти дані для географічних карт#ETOPO1|ETOPO1]] (для
# суходолу) та [[Звідки взяти дані для географічних карт#GLOBE|GLOBE]]
# (для океанського дна). На відміну від попереднього прикладу, тут вже
# присутні значні текстові фрагменти на карті, тому дуже важливо
# правильно розібратись з [[#Підтримка кирилиці|підтримкою кирилічних
# шрифтів]].

TOPO_RECT=-15/10/30/50
IMG_RECT=-10.75/34.5/5.5/45r
PROJ=L-3/40/38/42/18c

# GMT gmtset CHAR_ENCODING ISO-8859-5

# підготовка даних: склеювання окремих сегментів даних GLOBE та
# створення витягу з даних ETOPO1
GMT grdpaste f10g.grd g10g.grd -Gih_land.grd
GMT grdgradient ih_land.grd -A135 -Ne0.2 -Gih_gradient.grd
GMT grdcut ETOPO1_Ice_c_gmt4.grd -R${TOPO_RECT} -Gih_sea.grd

# створення гіпсометричної карти океанського дна, суходолу та
# застосування ефекту відмивки до суходолу
GMT grdimage ih_sea.grd -Cih_sea.cpt -J${PROJ} -R${IMG_RECT} \
             -E300 -X1.5c -Y8.5c -P -K >ih.ps
GMT pscoast -J${PROJ} -R${IMG_RECT} -Gc -Dh -P -K -O >>ih.ps
GMT grdimage ih_land.grd -Iih_gradient.grd -Cih_land.cpt \
             -J${PROJ} -R${IMG_RECT} -P -K -O >>ih.ps
GMT pscoast -J${PROJ} -R${IMG_RECT} -Q -K -O >>ih.ps
GMT pscoast -J${PROJ} -R${IMG_RECT} -Ba0g4 -W0.25p,9/120/171 \
            -Ia/0.25p,9/120/171 -I1/0.5p,9/120/171 -I2/0.5p,9/120/171 \
            -N1/0.75p,100/100/100 -Dh -P -K -O --FRAME_PEN=0.8p \
            --GRID_PEN_PRIMARY=0.25p,9/120/171 >>ih.ps

# нанесення координатної сітки
GMT psbasemap -J${PROJ} -R${IMG_RECT} -Ba4g0SN -Xa-0.2c -Ya0c -P -K -O \
              --ANNOT_FONT_PRIMARY=1 --ANNOT_FONT_SIZE_PRIMARY=6p \
              --OBLIQUE_ANNOTATION=6 --PLOT_DEGREE_FORMAT=ddd:mm:ss \
              --BASEMAP_FRAME_RGB=+9/120/171 --FRAME_PEN=0p,0_100:0p \
              --TICK_PEN=0p,0_100:0p --TICK_LENGTH=-0.45c >>ih.ps
GMT psbasemap -J${PROJ} -R${IMG_RECT} -Ba4g0WE -Xa0c -Ya0.2c -P -K -O \
              --ANNOT_FONT_PRIMARY=1 --ANNOT_FONT_SIZE_PRIMARY=6p \
              --OBLIQUE_ANNOTATION=6 --PLOT_DEGREE_FORMAT=ddd:mm:ss \
              --BASEMAP_FRAME_RGB=+9/120/171 --FRAME_PEN=0p,0_100:0p \
              --TICK_PEN=0p,0_100:0p --TICK_LENGTH=-0.55c >>ih.ps

# нанесення відміток міст з різною кількістю населення
GMT psxy ih_cities_1_iso.txt ih_cities_2_iso.txt -J${PROJ} -R${IMG_RECT} \
          -Ss0.18c -G204/0/0 -W0.5p -P -K -O >>ih.ps
GMT psxy ih_cities_1.txt -J${PROJ} -R${IMG_RECT} \
          -Ss0.06c -G0/0/0 -P -K -O >>ih.ps
GMT psxy ih_cities_3.txt -J${PROJ} -R${IMG_RECT} \
         -Sc0.12c -G204/0/0 -W0.5p -P -K -O >>ih.ps
GMT psxy ih_hoehen_1.txt -J${PROJ} -R${IMG_RECT} \
         -St0.08c -G0/0/0 -P -K -O >>ih.ps
GMT psxy ih_hoehen_2.txt -J${PROJ} -R${IMG_RECT} \
         -Sc0.04c -G0/0/0 -P -K -O >>ih.ps
GMT psxy ih_hoehen_3.txt -J${PROJ} -R${IMG_RECT} \
         -Si0.08c -G9/120/171 -P -K -O >>ih.ps

# нанесення назв міст
GMT pstext ih_cities_1_iso.txt ih_cities_2_iso.txt \
           -J${PROJ} -R${IMG_RECT} -Dj0.08c/0.08c -P -K -O >>ih.ps
GMT pstext ih_cities_3_iso.txt -J${PROJ} -R${IMG_RECT} \
           -Dj0.06c/0.06c -P -K -O >>ih.ps
GMT pstext ih_hoehen_1_iso.txt ih_hoehen_2_iso.txt \
           -J${PROJ} -R${IMG_RECT} -Dj0c/0.08c -P -K -O >>ih.ps
GMT pstext ih_hoehen_3_iso.txt -J${PROJ} -R${IMG_RECT} \
           -G9/120/171 -Dj0c/0.08c -P -K -O >>ih.ps
GMT pstext ih_rivers_iso.txt ih_seas_iso.txt -J${PROJ} -R${IMG_RECT} \
           -G9/120/171 -P -K -O >>ih.ps
GMT pstext ih_mountains_iso.txt -J${PROJ} -R${IMG_RECT} \
           -P -K -O >>ih.ps
GMT pstext ih_countries_iso.txt -J${PROJ} -R${IMG_RECT} \
           -G100/100/100 -P -K -O >>ih.ps

# легенда карти
GMT pslegend ih_legend_1_iso.txt -J${PROJ} -R${IMG_RECT} \
             -Dx0c/0c/18c/2.5c/TL -C0.2c/0.1c -G255/255/255 \
             -F -P -K -O --FRAME_PEN=0.8p >>ih.ps
GMT pslegend ih_legend_2_iso.txt -J${PROJ} -R${IMG_RECT} \
             -Dx5.4c/0c/12.6c/2.5c/TL -C0.2c/0.15c -P -K -O \
             --ANNOT_FONT_PRIMARY=1 --ANNOT_FONT_SIZE_PRIMARY=8p >>ih.ps
GMT pslegend ih_legend_3_iso.txt -J${PROJ} -R${IMG_RECT} \
             -Dx5.4c/0c/12.6c/2.5c/TL -C0.2c/0.15c -P -K -O \
             --ANNOT_FONT_PRIMARY=1 --ANNOT_FONT_SIZE_PRIMARY=8p >>ih.ps
GMT pslegend ih_legend_4_iso.txt -J${PROJ} -R${IMG_RECT} \
             -Dx11.5c/0c/6.5c/2.5c/TL -C0.2c/0.15c -P -K -O \
             --ANNOT_FONT_PRIMARY=1 --ANNOT_FONT_SIZE_PRIMARY=8p >>ih.ps
GMT pslegend ih_legend_5_iso.txt -J${PROJ} -R${IMG_RECT} \
             -Dx14.8c/0c/3.2c/2.5c/TL -C0.2c/0.15c -P -K -O \
             --ANNOT_FONT_PRIMARY=1 --ANNOT_FONT_SIZE_PRIMARY=8p >>ih.ps
GMT pslegend ih_legend_6_iso.txt -J${PROJ} -R${IMG_RECT} \
             -Dx5.4c/-1.8c/12.6c/0.7c/TL -C0.2c/0.1c -P -K -O >>ih.ps
GMT pslegend ih_legend_7_iso.txt -J${PROJ} -R${IMG_RECT} \
             -Dx12c/-1.8c/6c/0.7c/TL -C0.2c/0.1c -P -K -O >>ih.ps

# масштаб карти, шкала глибин та висоти
GMT psbasemap -J${PROJ} -R${IMG_RECT} -Lfx2.25c/-1.75c/40/300+lкм -P -K -O \
              --LABEL_FONT=1 --LABEL_FONT_SIZE=8p \
              --ANNOT_FONT_PRIMARY=1 --ANNOT_FONT_SIZE_PRIMARY=8p >>ih.ps
GMT psscale -D9.1c/-2c/-3.7c/0.25ch -Cih_sea_scale.cpt -B/:"м": -A -L -P -K -O \
            --ANNOT_FONT_PRIMARY=1 --ANNOT_FONT_SIZE_PRIMARY=8p \
            --ANNOT_OFFSET_PRIMARY=0.15c --FRAME_PEN=0.8p --GRID_PEN_PRIMARY=0.5p \
            --TICK_LENGTH=0.1c >>ih.ps
GMT psscale -D15.5c/-2c/3.7c/0.25ch -Cih_land.cpt -B/:"м": -A -L -P -O \
            --ANNOT_FONT_PRIMARY=1 --ANNOT_FONT_SIZE_PRIMARY=8p --ANNOT_OFFSET_PRIMARY=0.15c \
            --FRAME_PEN=0.8p --GRID_PEN_PRIMARY=0.5p --TICK_LENGTH=0.1c >>ih.ps

# конвертування в формат JPEG
convert -density 150 ih.ps -flatten -trim -antialias iberia_wp.jpg
