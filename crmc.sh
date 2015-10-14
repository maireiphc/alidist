package: CRMC
version: "%(tag_basename)s"
tag: alice/v1.5.4
requires:
  - boost
  - HepMC
build_requires:
  - CMake
---
#!/bin/bash -ex

cmake $SOURCEDIR \
      -DCMAKE_INSTALL_PREFIX=$INSTALLROOT
make ${JOBS+-j $JOBS} all
make install

# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"
cat > "$MODULEFILE" <<EoF
#%Module1.0
proc ModulesHelp { } {
  global version
  puts stderr "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
}
set version $PKGVERSION-@@PKGREVISION@$PKGHASH@@
module-whatis "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
# Dependencies
module load BASE/1.0 CMake/$CMAKE_VERSION-$CMAKE_REVISION boost/$BOOST_VERSION-$BOOST_REVISION HepMC/$HEPMC_VERSION-$HEPMC_REVISION
# Our environment
setenv CRMC_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
prepend-path PATH $::env(CRMC_ROOT)/bin
prepend-path LD_LIBRARY_PATH $::env(CRMC_ROOT)/lib
EoF