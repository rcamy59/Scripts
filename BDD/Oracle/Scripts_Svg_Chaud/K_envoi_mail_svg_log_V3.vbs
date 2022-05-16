'**********************************************************************************
'*                          SCRIPT D'ENVOIE DE MAIL                               *
'**********************************************************************************
'----------------------------------------------------------------------------------
'Modifi� par JG 30/10/09 - Cette version est totalement g�n�rique
'----------------------------------------------------------------------------------
'Objectif - Script qui peut envoyer un mails avec une ou des pi�ces jointes

'Variable SMTP : Adresse IP du serveur de mail
'Variable mailTo : Adresse mail du r�cepteur du mail
'Variable mailFrom : Adresse IP de l�envoyeur (Peut-�tre inexistante)
'Variable mailSubject : Objet du mail
'Variable mailAddAttachment	 : Pi�ce jointe
'Variable mailAddAttachment2 : Utile s�il y a un Robocopy

Set FSO 			= CreateObject("Scripting.FileSystemObject")
Set Con				= CreateObject("ADODB.Connection")
Set objConfig			= CreateObject("CDO.Configuration")
Set Fields			= objConfig.Fields
Set objMessage 			= CreateObject("CDO.Message")
Set objMessage.Configuration 	= objConfig


Const SMTP		= "srvsmbdomino1"
const TaillePolice	= 3
const mailTo		= "Philippe.WITTMANN@novasep.com"
const mailFrom		= "Sauvegarde Oracle <srvsmbisis@novasep.com>"
const mailSubject	= "Sauvegarde Oracle" 
const mailAddAttachment	= "D:\Kardol_Scripts\Scripts_Svg_Chaud\logs\K_svgchaud.log" 
rem JG : Si il existe un robocopy d�commentez la ligne ci-dessous
'const mailAddAttachment2	= "D:\Kardol_Scripts\Scripts_Svg_Chaud\logs\K_robocopy.log"
const mailAddAttachment3	= "D:\Kardol_Scripts\Scripts_Svg_Chaud\logs\K_ocopy.log"
const mailAddAttachment4	= "D:\Oradata\ISISPRODDB\Exports\Export_ISISPRODDB.log"

Const cdoSendUsingMethod	= "http://schemas.microsoft.com/cdo/configuration/sendusing"

Const cdoSendUsingPickup 	= 1    ' envoi du message en utilisant un serveur smtp local au serveur
Const cdoSendUsingPort		= 2    ' envoi du message en utilisant un serveur smtp du reseau

Const cdoSMTPServer		= "http://schemas.microsoft.com/cdo/configuration/smtpserver"
Const cdoSMTPServerPort		= "http://schemas.microsoft.com/cdo/configuration/smtpserverport"
Const cdoSMTPConnectionTimeout	= "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout"
Const cdoSMTPAuthenticate	= "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate"
Const CdoAnonymous		= 0  ' pas d'authentification
Const CdoBasic			= 1  ' authentification en clair
Const CdoNTLM			= 2  ' authentification NT


Const cdoSendUserName		= "http://schemas.microsoft.com/cdo/configuration/sendusername"
Const cdoSendPassword		= "http://schemas.microsoft.com/cdo/configuration/sendpassword"


With Fields
'attention la variable si apr�s utilise un serveur smtp present sur le r�seau mettre = cdoUsingPickup pour utiliser le smtp local
    .Item(cdoSendUsingMethod)	= cdoSendUsingPort
    .Item(cdoSMTPServer)		= SMTP
    .Item(cdoSMTPServerPort)		= 25
    .Item(cdoSMTPConnectionTimeout)	= 20

' ATTENTION AU CHOIX D'AUTHENTIFICATION   par d�faut choix de qualea cdobasic   pour serveur exchange il faut CdoNTLM
' MB : en cas de probl�me on peut avoir un message 'server unavailable'
' MB : dans certains cas, peut aussi fonctionner sans rien d�finir, --> ligne ci-dessous en commentaire
' AGC : changement de la valeur par d�faut en CdoAnonymous
    .Item(cdoSMTPAuthenticate)		= CdoAnonymous
    .Update
End With


' modif MB 30/09/09 pour utiliser des variables d�finies en t�te de script
Sub envoi_mail(msg)
	Msg=replace(Msg,vbcrlf,"<BR>")
	With objMessage
	    .To		= mailTo
	    .From	= mailFrom
	    .Subject	= mailSubject 
	    .HTMLBody	= "<Font size="& TaillePolice & "> "& Msg & "</font>"
	    .AddAttachment(mailAddAttachment)
'	    .AddAttachment(mailAddAttachment2)
	    .AddAttachment(mailAddAttachment3)
	    .AddAttachment(mailAddAttachment4)
	    .Send
	End With
	
	
	Set objMessage	= Nothing
End Sub


envoi_mail("Rapport de sauvegarde")


Set Fields	= Nothing
Set objConfig	= Nothing