#!/bin/bash

# Here are the various libs that will be required. They will be installed
# either with opam or with the system manager.


OPAM_DEPENDS="ocamlfind ocambuild oUnit compiler-libs.common lablgtk2"
LIB_DEPENDS="texlive-science tex dvips ps2pdf"
COMPILER_DEPENDS="make"
TESTING_DEPENDS=""
export DISPLAY=:99.0
#sh -e /etc/init.d/xvfb start
#sudo cp /var/lib/dbus/machine-id /etc/machine-id
/sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99.0 -screen 0 800x600x16

case "$OCAML_VERSION" in
        3.12.1) ppa=avsm/ocaml312+opam12 ;;
            4.00.1) ppa=avsm/ocaml40+opam12 ;;
                4.01.0) ppa=avsm/ocaml41+opam12 ;;
                    4.02.0) ppa=avsm/ocaml42+opam12 ;;
                        4.02.1) ppa=avsm/ocaml42+opam12 ;; #There is no repo for 4.02.1,
                                               #hence it will be compiled.
                                                *) echo Unknown OCaml version $OCAML_VERSION; exit 1 ;;
                                            esac


                                            sudo add-apt-repository -y ppa:$ppa
                                            sudo add-apt-repository -y ppa:sonkun/sfml-development

                                            sudo apt-get update -qq
                                            sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam \
                                                             ${LIB_DEPENDS} ${COMPILER_DEPENDS} ${TESTING_DEPENDS}

                                            export OPAMYES=1
                                            opam init

                                            if [ "$OCAML_VERSION" = "4.02.1" ]
                                            then
                                                    opam switch 4.02.1
                                                fi

                                                eval `opam config env`
                                                opam install ${OPAM_DEPENDS}
                                                # Temporary: before we update dolog to 1.0
                                                opam install dolog
                                                aclocal -I m4
                                                autoreconf configure.ac
                                                ./configure
                                                make interface
                                                nohup ./test/Xtest.sh &
                                                ./main.native
                                                make engine
                                                make doc
                                                make check
                                                make check_generation
                                                make clean
                                                make dist
                                                make distcheck
                                                make clean
