#IFNDEF _BUILDING_BI_
#DEFINE _BUILDING_BI_

type Building
    as string type
    as integer ID
    as single x,z
    as integer team
    as single rx,rz
    as integer isGlobal
    
    as integer ptr link
    as integer linksCount
end type

sub buildingAddLink(building as Building, link as integer)
    building.linksCount+=1
    if(building.linksCount = 1) then
        building.link = new integer[1]
        building.link[0] = link
    else
        dim as integer ptr dataHolder = building.link
        building.link = new integer[building.linksCount]
        for i as integer = 0 to building.linksCount-2
            building.link[i] = dataHolder[i]
        next i
        building.link[building.linksCount-1] = link
    end if
end sub

#ENDIF