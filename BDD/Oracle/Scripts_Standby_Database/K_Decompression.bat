rem **********************************************************************************
rem *                SCRIPT DE COMPRESSION DES ARCHIVESLOGS X3                       *
rem **********************************************************************************
rem ----------------------------------------------------------------------------------
rem Cr�� par OC 21/09/2014 		- Cr�ation
rem Modifi� par JG 15/12/2014	- Cette version est totalement g�n�rique
rem Modifi� par JG 03/02/2015	- Ajout d'un contr�le sur le Forfiles.exe d�j� existant
rem Modifi� par JG 03/02/2015	- Annule modification pr�c�dente
rem ----------------------------------------------------------------------------------
rem Objectif - Effectue la d�compression des archivelogs
rem 
rem Pr� requis : Installation de 7zip 64bit dans le r�pertoire C:\Program Files\7-ZIP\
rem
rem Fonctionnement : 
rem		Le script d�compresse les fichiers 7Zip dans le r�pertoire des Archivelogs.
rem		Les fichiers � d�compresser doivent �tre dans %SVGSOURCE%\ZIP

Set ZIPFOLDER=%1
Set DESTFOLDER=%2
Set CTRLFOLDER=%3
rem Set colProcessListFORFILES 		= objWMIService.ExecQuery ("Select * from Win32_Process Where Name = 'FORFILES.EXE'")

rem +----- D�but d�compression des fichiers -----+

rem For Each objProcess In colProcessListFORFILES
rem	WScript.Quit
rem Next

cd /D %ZIPFOLDER%
 FORFILES /p %ZIPFOLDER% /M *.7z /C "cmd /c if not exist %CTRLFOLDER%\@FNAME ^0x22C:\Program^ Files\7-ZIP\7z.exe^0x22 x %ZIPFOLDER%\@file -o%DESTFOLDER% -aos"

rem +----- Fin d�compression des fichiers -----+