#IFNDEF _MAP_BI_
#DEFINE _MAP_BI_

#include "aulib.bi"

#include "LandscapeTile.bi"
#include "LandFlattenTile.bi"
#include "Building.bi"

using aulib

type Map
    as AuFile file
    as string name
    as boolean officialLevel
    as boolean coop
    as string ptr gameType
    as integer gameTypesCount
    as integer populationCap
    as integer defenderPopulationCap
    as integer numPlayers
    as string difficulty
    as string ptr invalidCrate
    as integer invalidCratesCount
    as string ptr levelOption
    as integer levelOptionsCount
    
    as integer worldSizeX
    as integer worldSizeZ
    as single cellSize
    as single outsideHeight
    as string landColourFile
    as string wavesColourFile
    as string waterColourFile
    
    as LandscapeTile ptr tile
    as integer landscapeTilesCount
    
    as LandFlattenTile ptr flatTile
    as integer landFlattenTilesCount
    
    as Building ptr building
    as integer buildingsCount
end type

sub mapAddGameType(map as Map, gametype as string)
    map.gameTypesCount+=1
    if(map.gameTypesCount = 1) then
        map.gameType = new string[1]
        map.gameType[0] = gameType
    else
        dim as string ptr dataHolder = map.gameType
        map.gameType = new string[map.gameTypesCount]
        for i as integer = 0 to map.gameTypesCount-2
            map.gameType[i] = dataHolder[i]
        next i
        map.gameType[map.gameTypesCount-1] = gameType
    end if
end sub

sub mapAddInvalidCrate(map as Map, invalidCrate as string)
    map.invalidCratesCount+=1
    if(map.invalidCratesCount = 1) then
        map.invalidCrate = new string[1]
        map.invalidCrate[0] = invalidCrate
    else
        dim as string ptr dataHolder = map.invalidCrate
        map.invalidCrate = new string[map.invalidCratesCount]
        for i as integer = 0 to map.invalidCratesCount-2
            map.invalidCrate[i] = dataHolder[i]
        next i
        map.invalidCrate[map.invalidCratesCount-1] = invalidCrate
    end if
end sub

sub mapAddLevelOption(map as Map, levelOption as string)
    map.levelOptionsCount+=1
    if(map.levelOptionsCount = 1) then
        map.levelOption = new string[1]
        map.levelOption[0] = levelOption
    else
        dim as string ptr dataHolder = map.levelOption
        map.levelOption = new string[map.levelOptionsCount]
        for i as integer = 0 to map.levelOptionsCount-2
            map.levelOption[i] = dataHolder[i]
        next i
        map.levelOption[map.levelOptionsCount-1] = levelOption
    end if
end sub

sub mapAddLandscapeTile(map as Map, tile as LandscapeTile)
    map.landscapeTilesCount+=1
    if(map.landscapeTilesCount = 1) then
        map.tile = new LandscapeTile[1]
        map.tile[0] = tile
    else
        dim as LandscapeTile ptr dataHolder = map.tile
        map.tile = new LandscapeTile[map.landscapeTilesCount]
        for i as integer = 0 to map.landscapeTilesCount-2
            map.tile[i] = dataHolder[i]
        next i
        map.tile[map.landscapeTilesCount-1] = tile
    end if
end sub

sub mapAddLandFlattenTile(map as Map, flatTile as LandFlattenTile)
    map.landFlattenTilesCount+=1
    if(map.landFlattenTilesCount = 1) then
        map.flatTile = new LandFlattenTile[1]
        map.flatTile[0] = flatTile
    else
        dim as LandFlattenTile ptr dataHolder = map.flatTile
        map.flatTile = new LandFlattenTile[map.landFlattenTilesCount]
        for i as integer = 0 to map.landFlattenTilesCount-2
            map.flatTile[i] = dataHolder[i]
        next i
        map.flatTile[map.landFlattenTilesCount-1] = flatTile
    end if
end sub

sub mapAddBuilding(map as Map, building as Building)
    map.buildingsCount+=1
    if(map.buildingsCount = 1) then
        map.building = new Building[1]
        map.building[0] = building
    else
        dim as Building ptr dataHolder = map.building
        map.building = new Building[map.buildingsCount]
        for i as integer = 0 to map.buildingsCount-2
            map.building[i] = dataHolder[i]
        next i
        map.building[map.buildingsCount-1] = building
    end if
end sub

