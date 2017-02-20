#IFNDEF _CAMERA_BI_
#DEFINE _CAMERA_BI_

type Camera
    as single x,y
    as single speed
    as single zoom
    as single zoomSpeed
end type

function cameraSetup(x as single, y as single, speed as integer = 1, zoom as single = 0.1, zoomSpeed as single = 0.01) as Camera
    dim as Camera cam
    cam.x = x
    cam.y = y
    cam.speed = speed
    cam.zoom = zoom
    cam.zoomSpeed = zoomSpeed
    return(cam)
end function

sub camMoveNorth(cam as Camera)
    cam.y-=cam.speed/cam.zoom
end sub

sub camMoveSouth(cam as Camera)
    cam.y+=cam.speed/cam.zoom
end sub

sub camMoveEast(cam as Camera)
    cam.x+=cam.speed/cam.zoom
end sub

sub camMoveWest(cam as Camera)
    cam.x-=cam.speed/cam.zoom
end sub

sub camZoomIn(cam as Camera)
    cam.zoom+=cam.zoomSpeed*cam.zoom
end sub

sub camZoomOut(cam as Camera)
    cam.zoom-=cam.zoomSpeed*cam.zoom
end sub
#ENDIF