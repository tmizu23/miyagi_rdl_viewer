
@echo off
setlocal enabledelayedexpansion
chcp 65001

REM dataフォルダの中のcsvファイルを結合してdata.csvを作成

set /a counter=0

del data.csv
for /f %%i in ('dir /b /s *.csv') do (

    echo %%i
    if !counter!==0 (
        set /p _head=<%%i
        echo !_head!>>data.csv
    )
    set /a counter=!counter!+1

    for /f "tokens=* skip=1" %%b in (%%i) do (
        echo %%b>>data.csv
    )
)

REM data.csvとmesh2R,mesh3Rを結合してall.fgbを作成

REM QGISの場所を指定してください
call "C:\Program Files\QGIS 3.16.16\bin\o4w_env.bat"

cd %~dp0
nkf32.exe -w8 --overwrite data.csv

ogr2ogr -f FlatGeobuf -dialect sqlite -sql "select distinct * from mesh3R join 'data.csv'.data as data on ( mesh3R.code LIKE data.mesh3R OR (mesh3R.code LIKE data.mesh2R || '__' AND data.mesh3R='-1' ) )" -nln data3R 全分類.fgb mesh3R.fgb
ogr2ogr -f FlatGeobuf  -where class='鳥類' 鳥類.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='汽水・淡水魚類' 汽水・淡水魚類.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='哺乳類' 哺乳類.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='両生類' 両生類.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='爬虫類' 爬虫類.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='植物' 植物.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='蘚苔類' 蘚苔類.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='淡水貝類' 淡水貝類.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='昆虫類' 昆虫類.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='海岸動物' 海岸動物.fgb 全分類.fgb
ogr2ogr -f FlatGeobuf  -where class='植物群落' 植物群落.fgb 全分類.fgb
