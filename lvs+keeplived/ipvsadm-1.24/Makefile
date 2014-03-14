#
#      ipvsadm - IP Virtual Server ADMinistration program
#                for IPVS NetFilter Module in kernel 2.4
#
#      Version: $Id: Makefile,v 1.29 2003/07/05 05:32:38 wensong Exp $
#
#      Authors: Wensong Zhang <wensong@linux-vs.org>
#               Peter Kese <peter.kese@ijs.si>
#
#      This file:
#
#      ChangeLog
#
#      Wensong        :   Modified the Makefile and the spec files so
#                     :   that rpms can be created with ipvsadm alone
#      P.Copeland     :   Modified the Makefile and the spec files so
#                     :   that it is possible to create rpms on the fly
#                     :   using 'make rpms'
#                     :   Also added NAME, VERSION and RELEASE numbers to
#                     :   the Makefile
#      Horms          :   Updated to add config_stream.c dynamic_array.c
#                     :   Added autodetection of libpot
#                     :   Added BUILD_ROOT support
#      Wensong        :   Changed the OBJS according to detection
#

NAME		= ipvsadm
VERSION		= $(shell cat VERSION)
RELEASE		= 2
SCHEDULERS	= "$(shell cat SCHEDULERS)"
PROGROOT	= $(shell basename `pwd`)

CC		= gcc
CFLAGS		= -Wall -Wunused -Wstrict-prototypes -g -O2
INCLUDE		= -I/usr/src/linux/include -I.. -I.
SBIN		= $(BUILD_ROOT)/sbin
MANDIR		= usr/man
MAN		= $(BUILD_ROOT)/$(MANDIR)/man8
INIT		= $(BUILD_ROOT)/etc/rc.d/init.d
MKDIR		= mkdir
INSTALL		= install
STATIC_LIBS	= libipvs/libipvs.a


#####################################
# No servicable parts below this line

RPMBUILD = $(shell				\
	if [ -x /usr/bin/rpmbuild ]; then	\
		echo "/usr/bin/rpmbuild";	\
	else					\
		echo "/bin/rpm";		\
	fi )

ifeq (,$(FORCE_GETOPT))
LIB_SEARCH = /lib /usr/lib /usr/local/lib
POPT_LIB = $(shell for i in $(LIB_SEARCH); do \
  if [ -f $$i/libpopt.a ]; then \
    if nm $$i/libpopt.a | fgrep -q poptGetContext; then \
	echo "-L$$i -lpopt"; \
    fi; \
  fi; \
done)
endif

ifneq (,$(POPT_LIB))
POPT_DEFINE = -DHAVE_POPT
endif

OBJS		= ipvsadm.o config_stream.o dynamic_array.o
LIBS		= $(POPT_LIB)
DEFINES		= -DVERSION=\"$(VERSION)\" -DSCHEDULERS=\"$(SCHEDULERS)\" \
		  $(POPT_DEFINE)
DEFINES		+= $(shell if [ ! -f ../ip_vs.h ]; then	\
		     echo "-DHAVE_NET_IP_VS_H"; fi;)


.PHONY	= all clean install dist distclean rpm rpms

all:            libs ipvsadm

libs:
		make -C libipvs

ipvsadm:	$(OBJS) $(STATIC_LIBS)
		$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

install:        all
		if [ ! -d $(SBIN) ]; then $(MKDIR) -p $(SBIN); fi
		$(INSTALL) -m 0755 -s ipvsadm $(SBIN)
		$(INSTALL) -m 0755 ipvsadm-save $(SBIN)
		$(INSTALL) -m 0755 ipvsadm-restore $(SBIN)
		[ -d $(MAN) ] || $(MKDIR) -p $(MAN)
		$(INSTALL) -m 0644 ipvsadm.8 $(MAN)
		$(INSTALL) -m 0644 ipvsadm-save.8 $(MAN)
		$(INSTALL) -m 0644 ipvsadm-restore.8 $(MAN)
		if [ -d $(INIT) ]; then \
		  $(INSTALL) -m 0755 ipvsadm.sh $(INIT)/ipvsadm; \
		fi

clean:
		rm -f ipvsadm $(NAME).spec $(NAME)-$(VERSION).tar.gz
		rm -rf debian/tmp
		find . -name '*.[ao]' -o -name "*~" -o -name "*.orig" \
		  -o -name "*.rej" -o -name core | xargs rm -f
		make -C libipvs clean

distclean:	clean

dist:		distclean
		sed -e "s/@@VERSION@@/$(VERSION)/g" \
		    -e "s/@@RELEASE@@/$(RELEASE)/g" \
		    < ipvsadm.spec.in > ipvsadm.spec
		rm -f $(NAME)-$(VERSION)
		ln -s . $(NAME)-$(VERSION)
		tar czvf $(NAME)-$(VERSION).tar.gz			\
		    --exclude CVS					\
		    --exclude $(NAME)-$(VERSION)/$(NAME)-$(VERSION)	\
		    --exclude $(NAME)-$(VERSION).tar.gz			\
		    $(NAME)-$(VERSION)/*
		rm -f $(NAME)-$(VERSION)

rpms:		dist
		cp $(NAME)-$(VERSION).tar.gz /usr/src/redhat/SOURCES/
		cp $(NAME).spec /usr/src/redhat/SPECS/
		(cd /usr/src/redhat/SPECS/ ; $(RPMBUILD) -ba $(NAME).spec)

srpm:		dist
		cp $(NAME)-$(VERSION).tar.gz /usr/src/redhat/SOURCES/
		cp $(NAME).spec /usr/src/redhat/SPECS/
		(cd /usr/src/redhat/SPECS/ ; $(RPMBUILD) -bs $(NAME).spec)

deb:		debs

debs:
		dpkg-buildpackage

%.o:	%.c
		$(CC) $(CFLAGS) $(INCLUDE) $(DEFINES) -c -o $@ $<
