'Ce script permet un red�marrage de la stanby suite � un arret quelqonque de la base
'a condition que cette base n'ait pas �t� red�marr�e en mode normal

set Shell = WScript.CreateObject("WScript.Shell")
Shell.Run("cscript Standby.vbs startup_standby_standard")

