>ah, right, so you think you could just some 'setLineWidth(wall.thickness)' of you drawing lib.?  
#####yes I'd like that  
>##:) cute  

and qudee was born.

It's a cute, quick and dirty approach of drawing floorplans.
It handles floorplanner FML files and roomstyler RS files.
It utilizes [Pixi.js](http://www.pixijs.com/) as its rendering backend.

##usage##
click the [Choose File] button, load any file in the data folder.

##install##
`npm install` install all dependancies.

##development##
`make serve`  start running the development server 
`make watch`  start running the file watcher (also run this initially to create the build.)

##deployment##
`make uglify`  build the minified file at build/bundle.min.js

##lib folder##
- dat.gui.min.js   // GUI for changing variables
- pixi.dev.js      // PIXI JS rendering backend 
- stats.dev.min.js // FPS counter
- xml2json.js      // XML Parser (adapted slightly)

##notes##
to get the correct FML or RS data for testing purposes you follow a few steps.

Floorplanner:
- login to your floorplanner account
- point the browser to any plan in the gallery
- example `http://floorplanner.com/projects/27328614-citylights/floors/32136910-3eme-etage/designs/33582798-3eme-etage-blanc#details`
- copy paste the last number on that url (thats' the designID)
- point your browser to `http://floorplanner.com/designs/`+ designID+`.xml?target=ipad`
- final url would become : `http://floorplanner.com/designs/33582798.xml?target=ipad`
  
Roomstyler
- point your browser to any floorplan you like, hit the remix button.
- example `http://roomstyler.com/3dplanner?room_url=http://roomstyler.com/3dplanner/rooms/6394523/6409199`
- slice the part up until `room_url=` from that string.
- final url would become `http://roomstyler.com/3dplanner/rooms/6394523/6409199` 

Save the file you get in data/ , the floorplanner one as an xml, the roomstyler one as a json.
