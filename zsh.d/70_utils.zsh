function 7zip {
7zr a -t7z -m0=lzma -mx=9 $1.7z $1
}

function frget {
wget https://www.dropbox.com/sh/v9xh0fl7t84ik5q/AAByzbX9zPGgq9VsvpVTpRAIa/flightroute-icao.zip
unzip flightroute-icao.zip
rm flightroute-icao.zip
}
