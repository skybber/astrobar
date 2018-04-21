#!/bin/bash
cd "$(dirname "$0")"
(cd ../apod/ && ./apod.sh)
(cd ../meteopl && ./meteopl.sh)
(cd ../eumetsat && ./eumetsat.sh)
gm convert ../meteopl/forecast1.png  ../meteopl/forecast2.png ../eumetsat/eumetsat_cz.png ../apod/apod.png  +append astrobar.png
