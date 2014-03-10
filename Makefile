
#OMNI_INC = /usr/local/omniorb-4.1.6/include
#TANGO_INC = /usr/local/tango-8.1.2.c/include/tango

#MYSQL_INC = /usr/local/mysql-5.5.22/include
#MYSQL_INC = /usr/include/mysql
#MYSQL_LIB = /usr/local/mysql-5.5.22/lib
#MYSQL_LIB = /usr/lib/mysql

#LIBHDB_INC = /runtime/include
#LIBHDB_INC = ../libhdb++

include ../Make-hdb++.in

CFLAGS = -Wall -DRELEASE='"N$Name:  $ "' -I$(SQLIMPL_INC) -I$(TANGO_INC) -I$(OMNI_INC) -I$(LIBHDB_INC) -std=gnu++98
#CFLAGS = -Wall -DRELEASE='"N$Name:  $ "' -I$(SQLIMPL_INC) -I$(TANGO_INC) -I$(OMNI_INC) -I$(LIBHDB_INC) -std=gnu++0x
CXX = g++


##############################################
# support for shared libray versioning
#
LFLAGS_SONAME = -lmysqlclient -L$(SQLIMPL_LIB) -Wl,-soname,
SHLDFLAGS = -shared
BASELIBNAME       =  libhdbmysql
SHLIB_SUFFIX = so

#  release numbers for libraries
#
 LIBVERSION    = 1
 LIBRELEASE    = 0
 LIBSUBRELEASE = 0
#

LIBRARY       = $(BASELIBNAME).a
DT_SONAME     = $(BASELIBNAME).$(SHLIB_SUFFIX).$(LIBVERSION)
DT_SHLIB      = $(BASELIBNAME).$(SHLIB_SUFFIX).$(LIBVERSION).$(LIBRELEASE).$(LIBSUBRELEASE)
SHLIB         = $(BASELIBNAME).$(SHLIB_SUFFIX)



.PHONY : install clean

lib/LibHdbMySQL: lib obj obj/LibHdbMySQL.o
	$(CXX) obj/LibHdbMySQL.o $(SHLDFLAGS) $(LFLAGS_SONAME)$(DT_SONAME) -o lib/$(DT_SHLIB)
	ln -sf $(DT_SHLIB) lib/$(SHLIB)
	ln -sf $(SHLIB) lib/$(DT_SONAME)
	ar rcs lib/$(LIBRARY) obj/LibHdbMySQL.o

obj/LibHdbMySQL.o: src/LibHdbMySQL.cpp src/LibHdbMySQL.h $(LIBHDB_INC)/LibHdb++.h
	$(CXX) $(CFLAGS) -fPIC -c src/LibHdbMySQL.cpp -o $@

clean:
	rm -f obj/*.o lib/*.so* lib/*.a

lib obj:
	@mkdir $@
	
	