function mapRead(fileName as string) as Map
    dim as string fileData
    dim as string delimiter = !" \t"
    dim as integer spaceIdx, tabIdx
    dim as Map map
    
    map.file = AuFileOpen(fileName, "r")
    
    fileData = AuFileReadLine(map.file)
    while(fileData <> "MultiwiniaOptions_StartDefinition")
        fileData = AuFileReadLine(map.file)
    wend
    
    fileData = AuFileReadLine(map.file)
    while(fileData <> "MultiwiniaOptions_EndDefinition")
        select case getWord(fileData, 1, delimiter)
        case "Name"
            map.name = getWord(fileData, 2, delimiter)
        case "GameTypes"
            for gameTypesScan as integer = 2 to getWordCount(fileData, delimiter)
                mapAddGameType(map, getWord(fileData, gameTypesScan, delimiter))
            next gameTypesScan
        case "InvalidCrates"
            for gameTypesScan as integer = 2 to getWordCount(fileData, delimiter)
                mapAddInvalidCrate(map, getWord(fileData, gameTypesScan, delimiter))
            next gameTypesScan
        case "LevelOptions"
            for gameTypesScan as integer = 2 to getWordCount(fileData, delimiter)
                mapAddLevelOption(map, getWord(fileData, gameTypesScan, delimiter))
            next gameTypesScan
        case "PopulationCap"
            map.populationCap = valInt(getWord(fileData, 2, delimiter))
        case "DefenderPopulationCap"
            map.defenderPopulationCap = valInt(getWord(fileData, 2, delimiter))
        case "NumPlayers"
            map.numPlayers = valInt(getWord(fileData, 2, delimiter))
        case "Difficulty"
            map.difficulty = getWord(fileData, 2, delimiter)
        case "OfficialLevel"
            map.officialLevel = true
        end select
        fileData = AuFileReadLine(map.file)
    wend
    
    fileData = AuFileReadLine(map.file)
    while(fileData <> "Landscape_StartDefinition")
        fileData = AuFileReadLine(map.file)
    wend
    
    fileData = AuFileReadLine(map.file)
    while(fileData <> "Landscape_EndDefinition")
        select case getWord(fileData, 1, delimiter)
        case "worldSizeX"
            map.worldSizeX = valInt(getWord(fileData, 2, delimiter))
        case "worldSizeZ"
            map.worldSizeZ = valInt(getWord(fileData, 2, delimiter))
        case "cellSize"
            map.cellSize = val(getWord(fileData, 2, delimiter))
        case "outsideHeight"
            map.outsideHeight = val(getWord(fileData, 2, delimiter))
        case "landColourFile"
            map.landColourFile = getWord(fileData, 2, delimiter)
        case "wavesColourFile"
            map.wavesColourFile = getWord(fileData, 2, delimiter)
        case "waterColourFile"
            map.waterColourFile = getWord(fileData, 2, delimiter)
        end select
        fileData = AuFileReadLine(map.file)
    wend
    
    fileData = AuFileReadLine(map.file)
    while(fileData <> "LandscapeTiles_StartDefinition")
        fileData = AuFileReadLine(map.file)
    wend
    
    dim as LandscapeTile tile
    fileData = AuFileReadLine(map.file)
    while(fileData <> "LandscapeTiles_EndDefinition")
        if(getWord(fileData,1,delimiter) <> "#") then
            tile.x = valInt(getWord(fileData,1,delimiter))
            tile.y = val(getWord(fileData,2,delimiter))
            tile.z = valInt(getWord(fileData,3,delimiter))
            tile.size = valInt(getWord(fileData,4,delimiter))
            tile.fracDim = val(getWord(fileData,5,delimiter))
            tile.heightScale = val(getWord(fileData,6,delimiter))
            tile.desiredHeight = valInt(getWord(fileData,7,delimiter))
            tile.genMethod = valInt(getWord(fileData,8,delimiter))
            tile.seed = valInt(getWord(fileData,9,delimiter))
            tile.lowLandSmooth = val(getWord(fileData,10,delimiter))
            tile.guideGrid = valInt(getWord(fileData,11,delimiter))
            mapAddLandscapeTile(map,tile)
        end if
        fileData = AuFileReadLine(map.file)
    wend
    
    fileData = AuFileReadLine(map.file)
    while(fileData <> "LandFlattenAreas_StartDefinition")
        fileData = AuFileReadLine(map.file)
    wend
    
    dim as LandFlattenTile flatTile
    fileData = AuFileReadLine(map.file)
    while(fileData <> "LandFlattenAreas_EndDefinition")
        if(getWord(fileData,1,delimiter) <> "#") then
            flatTile.x = valInt(getWord(fileData,1,delimiter))
            flatTile.y = val(getWord(fileData,2,delimiter))
            flatTile.z = valInt(getWord(fileData,3,delimiter))
            flatTile.size = valInt(getWord(fileData,4,delimiter))
            mapAddLandFlattenTile(map,flatTile)
        end if
        fileData = AuFileReadLine(map.file)
    wend
    
    fileData = AuFileReadLine(map.file)
    while(fileData <> "Buildings_StartDefinition")
        fileData = AuFileReadLine(map.file)
    wend
    
    dim as Building building
    fileData = AuFileReadLine(map.file)
    while(fileData <> "Buildings_EndDefinition")
        if(getWord(fileData,1,delimiter) <> "#") then
            building.type = getWord(fileData,1,delimiter)
            building.ID = valInt(getWord(fileData,2,delimiter))
            building.x = val(getWord(fileData,3,delimiter))
            building.z = val(getWord(fileData,4,delimiter))
            building.team = valInt(getWord(fileData,5,delimiter))
            building.rx = val(getWord(fileData,6,delimiter))
            building.rz = val(getWord(fileData,7,delimiter))
            building.isGlobal = val(getWord(fileData,8,delimiter))
            
            if(getWordCount(fileData,delimiter) > 8) then
                for wordScan as integer = 9 to getWordCount(fileData,delimiter)
                    buildingAddLink(building,valInt(getWord(fileData,wordScan,delimiter)))
                next wordScan
            end if
            mapAddBuilding(map,building)
        end if
        fileData = AuFileReadLine(map.file)
    wend
    
    AuFileClose(map.file)
    
    return map
end function
#ENDIF