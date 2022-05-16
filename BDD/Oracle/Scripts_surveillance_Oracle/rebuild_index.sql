--- Modif JG Mars 2015		- V�rification si l'index est de type LOB. Si oui, on le s�lectionne pas.
--- Modif MB f�vrier 2007	- Annule modif QUALEA. Conserve la pr�cision du tablespaces index
--- Modif QUALEA mars 2006	- Ce script ex�cute directement les alter index sans passer par un fichier interm�diaire

set newpage 0
set space 0
set linesize 80
set pagesize 0
set echo off
set feedback off
set heading off

spool &2;
select 'alter index '||index_name||' rebuild tablespace &1 ;' from user_indexes where index_type<>'LOB';
spool off;
exit