dnl $Id$
dnl config.m4 for extension nuodb

dnl Comments in this file start with the string 'dnl'.
dnl Remove where necessary. This file will not work
dnl without editing.

dnl If your extension references something external, use with:

PHP_ARG_WITH(nuodb, for nuodb support,
[  --with-nuodb             Include nuodb support])

dnl Otherwise use enable:

dnl PHP_ARG_ENABLE(nuodb, whether to enable nuodb support,
dnl Make sure that the comment is aligned:
dnl [  --enable-nuodb           Enable nuodb support])

if test "$PHP_NUODB" != "no"; then
  dnl Write more examples of tests here...
  PHP_REQUIRE_CXX()
  # --with-nuodb -> check with-path
  SEARCH_PATH="/opt/nuodb"     # you might want to change this
  SEARCH_FOR="/include/Connection.h"  # you most likely want to change this
  if test -r $PHP_NUODB/$SEARCH_FOR; then # path given as parameter
     NUODB_DIR=$PHP_NUODB
  else # search default path list
     AC_MSG_CHECKING([for nuodb files in default path])
     for i in $SEARCH_PATH ; do
       if test -r $i/$SEARCH_FOR; then
         NUODB_DIR=$i
         AC_MSG_RESULT(found in $i)
       fi
     done
   fi
  
   if test -z "$NUODB_DIR"; then
     AC_MSG_RESULT([not found])
     AC_MSG_ERROR([Please reinstall the nuodb distribution])
   fi

  # --with-nuodb -> add include path
  PHP_ADD_INCLUDE($NUODB_DIR/include)

  # --with-nuodb -> check for lib and symbol presence
  LIBNAME=NuoRemote
  LIBSYMBOL=createConnection # you most likely want to change this 

  PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  [
    PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $NUODB_DIR/lib64, NUODB_SHARED_LIBADD)
    AC_DEFINE(HAVE_NUODBLIB,1,[ ])
  ],[
    AC_MSG_ERROR([wrong nuodb lib version or lib not found])
  ],[
    -L$NUODB_DIR/lib64 -lm
  ])
  PHP_SUBST(NUODB_SHARED_LIBADD)

  PHP_NEW_EXTENSION(nuodb, nuodb.cpp, $ext_shared,,"-Wall -O2 -std=gnu++0x -D_REENTRANT -D_GNU_SOURCE -D_THREAD_SAFE", 1)
fi
