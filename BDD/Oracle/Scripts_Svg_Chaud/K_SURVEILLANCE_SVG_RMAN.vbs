'**********************************************************************************
'*                   SCRIPT DE SURVEILLANCE ORACLE RMAN ET EXPORT                 *
'**********************************************************************************
'----------------------------------------------------------------------------------
'Modifi� par JG 16/06/2015 - Cette version est totalement g�n�rique
'----------------------------------------------------------------------------------
'Objectif - Script envoie un mail les 10 derniers r�sultat de la sauvegarde RMAN 
'Objectif - + la pr�sence de l'export dans le stockage distant

'Variable Rep_svg : R�pertoire distant des donn�es oracles
'Variable readfile : Variable n�cessaire � la lecture du fichier k_survey_rman_ORACLE_SID.log"
'Variable K_SURVEY_RMAN : Script de surveillance des sauvegardes RMAN
'Variable K_SURVEY_RMAN_LOG : Log de la surveillance des sauvegardes RMAN
'Variable Coef_jour_sec : Nombre de seconde dans une journ�e
'Variable Seuil_age_svg : Seuil d�anomalie � ne pas d�passer entre les datafiles
'Variable Export : nom du fichier de l'export Oracle avec son extension
'Varaible Oracle_Sid : Oracle SID de l'instance ORACLE
'Variable TaillePolice : Taille de la police d��criture dans le mail
'Variable SMTP : Adresse IP du serveur de mail
'Variable mailTo : Adresse mail du r�cepteur du mail
'Variable mailFrom : Adresse IP de l�envoyeur (Peut-�tre inexistante)
'Variable mailSubject : Objet du mail
'Variable Rep_Scripts : R�pertoire des scripts

'########D�claration des variables########
dim Rep_svg
dim readfile
dim K_SURVEY_RMAN
dim K_SURVEY_RMAN_LOG

'########D�claration des constantes########
Const Coef_jour_sec	= 86400
Const Seuil_age_svg	= 2
Const Export		= "Export_X111.dmp"
Const Oracle_Sid	= "X111"
Const SMTP			= "192.168.0.53"
Const TaillePolice	= 3
Const mailTo		= "Olivier.DEIRMENDJIAN@kardol.fr;pjousse@fermob.com"
'Const mailTo		= "regis.camy@kardol.Fr"
Const mailFrom		= "Surveillance RMAN <informatique@fermob.com>"
Const mailSubject	= "Surveillance Sauvegarde Oracle RMAN" 
Const Rep_Scripts	= "E:\Kardol_Scripts\Scripts_Svg_Chaud\"


'########Definition des variables de type String########
Rep_svg				= "E:\oradata\X111\"
K_SURVEY_RMAN		= Rep_Scripts & "K_survey_rman.ps1"
K_SURVEY_RMAN_LOG 	= Rep_Scripts & "logs\k_survey_rman_"& ORACLE_SID & ".log"

Set FSO 						= CreateObject("Scripting.FileSystemObject")
Set Con							= CreateObject("ADODB.Connection")
Set objConfig					= CreateObject("CDO.Configuration")
Set Fields						= objConfig.Fields
Set objMessage 					= CreateObject("CDO.Message")
Set objMessage.Configuration 	= objConfig
Set WshShell 					= WScript.CreateObject("WScript.Shell")


Const cdoSendUsingMethod		= "http://schemas.microsoft.com/cdo/configuration/sendusing"
Const cdoSendUsingPort			= 2
Const cdoSMTPServer				= "http://schemas.microsoft.com/cdo/configuration/smtpserver"
Const cdoSMTPServerPort			= "http://schemas.microsoft.com/cdo/configuration/smtpserverport"
Const cdoSMTPConnectionTimeout	= "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout"
Const cdoSMTPAuthenticate		= "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate"
Const CdoAnonymous				= 0  ' pas d'authentification
Const CdoBasic					= 1  ' authentification en clair
Const CdoNTLM					= 2  ' authentification NT
Const cdoSendUserName			= "http://schemas.microsoft.com/cdo/configuration/sendusername"
Const cdoSendPassword			= "http://schemas.microsoft.com/cdo/configuration/sendpassword"


With Fields
    .Item(cdoSendUsingMethod)		= cdoSendUsingPort
    .Item(cdoSMTPServer)			= SMTP
    .Item(cdoSMTPServerPort)		= 25
    .Item(cdoSMTPConnectionTimeout)	= 20
    .Item(cdoSMTPAuthenticate)		= cdoAnonymous
    .Update
End With

Function Verif_svg(fic_svg)
	Msg = ""
	If FSO.FileExists(Rep_svg&"\" & fic_svg )=true then
		set fichier = FSO.GetFile(Rep_svg&"\" & fic_svg )
		Delta = DateDiff ("s",fichier.DateLastModified, Now() )
 		If Delta > (Seuil_age_svg * Coef_jour_sec) Then
			Msg = Msg & "Fichier " & fic_svg & " pr�sent mais p�rim� (Age:"& round(Delta/Coef_jour_sec,1) &" jours   Seuil:"& Seuil_age_svg &" jours)" & vbcrlf 
		End if
	else 	
		Msg = Msg & "Fichier "& fic_svg &" manquant" & vbcrlf	
	end if
	Verif_svg = Msg
End function

sub Liste_df ()
	Msg = ""
	Msg = Msg & Verif_svg(Export)
	If Msg & "e" <> "e" then
	Else 
		Msg="Contr�le du Fichier EXPORT : pr�sent " & vbcrlf & "Il est stock� dans le r�pertoire " & Rep_svg & vbcrlf
	End If
	'WshShell.Run K_SURVEY_RMAN, 1, true
	WshShell.Run "powershell -executionpolicy bypass -windowstyle hidden -file " & K_SURVEY_RMAN
		set readfile = FSO.OpenTextFile(K_SURVEY_RMAN_LOG, 1, false) 
	do while readfile.AtEndOfStream=false 
	Msg = Msg & readfile.ReadLine & vbcrlf
	loop 
	readfile.close
	Envoi_mail(Msg)

End sub

Sub envoi_mail(msg)
	Msg=replace(Msg,vbcrlf,"<BR>")
	With objMessage
	    .To				= mailTo
	    .From			= mailFrom
	    .Subject		= mailSubject 
	    .HTMLBody		= "<Font size="& TaillePolice & "> "& Msg & "</font>"
	    .Send
	End With
	Set objMessage	= Nothing
End Sub

Liste_df


set Con			= Nothing
Set Fields		= Nothing
Set objConfig	= Nothing
Set Rep_svg		= Nothing
Set WshShell	= Nothing
Set readfile	= Nothing
