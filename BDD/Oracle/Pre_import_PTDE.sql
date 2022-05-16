spool pre_import_ptde

drop user ptd cascade ;

CREATE USER PTD
  IDENTIFIED BY VALUES 'B1A7258B381CB7AF'
  DEFAULT TABLESPACE PTD
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
  -- 2 Roles for PTD 
  GRANT IMP_FULL_DATABASE TO PTD WITH ADMIN OPTION;
  GRANT DBA TO PTD;
  ALTER USER PTD DEFAULT ROLE ALL;
  -- 7 System Privileges for PTD 
  GRANT CREATE ANY SEQUENCE TO PTD WITH ADMIN OPTION;
  GRANT CREATE ANY TABLE TO PTD WITH ADMIN OPTION;
  GRANT UNLIMITED TABLESPACE TO PTD;
  GRANT COMMENT ANY TABLE TO PTD WITH ADMIN OPTION;
  GRANT CREATE ANY TRIGGER TO PTD WITH ADMIN OPTION;
  GRANT CREATE ANY INDEX TO PTD WITH ADMIN OPTION;
  GRANT CREATE ANY INDEXTYPE TO PTD WITH ADMIN OPTION;

quit