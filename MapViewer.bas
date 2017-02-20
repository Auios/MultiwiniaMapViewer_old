#include "fbgfx.bi"
#include "aulib.bi"

#include "crt.bi"

#include "Map.bi"
#include "Camera.bi"

using fb, aulib

dim shared as boolean runApp = true
dim shared as boolean landscapeOutline = true

dim as zstring ptr ptr argv
dim as string fileName

if(__FB_ARGC__ > 1) then
    argv = __FB_ARGV__
    fileName = *argv[1]
else
    input "File: ",filename
end if

printf(!"Reading map...\n")
dim shared as Map map
map = mapRead(fileName)

printf(!"Setting up window...\n")
dim shared as Camera cam
cam = cameraSetup(map.worldSizeX/2,map.worldSizeZ/2,1,0.1)

dim shared as AuWindow wnd
wnd = AuWindowSet()
AuWindowCreate(wnd)

printf(!"Rendering...\n")
while(runApp)
    dim as string k = inkey()
    if(k = chr(27)) then runApp = false
    if(k = " ") then cam = cameraSetup(map.worldSizeX/2,map.worldSizeZ/2,2,0.3)
    
    if(multikey(sc_w)) then camMoveNorth(cam)
    if(multikey(sc_s)) then camMoveSouth(cam)
    if(multikey(sc_a)) then camMoveWest(cam)
    if(multikey(sc_d)) then camMoveEast(cam)
    
    if(multikey(sc_up)) then camZoomIn(cam)
    if(multikey(sc_down)) then camZoomOut(cam)
    
    screenLock()
        'Clear
        cls()
        
        'Background box
        line(cam.zoom*-cam.x+wnd.wdth/2,cam.zoom*-cam.y+wnd.hght/2)-_
        (cam.zoom*(map.worldSizeX-cam.x)+wnd.wdth/2,cam.zoom*(map.worldSizeZ-cam.y)+wnd.hght/2),rgb(54, 101, 175),bf
        line(cam.zoom*-cam.x+wnd.wdth/2,cam.zoom*-cam.y+wnd.hght/2)-_
        (cam.zoom*(map.worldSizeX-cam.x)+wnd.wdth/2,cam.zoom*(map.worldSizeZ-cam.y)+wnd.hght/2),rgb(255,255,255),b
        
        'Landscape tiles
        for lst_scan as integer = 0 to map.landscapeTilesCount-1
            circle(_
            cam.zoom * (map.tile[lst_scan].x-cam.x+map.tile[lst_scan].size/2)+(wnd.wdth/2),_
            cam.zoom * (map.tile[lst_scan].z-cam.y+map.tile[lst_scan].size/2)+(wnd.hght/2)),_
            map.tile[lst_scan].size/2.1*cam.zoom,rgb(193, 183, 104),,,,f
        next lst_scan
        
        'Landscape tiles outlines
        if(landscapeOutline) then
            for lst_scan as integer = 0 to map.landscapeTilesCount-1
                line(cam.zoom * (map.tile[lst_scan].x-cam.x)+(wnd.wdth/2),_
                    cam.zoom * (map.tile[lst_scan].z-cam.y)+(wnd.hght/2))-_
                    (cam.zoom * (map.tile[lst_scan].x-cam.x)+(wnd.wdth/2)+map.tile[lst_scan].size*cam.zoom,_
                    cam.zoom * (map.tile[lst_scan].z-cam.y)+(wnd.hght/2)+map.tile[lst_scan].size*cam.zoom),_
                    rgb(91, 88, 60),b
            next lst_scan
        end if
        
        'Flat tiles
        dim as single flatTileSize = 1
        for lft_scan as integer = 0 to map.landFlattenTilesCount-1
            line(cam.zoom * (map.tile[lft_scan].x-cam.x+map.tile[lft_scan].size/2)+(wnd.wdth/2),_
            cam.zoom * (map.tile[lft_scan].z-cam.y+map.tile[lft_scan].size/2)+(wnd.hght/2))-_
            (cam.zoom * (map.tile[lft_scan].x-cam.x+map.tile[lft_scan].size/2)+(wnd.wdth/2),_
            cam.zoom * (map.tile[lft_scan].z-cam.y+map.tile[lft_scan].size/2)+(wnd.hght/2)),_
            rgb(214, 207, 154),bf
'            line(cam.zoom * (map.flatTile[lft_scan].x-cam.x-(map.flatTile[lft_scan].size/2)*flatTileSize)+(wnd.wdth/2),_
'                cam.zoom * (map.flatTile[lft_scan].z-cam.y-(map.flatTile[lft_scan].size/2)*flatTileSize)+(wnd.hght/2))-_
'                (cam.zoom * (map.flatTile[lft_scan].x-cam.x-(flatTileSize*map.flatTile[lft_scan].size/2)*flatTileSize)+(wnd.wdth/2)_
'                +(map.flatTile[lft_scan].size*flatTileSize+map.flatTile[lft_scan].size/2)*cam.zoom,_
'                cam.zoom * (map.flatTile[lft_scan].z-cam.y-(flatTileSize*map.flatTile[lft_scan].size/2)*flatTileSize)+(wnd.hght/2)_
'                +(map.flatTile[lft_scan].size*flatTileSize+map.flatTile[lft_scan].size/2)*cam.zoom),_
'                rgb(214, 207, 154),bf
        next lft_scan
        
        'Buildings
        dim as uinteger buildingColor
        for b_scan as integer = 0 to map.buildingsCount-1
            
            select case map.building[b_scan].team
            case 0
                'Red
                buildingColor = rgb(204, 40, 40)
            case 1
                'Blue
                buildingColor = rgb(27, 20, 252)
            case 2
                'Green
                buildingColor = rgb(51, 165, 116)
            case 3
                'Yellow
                buildingColor = rgb(242, 242, 41)
            case else
                'Other
                buildingColor = rgb(107, 107, 107)
            end select
            
            select case map.building[b_scan].type
            case "SpawnPoint"
                circle(_
                cam.zoom * (map.building[b_scan].x-cam.x)+(wnd.wdth/2),_
                cam.zoom * (map.building[b_scan].z-cam.y)+(wnd.hght/2)),_
                35*cam.zoom,buildingColor,,,,f
            end select
        next b_scan
        
    screenUnlock()
    
    sleep(1,1)
wend

printf(!"Closing application...\n")