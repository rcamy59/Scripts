'Script servant � activer la base standby pour test et n'affectant pas la base primary
'Attention, apr�s avoir utilis� ce script, il faut recr�er la standby

set Shell = WScript.CreateObject("WScript.Shell")
Shell.Run("cscript Standby.vbs activation_test")

