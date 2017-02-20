#include "fbgfx.bi"
#include "aulib.bi"

#include "Map.bi"

using fb, aulib

dim shared as Map map

map = mapRead("mp_domination_aufields.txt")

print "Name                :",map.name
for i as integer = 0 to map.gameTypesCount-1
print "Gametype            :",map.gameType[i]
next i
for i as integer = 0 to map.invalidCratesCount-1
print "Invalid Crate       :",map.invalidCrate[i]
next i
for i as integer = 0 to map.levelOptionsCount-1
print "Option              :",map.levelOption[i]
next i
print "Population          :",map.populationCap
print "Defender Population :",map.defenderPopulationCap
print "NumPlayers          :",map.numPlayers
print "Difficulty          :",map.difficulty
print "Official            :",map.officialLevel
print "worldSizeX          :",map.worldSizeX
print "worldSizeZ          :",map.worldSizeZ
print "cellSize            :",map.cellSize
print "outsideHeight       :",map.outsideHeight
print "landColourFile      :",map.landColourFile
print "wavesColourFile     :",map.wavesColourFile
print "waterColourFile     :",map.waterColourFile

sleep()
cls()

print "x             :",map.tile[0].x
print "y             :",map.tile[0].y
print "z             :",map.tile[0].z
print "size          :",map.tile[0].size
print "fracDim       :",map.tile[0].fracDim
print "heightScale   :",map.tile[0].heightScale
print "desiredHeight :",map.tile[0].desiredHeight
print "genMethod     :",map.tile[0].genMethod
print "seed          :",map.tile[0].seed
print "lowLandSmooth :",map.tile[0].lowLandSmooth
print "guideGrid     :",map.tile[0].guideGrid

print map.landscapeTilesCount

sleep()
cls()