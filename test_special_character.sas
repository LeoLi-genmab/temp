%init;


/*A. Changing the Encoding of the Session*/
/*Check the encoding for current session*/
proc options option=encoding;
run;

/*Change sasv9.cfg can change Encoding of your system. Now the system is already using UTF-8. No change needed*/



/*B. Changing the Encoding of the Library. Working*/
libname inlib cvp '/cdrdata/Programming/GEN1046/GCT1046-01_csr-01_dev_soli/csr-01/sdtm/tmp' inencoding='wlatin1';
libname outlib "/cdrdata/Programming/GEN1046/GCT1046-01_csr-01_dev_soli/csr-01/sdtm" outencoding='UTF-8';

proc copy noclone in=inlib out=outlib;
run;
proc contents data=outlib._all_; run;

data test1;
	set outlib.dv;
run;


/*Try proc migrate. Not working*/
libname inlib2  '/cdrdata/Programming/GEN1046/GCT1046-01_csr-01_dev_soli/csr-01/sdtm/tmp' inencoding='wlatin1';
libname outlib2 "/cdrdata/Programming/GEN1046/GCT1046-01_csr-01_dev_soli/csr-01/sdtm" outencoding='UTF-8';

proc migrate in=inlib2 out=outlib2;
run;


/*Try libname. Working*/
libname sdtm (sdtm) inencoding="WLATIN1" outencoding="utf-8";
data test2;
	set inlib.dv;
run;


/*C. Changing the Encoding of the SAS Dataset. Working*/
%let dsn=sdtm.cm;
%let dsid=%sysfunc(open(&dsn,i));
%put &dsn ENCODING is: %sysfunc(attrc(&dsid,encoding));
%let dsid=%sysfunc(close(&dsid));


 data work.test3(encoding='utf-8');
      set inlib.dv;
 run;

/*Not working, special characters are not shown properly*/
 data work.test4;
      set inlib.dv (encoding='asciiany');
 run;