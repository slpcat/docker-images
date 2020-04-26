%global DATE 20190804
%define debug_package %{nil}

%global gcc_version 7.3.0
%global gcc_release 20190804
%global isl_version 0.14
%global cloog_version 0.18.4

%define compat_gcc_provides 7777777

%global _unpackaged_files_terminate_build 0
%undefine _annotated_build

%global gcc_target_platform %{_arch}-linux-gnu

%global build_ada 0
%global build_java 0
%global build_go 0
%ifarch aarch64
%global build_libquadmath 0
%endif
%ifarch x86_64
%global build_libquadmath 1
%endif
%global build_libasan 1
%global build_libatomic 1
%global build_libitm 1
%global attr_ifunc 1
%global build_cloog 1
%global build_libstdcxx_docs 0
%global build_java_tar 0
%global build_libtsan 1
%global build_libilp32 0
%global build_check 0

Summary: Various compilers (C, C++, Objective-C, Java, ...)
Name: gcc
Version: 7.3.0
Release: %{gcc_release}.h31
License: GPLv3+ and GPLv3+ with exceptions and GPLv2+ with exceptions and LGPLv2+ and BSD
Group: Development/Languages
#Source0: hcc-aarch64-linux-release.tar.bz2
Source0: gcc-%{version}.tar.gz
Source1: isl-%{isl_version}.tar.xz
Source2: cloog-%{cloog_version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires: gmp libmpc-devel mpfr gmp-devel glibc-headers gcc-c++ mpfr-devel
#BuildRequires: gmp  mpfr gmp-devel glibc-headers gcc-c++ mpfr-devel mpc
%ifarch aarch64
%if %{build_libilp32}
BuildRequires: glibc-32-headers
%endif
%endif

Requires: cpp = %{version}-%{release}
Requires: binutils >= 2.20.51.0.2-12
Requires: glibc-devel >= 2.2.90-12
Requires: glibc >= 2.16
Requires: libgcc >= %{version}-%{release}
Requires: libgomp = %{version}-%{release}
Provides: bundled(libiberty)
Provides: gcc = %{compat_gcc_provides}
Provides: gcc(major) = 7.3.0
BuildRequires: libtool zlib-devel texinfo

Patch1: fix-operand-size-mismatch-for-i386-sse.patch
Patch2: gcc-adapt-to-isl.patch
Patch3: sanitizer-pr-85835.patch
Patch4: CVE-2018-12886.patch
Patch5: CVE-2019-15847.patch
Patch6: option-mlong-calls.patch
Patch7: add-tsv110-pipeline-scheduling.patch
Patch8: option-mfentry-and-mlong-calls-bugfix.patch
Patch10: aarch64-ilp32-call-addr-dimode.patch
Patch12: aarch64-fix-tls-negative-offset.patch
Patch14: arm-fix-push-minipool.patch
Patch22: arm-bigendian-disable-interleaved-LS-vectorize.patch
Patch23: floop-unroll-and-jam.patch
Patch24: floop-interchange.patch
Patch25: constructor-priority-bugfix.patch
Patch26: arm-adjust-be-ldrd-strd.patch
Patch28: try-unroll.patch
Patch29: Big-endian-union-bitfield-bugfix.patch
Patch31: fstack-clash-protection.patch
Patch34: mark-pattern-as-clobbering-CC-REGNUM.patch
Patch35: turn-on-funwind-tables-by-default.patch


#AutoReqProv:    off
AutoReq: true


%package -n libgcc
Summary: GCC version 7.3.0 shared support library
Group: System Environment/Libraries
Autoreq: false
Provides: libgcc = %{compat_gcc_provides}

%description -n libgcc
This package contains GCC shared support library which is needed
e.g. for exception handling support.

%ifarch aarch64
%if %{build_libilp32}
%package -n libgcc-32
Summary: GCC version 7.3.0 shared support library
Group: System Environment/Libraries
Autoreq: false
Provides: libgcc = %{compat_gcc_provides}

%description -n libgcc-32
This package contains GCC shared support library which is needed
e.g. for exception handling support.
%endif
%endif

%package c++
Summary: C++ support for GCC
Group: Development/Languages
Requires: gcc = %{version}-%{release}
Requires: libstdc++ = %{version}-%{release}
Requires: libstdc++-devel = %{version}-%{release}
Autoreq: true
Provides: gcc-c++ = %{compat_gcc_provides}

%description c++
This package adds C++ support to the GNU Compiler Collection.
It includes support for most of the current C++ specification,
including templates and exception handling.

%package -n libstdc++
Summary: GNU Standard C++ Library
Group: System Environment/Libraries
Autoreq: true
Requires: glibc >= 2.10.90-7
Provides: libstdc++ = %{compat_gcc_provides}

%description -n libstdc++
The libstdc++ package contains a rewritten standard compliant GCC Standard
C++ Library.

%package -n libstdc++-devel
Summary: Header files and libraries for C++ development
Group: Development/Libraries
Requires: libstdc++%{?_isa} = %{version}-%{release}
Autoreq: true
Provides: libstdc++-devel = %{compat_gcc_provides}

%description -n libstdc++-devel
This is the GNU implementation of the standard C++ libraries.  This
package includes the header files and libraries needed for C++
development. This includes rewritten implementation of STL.

%package -n libstdc++-static
Summary: Static libraries for the GNU standard C++ library
Group: Development/Libraries
Requires: libstdc++-devel = %{version}-%{release}
Autoreq: true
Provides: libstdc++-static = %{compat_gcc_provides}

%description -n libstdc++-static
Static libraries for the GNU standard C++ library.

%ifarch aarch64
%if %{build_libilp32}
%package -n libstdc++-32
Summary: GNU Standard C++ Library
Group: System Environment/Libraries
Autoreq: true
Requires: glibc >= 2.10.90-7
Provides: libstdc++ = %{compat_gcc_provides}

%description -n libstdc++-32
The libstdc++ package contains a rewritten standard compliant GCC Standard
C++ Library.
%endif
%endif

%package objc
Summary: Objective-C support for GCC
Group: Development/Languages
Requires: gcc = %{version}-%{release}
Requires: libobjc = %{version}-%{release}
Autoreq: true
Provides: gcc-objc = %{compat_gcc_provides}

%description objc
gcc-objc provides Objective-C support for the GCC.
Mainly used on systems running NeXTSTEP, Objective-C is an
object-oriented derivative of the C language.

%package objc++
Summary: Objective-C++ support for GCC
Group: Development/Languages
Requires: gcc-c++ = %{version}-%{release}, gcc-objc = %{version}-%{release}
Autoreq: true
Provides: gcc-objc++ = %{compat_gcc_provides}

%description objc++
gcc-objc++ package provides Objective-C++ support for the GCC.

%package -n libobjc
Summary: Objective-C runtime
Group: System Environment/Libraries
Autoreq: true
Provides: libobjc = %{compat_gcc_provides}

%description -n libobjc
This package contains Objective-C shared library which is needed to run
Objective-C dynamically linked programs.

%ifarch aarch64
%if %{build_libilp32}
%package -n libobjc-32
Summary: Objective-C runtime
Group: System Environment/Libraries
Autoreq: true
Provides: libobjc = %{compat_gcc_provides}

%description -n libobjc-32
This package contains Objective-C shared library which is needed to run
Objective-C dynamically linked programs.
%endif
%endif

%package -n libitm
Summary: The GNU Transactional Memory library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libitm
This package contains the GNU Transactional Memory library
which is a GCC transactional memory support runtime library.

%package -n libitm-devel
Summary: The GNU Transactional Memory support
Group: Development/Libraries
Requires: libitm = %{version}-%{release}
Requires: gcc = %{version}-%{release}

%description -n libitm-devel
This package contains headers and support files for the
GNU Transactional Memory library.

%package -n libitm-static
Summary: The GNU Transactional Memory static library
Group: Development/Libraries
Requires: libitm-devel = %{version}-%{release}

%description -n libitm-static
This package contains GNU Transactional Memory static libraries.

%package -n libatomic
Summary: The GNU Atomic library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libatomic
This package contains the GNU Atomic library
which is a GCC support runtime library for atomic operations not supported
by hardware.

%package -n libatomic-static
Summary: The GNU Atomic static library
Group: Development/Libraries
Requires: libatomic = %{version}-%{release}

%description -n libatomic-static
This package contains GNU Atomic static libraries.

%package -n libasan
Summary: The Address Sanitizer runtime library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libasan
This package contains the Address Sanitizer library
which is used for -fsanitize=address instrumented programs.

%package -n libasan-static
Summary: The Address Sanitizer static library
Group: Development/Libraries
Requires: libasan = %{version}-%{release}

%description -n libasan-static
This package contains Address Sanitizer static runtime library.

%package -n libtsan
Summary: The Thread Sanitizer runtime library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libtsan
This package contains the Thread Sanitizer library
which is used for -fsanitize=thread instrumented programs.

%package -n libtsan-static
Summary: The Thread Sanitizer static library
Group: Development/Libraries
Requires: libtsan = %{version}-%{release}

%description -n libtsan-static
This package contains Thread Sanitizer static runtime library.

%package plugin-devel
Summary: Support for compiling GCC plugins
Group: Development/Languages
Requires: gcc = %{version}-%{release}
Requires: gmp-devel >= 4.1.2-8, mpfr-devel >= 2.2.1, libmpc-devel >= 0.8.1

%description plugin-devel
This package contains header files and other support files
for compiling GCC plugins.  The GCC plugin ABI is currently
not stable, so plugins must be rebuilt any time GCC is updated.

%package gfortran
Summary: Fortran support
Group: Development/Languages
Requires: gcc = %{version}-%{release}
Requires: libgfortran = %{version}-%{release}
BuildRequires: gmp-devel >= 4.1.2-8, mpfr-devel >= 2.2.1, libmpc-devel >= 0.8.1
%if %{build_libquadmath}
Requires: libquadmath = %{version}-%{release}
Requires: libquadmath-devel = %{version}-%{release}
%endif
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
Autoreq: true
Provides: gcc-gfortran = %{compat_gcc_provides}

%description gfortran
The gcc-gfortran package provides support for compiling Fortran
programs with the GNU Compiler Collection.

%package -n libgfortran
Summary: Fortran runtime
Group: System Environment/Libraries
Autoreq: true
Provides: libgfortran = %{compat_gcc_provides}
%if %{build_libquadmath}
Requires: libquadmath = %{version}-%{release}
%endif

%description -n libgfortran
This package contains Fortran shared library which is needed to run
Fortran dynamically linked programs.

%package -n libgomp
Summary: GCC OpenMP v3.0 shared support library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
Provides: libgomp = %{compat_gcc_provides}

%description -n libgomp
This package contains GCC shared support library which is needed
for OpenMP v3.0 support.

%ifarch aarch64
%if %{build_libilp32}
%package -n libgfortran-32
Summary: Fortran runtime
Group: System Environment/Libraries
Autoreq: true
Provides: libgfortran = %{compat_gcc_provides}

%description -n libgfortran-32
This package contains Fortran shared library which is needed to run
Fortran dynamically linked programs.

%package -n libgomp-32
Summary: GCC OpenMP v3.0 shared support library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
Provides: libgomp = %{compat_gcc_provides}

%description -n libgomp-32
This package contains GCC shared support library which is needed
for OpenMP v3.0 support.
%endif
%endif

%package -n cpp
Summary: The C Preprocessor
Group: Development/Languages
Requires: filesystem >= 3
Provides: /lib/cpp
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
Autoreq: true
Provides: cpp = %{compat_gcc_provides}

%description -n cpp
Cpp is the GNU C-Compatible Compiler Preprocessor.
Cpp is a macro processor which is used automatically
by the C compiler to transform your program before actual
compilation. It is called a macro processor because it allows
you to define macros, abbreviations for longer
constructs.


The C preprocessor provides four separate functionalities: the
inclusion of header files (files of declarations that can be
substituted into your program); macro expansion (you can define macros,
and the C preprocessor will replace the macros with their definitions
throughout the program); conditional compilation (using special
preprocessing directives, you can include or exclude parts of the
program according to various conditions); and line control (if you use
a program to combine or rearrange source files into an intermediate
file which is then compiled, you can use line control to inform the
compiler about where each source line originated).

You should install this package if you are a C programmer and you use
macros.

%description
This is compiler for arm64.
%ifarch x86_64
%package -n libquadmath
Summary: GCC __float128 shared support library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libquadmath
This package contains GCC shared support library which is needed
for __float128 math support and for Fortran REAL*16 support.

%package -n libquadmath-devel
Summary: GCC __float128 support
Group: Development/Libraries
Requires: libquadmath = %{version}-%{release}
Requires: gcc = %{version}-%{release}

%description -n libquadmath-devel
This package contains headers for building Fortran programs using
REAL*16 and programs using __float128 math.

%package -n libquadmath-static
Summary: Static libraries for __float128 support
Group: Development/Libraries
Requires: libquadmath-devel = %{version}-%{release}

%description -n libquadmath-static
This package contains static libraries for building Fortran programs
using REAL*16 and programs using __float128 math.

%endif

%if 0%{?_enable_debug_packages}
%define debug_package %{nil}
%global __debug_package 1
%global __debug_install_post \
    %{_rpmconfigdir}/find-debuginfo.sh %{?_missing_build_ids_terminate_build:--strict-build-id} %{?_find_debuginfo_opts} "%{_builddir}/gcc-%{version}"\
    %{_builddir}/gcc-%{version}/split-debuginfo.sh\
%{nil}
%package debuginfo
Summary: Debug information for package %{name}
Group: Development/Debug
AutoReqProv: 0
Requires: gcc-base-debuginfo = %{version}-%{release}
%description debuginfo
This package provides debug information for package %{name}.
Debug information is useful when developing applications that use this
package or when debugging this package.
%files debuginfo -f debugfiles.list
%defattr(-,root,root)
%package base-debuginfo
Summary: Debug information for libraries from package %{name}
Group: Development/Debug
AutoReqProv: 0
%description base-debuginfo
This package provides debug information for libgcc_s, libgomp and
libstdc++ libraries from package %{name}.
Debug information is useful when developing applications that use this
package or when debugging this package.
%files base-debuginfo -f debugfiles-base.list
%defattr(-,root,root)
%endif
%prep
%setup -q -n gcc-%{version} -a 1 -a 2
/bin/pwd


%patch1 -p1
%patch2 -p1
%patch3 -p1
%patch4 -p1
%patch5 -p1
%patch6 -p1
%patch7 -p1
%patch8 -p1
%patch10 -p1
%patch12 -p1
%patch14 -p1
%patch22 -p1
%patch23 -p1
%patch24 -p1
%patch25 -p1
%patch26 -p1
%patch28 -p1
%patch29 -p1
%patch31 -p1
%patch34 -p1
%patch35 -p1

%if 0%{?_enable_debug_packages}
cat > split-debuginfo.sh <<\EOF
#!/bin/sh
BUILDDIR="%{_builddir}/gcc-%{version}"
if [ -f "${BUILDDIR}"/debugfiles.list \
     -a -f "${BUILDDIR}"/debuglinks.list ]; then
  > "${BUILDDIR}"/debugsources-base.list
  > "${BUILDDIR}"/debugfiles-base.list
  cd "${RPM_BUILD_ROOT}"
  for f in `find usr/lib/debug -name \*.debug \
	    | egrep 'lib[0-9]*/lib(gcc|gomp|stdc|quadmath|itm)'`; do
    echo "/$f" >> "${BUILDDIR}"/debugfiles-base.list
    if [ -f "$f" -a ! -L "$f" ]; then
      cp -a "$f" "${BUILDDIR}"/test.debug
      /usr/lib/rpm/debugedit -b "${RPM_BUILD_DIR}" -d /usr/src/debug \
			     -l "${BUILDDIR}"/debugsources-base.list \
			     "${BUILDDIR}"/test.debug
      rm -f "${BUILDDIR}"/test.debug
    fi
  done
  for f in `find usr/lib/debug/.build-id -type l`; do
    ls -l "$f" | egrep -q -- '->.*lib[0-9]*/lib(gcc|gomp|stdc|quadmath|itm)' \
      && echo "/$f" >> "${BUILDDIR}"/debugfiles-base.list
  done
  grep -v -f "${BUILDDIR}"/debugfiles-base.list \
    "${BUILDDIR}"/debugfiles.list > "${BUILDDIR}"/debugfiles.list.new
  mv -f "${BUILDDIR}"/debugfiles.list.new "${BUILDDIR}"/debugfiles.list
  for f in `LC_ALL=C sort -z -u "${BUILDDIR}"/debugsources-base.list \
	    | grep -E -v -z '(<internal>|<built-in>)$' \
	    | xargs --no-run-if-empty -n 1 -0 echo \
	    | sed 's,^,usr/src/debug/,'`; do
    if [ -f "$f" ]; then
      echo "/$f" >> "${BUILDDIR}"/debugfiles-base.list
      echo "%%exclude /$f" >> "${BUILDDIR}"/debugfiles.list
    fi
  done
  mv -f "${BUILDDIR}"/debugfiles-base.list{,.old}
  echo "%%dir /usr/lib/debug" > "${BUILDDIR}"/debugfiles-base.list
  awk 'BEGIN{FS="/"}(NF>4&&$NF){d="%%dir /"$2"/"$3"/"$4;for(i=5;i<NF;i++){d=d"/"$i;if(!v[d]){v[d]=1;print d}}}' \
    "${BUILDDIR}"/debugfiles-base.list.old >> "${BUILDDIR}"/debugfiles-base.list
  cat "${BUILDDIR}"/debugfiles-base.list.old >> "${BUILDDIR}"/debugfiles-base.list
  rm -f "${BUILDDIR}"/debugfiles-base.list.old
fi
EOF
chmod 755 split-debuginfo.sh
%endif



%build

%ifarch aarch64_ilp32
optflags=`echo ${optflags}|sed -e 's/-mabi=ilp32//g'`
optflags=`echo ${optflags}|sed -e 's/-Werror=format-security/ /g'`
CFLAGS='-O2 -g'
%endif
%ifarch x86_64
%global optflags `echo %{optflags}|sed -e 's/-fcf-protection//g'`
%endif
export CONFIG_SITE=NONE
%if %{build_java}
export GCJ_PROPERTIES=jdt.compiler.useSingleThread=true
# gjar isn't usable, so even when GCC source tree no longer includes
# fastjar, build it anyway.
mkdir fastjar-%{fastjar_ver}/obj-%{gcc_target_platform}
cd fastjar-%{fastjar_ver}/obj-%{gcc_target_platform}
../configure CFLAGS="%{optflags}" --prefix=%{_prefix} --mandir=%{_mandir} --infodir=%{_infodir}
make -j100
export PATH=`pwd`${PATH:+:$PATH}
cd ../../
%endif

rm -fr obj-%{gcc_target_platform}
mkdir obj-%{gcc_target_platform}
cd obj-%{gcc_target_platform}

%if %{build_java}
%if !%{bootstrap_java}
# If we don't have gjavah in $PATH, try to build it with the old gij
mkdir java_hacks
cd java_hacks
cp -a ../../libjava/classpath/tools/external external
mkdir -p gnu/classpath/tools
cp -a ../../libjava/classpath/tools/gnu/classpath/tools/{common,javah,getopt} gnu/classpath/tools/
cp -a ../../libjava/classpath/tools/resource/gnu/classpath/tools/common/messages.properties gnu/classpath/tools/common
cp -a ../../libjava/classpath/tools/resource/gnu/classpath/tools/getopt/messages.properties gnu/classpath/tools/getopt
cd external/asm; for i in `find . -name \*.java`; do gcj --encoding ISO-8859-1 -C $i -I.; done; cd ../..
for i in `find gnu -name \*.java`; do gcj -C $i -I. -Iexternal/asm/; done
gcj -findirect-dispatch -O2 -fmain=gnu.classpath.tools.javah.Main -I. -Iexternal/asm/ `find . -name \*.class` -o gjavah.real
cat > gjavah <<EOF
#!/bin/sh
export CLASSPATH=`pwd`${CLASSPATH:+:$CLASSPATH}
exec `pwd`/gjavah.real "\$@"
EOF
chmod +x `pwd`/gjavah
cat > ecj1 <<EOF
#!/bin/sh
exec gij -cp /usr/share/java/eclipse-ecj.jar org.eclipse.jdt.internal.compiler.batch.GCCMain "\$@"
EOF
chmod +x `pwd`/ecj1
export PATH=`pwd`${PATH:+:$PATH}
cd ..
%endif
%endif

mkdir isl-build isl-install
%ifarch s390 s390x
ISL_FLAG_PIC=-fPIC
%else
ISL_FLAG_PIC=-fpic
%endif
cd isl-build

../../isl-%{isl_version}/configure --disable-shared \
  CC=/usr/bin/gcc CXX=/usr/bin/g++ \
  CFLAGS="${CFLAGS:-%optflags} $ISL_FLAG_PIC" --prefix=`cd ..; pwd`/isl-install
make -j100
make -j100 install
cd ..

mkdir cloog-build cloog-install
cd cloog-build
cat >> ../../cloog-%{cloog_version}/source/isl/constraints.c << \EOF
#include <isl/flow.h>
static void __attribute__((used)) *s1 = (void *) isl_union_map_compute_flow;
static void __attribute__((used)) *s2 = (void *) isl_map_dump;
EOF
cd ../../cloog-%{cloog_version}
./autogen.sh
cd -

../../cloog-%{cloog_version}/configure --with-isl=system \
  --with-isl-prefix=`cd ../isl-install; pwd` \
  CC=/usr/bin/gcc CXX=/usr/bin/g++ \
  CFLAGS="${CFLAGS:-%optflags}" CXXFLAGS="${CXXFLAGS:-%optflags}" \
   --prefix=`cd ..; pwd`/cloog-install
sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool
sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool
make -j100
make -j100 install
cd ../cloog-install/lib
ln -sf libcloog-isl.so.4 libcloog-isl.so
ln -sf libcloog-isl.so.4 libcloog.so
cd ../..

#test don't build
%if 1 
CC=gcc
OPT_FLAGS=`echo %{optflags}|sed -e 's/\(-Wp,\)\?-D_FORTIFY_SOURCE=[12]//g'`
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-m64//g;s/-m32//g;s/-m31//g'`
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-mfpmath=sse/-mfpmath=sse -msse2/g'`
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-Werror=format-security/ /g'`
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/ -pipe / /g'`
%ifarch sparc
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-mcpu=ultrasparc/-mtune=ultrasparc/g;s/-mcpu=v[78]//g'`
%endif
%ifarch %{ix86}
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-march=i.86//g'`
%endif
%ifarch sparc64
cat > gcc64 <<"EOF"
#!/bin/sh
exec /usr/bin/gcc -m64 "$@"
EOF
chmod +x gcc64
CC=`pwd`/gcc64
%endif
%ifarch ppc64 ppc64le ppc64p7
if gcc -m64 -xc -S /dev/null -o - > /dev/null 2>&1; then
  cat > gcc64 <<"EOF"
#!/bin/sh
exec /usr/bin/gcc -m64 "$@"
EOF
  chmod +x gcc64
  CC=`pwd`/gcc64
fi
%endif
%ifarch aarch64_ilp32
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-mabi=ilp32//g'`
%endif
OPT_FLAGS=`echo "$OPT_FLAGS" | sed -e 's/[[:blank:]]\+/ /g'`
case "$OPT_FLAGS" in
  *-fasynchronous-unwind-tables*)
    sed -i -e 's/-fno-exceptions /-fno-exceptions -fno-asynchronous-unwind-tables/' \
      ../gcc/Makefile.in
    ;;
esac
enablelgo=
enablelada=
%if %{build_ada}
enablelada=,ada
%endif
%if %{build_go}
enablelgo=,go
%endif
OPT_FLAGS="$OPT_FLAGS -fPIE -Wl,-z,relro,-z,now"
OPT_LDFLAGS="$OPT_LDFLAGS -Wl,-z,relro,-z,now"
export extra_ldflags_libobjc="-Wl,-z,relro,-z,now"
export FCFLAGS="$OPT_FLAGS"
CC="$CC" CFLAGS="$OPT_FLAGS" \
	CXXFLAGS="`echo " $OPT_FLAGS " | sed 's/ -Wall / /g;s/ -fexceptions / /g' \
		  |  sed 's/ -Werror=format-security //'`" \
	LDFLAGS="$OPT_LDFLAGS" \
	CFLAGS_FOR_TARGET="$OPT_FLAGS" \
	CXXFLAGS_FOR_TARGET="$OPT_FLAGS" \
	XCFLAGS="$OPT_FLAGS" TCFLAGS="$OPT_FLAGS" GCJFLAGS="$OPT_FLAGS" \
	../configure --prefix=%{_prefix} --mandir=%{_mandir} --infodir=%{_infodir} \
         --enable-shared --enable-threads=posix --enable-checking=release \
         --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions \
         --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu \
         --enable-languages=c,c++,objc,obj-c++,fortran,lto --enable-plugin \
         --enable-initfini-array --disable-libgcj --without-isl --without-cloog \
         --enable-gnu-indirect-function --build=%{gcc_target_platform} \
         --with-stage1-ldflags="$OPT_LDFLAGS" \
         --with-boot-ldflags="$OPT_LDFLAGS" \
%ifarch x86_64
        --with-tune=generic \
        --with-arch_32=x86-64 \
        --disable-multilib
%endif
%ifarch aarch64
%if %{build_libilp32}
	 --with-multilib-list=lp64,ilp32
%else
	 --with-multilib-list=lp64
%endif
%endif

%ifarch %{arm} sparc sparcv9 sparc64
GCJFLAGS="$OPT_FLAGS" make -j BOOT_CFLAGS="$OPT_FLAGS" bootstrap
%else
#GCJFLAGS="$OPT_FLAGS" make -j BOOT_CFLAGS="$OPT_FLAGS" profiledbootstrap
GCJFLAGS="$OPT_FLAGS" make -j BOOT_CFLAGS="$OPT_FLAGS" BOOT_LDFLAGS="-pie -Wl,-z,relro,-z,now"
%endif
#test don't build
%endif
%if %{build_cloog}
cp -a cloog-install/lib/libcloog-isl.so.4 gcc/
%endif

# Make generated man pages even if Pod::Man is not new enough
perl -pi -e 's/head3/head2/' ../contrib/texi2pod.pl
for i in ../gcc/doc/*.texi; do
  cp -a $i $i.orig; sed 's/ftable/table/' $i.orig > $i
done
make -j100 -C gcc generated-manpages
for i in ../gcc/doc/*.texi; do mv -f $i.orig $i; done

# Make generated doxygen pages.
%if %{build_libstdcxx_docs}
cd %{gcc_target_platform}/libstdc++-v3
make doc-html-doxygen
make doc-man-doxygen
cd ../..
%endif

# Copy various doc files here and there
cd ..
mkdir -p rpm.doc/gfortran
mkdir -p rpm.doc/objc
mkdir -p rpm.doc/boehm-gc rpm.doc/fastjar rpm.doc/libffi rpm.doc/libjava
mkdir -p rpm.doc/go rpm.doc/libgo rpm.doc/libquadmath rpm.doc/libitm
#mkdir -p rpm.doc/changelogs/{gcc/cp,gcc/java,gcc/ada,libstdc++-v3,libobjc,libmudflap,libgomp,libatomic,libsanitizer}
mkdir -p rpm.doc/changelogs/{gcc/cp,gcc/java,gcc/ada,libstdc++-v3,libobjc,libgomp,libatomic,libsanitizer}
%if 0
#for i in {gcc,gcc/cp,gcc/java,gcc/ada,libstdc++-v3,libobjc,libmudflap,libgomp,libatomic,libsanitizer}/ChangeLog*; do
for i in {gcc,gcc/cp,gcc/java,gcc/ada,libstdc++-v3,libobjc,libgomp,libatomic,libsanitizer}/ChangeLog*; do
	cp -p $i rpm.doc/changelogs/$i
done

(cd gcc/fortran; for i in ChangeLog*; do
	cp -p $i ../../rpm.doc/gfortran/$i
done)
(cd libgfortran; for i in ChangeLog*; do
	cp -p $i ../rpm.doc/gfortran/$i.libgfortran
done)
(cd libobjc; for i in README*; do
	cp -p $i ../rpm.doc/objc/$i.libobjc
done)
(cd boehm-gc; for i in ChangeLog*; do
	cp -p $i ../rpm.doc/boehm-gc/$i.gc
done)

(cd fastjar-%{fastjar_ver}; for i in ChangeLog* README*; do
	cp -p $i ../rpm.doc/fastjar/$i.fastjar
done)
(cd libffi; for i in ChangeLog* README* LICENSE; do
	cp -p $i ../rpm.doc/libffi/$i.libffi
done)
(cd libjava; for i in ChangeLog* README*; do
	cp -p $i ../rpm.doc/libjava/$i.libjava
done)
cp -p libjava/LIBGCJ_LICENSE rpm.doc/libjava/
%if %{build_libquadmath}
(cd libquadmath; for i in ChangeLog* COPYING.LIB; do
	cp -p $i ../rpm.doc/libquadmath/$i.libquadmath
done)
%endif
%if %{build_libitm}
(cd libitm; for i in ChangeLog*; do
	cp -p $i ../rpm.doc/libitm/$i.libitm
done)
%endif
%if %{build_go}
(cd gcc/go; for i in README* ChangeLog*; do
	cp -p $i ../../rpm.doc/go/$i
done)
(cd libgo; for i in LICENSE* PATENTS* README; do
	cp -p $i ../rpm.doc/libgo/$i.libgo
done)
%endif

rm -f rpm.doc/changelogs/gcc/ChangeLog.[1-9]
find rpm.doc -name \*ChangeLog\* | xargs bzip2 -9
%endif

%if %{build_java_tar}
find libjava -name \*.h -type f | xargs grep -l '// DO NOT EDIT THIS FILE - it is machine generated' > libjava-classes.list
find libjava -name \*.class -type f >> libjava-classes.list
find libjava/testsuite -name \*.jar -type f >> libjava-classes.list
tar cf - -T libjava-classes.list | bzip2 -9 > $RPM_SOURCE_DIR/libjava-classes-%{version}-%{release}.tar.bz2
%endif

%install
rm -fr %{buildroot}

cd obj-%{gcc_target_platform}

%if %{build_java}
export GCJ_PROPERTIES=jdt.compiler.useSingleThread=true
export PATH=`pwd`/../fastjar-%{fastjar_ver}/obj-%{gcc_target_platform}${PATH:+:$PATH}
%if !%{bootstrap_java}
export PATH=`pwd`/java_hacks${PATH:+:$PATH}
%endif
%endif

TARGET_PLATFORM=%{gcc_target_platform}

# There are some MP bugs in libstdc++ Makefiles
make -j100 -C %{gcc_target_platform}/libstdc++-v3

make -j100 prefix=%{buildroot}%{_prefix} mandir=%{buildroot}%{_mandir} \
  infodir=%{buildroot}%{_infodir} install
%if %{build_java}
make -j100 DESTDIR=%{buildroot} -C %{gcc_target_platform}/libjava install-src.zip
%endif
%if %{build_ada}
chmod 644 %{buildroot}%{_infodir}/gnat*
%endif

%ifarch aarch64_ilp32
FULLPATH=%{buildroot}%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}/ilp32
FULLEPATH=%{buildroot}%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}/ilp32
%else
FULLPATH=%{buildroot}%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
FULLEPATH=%{buildroot}%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
FULLHPATH=%{buildroot}%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}

%if %{build_cloog}
cp -a cloog-install/lib/libcloog-isl.so.4 $FULLPATH/
%endif

# fix some things
ln -sf gcc %{buildroot}%{_prefix}/bin/cc
rm -f %{buildroot}%{_prefix}/lib/cpp
ln -sf ../bin/cpp %{buildroot}/%{_prefix}/lib/cpp
ln -sf gfortran %{buildroot}%{_prefix}/bin/f95
rm -f %{buildroot}%{_infodir}/dir
gzip -9 %{buildroot}%{_infodir}/*.info*
ln -sf gcc %{buildroot}%{_prefix}/bin/gnatgcc

cxxconfig="`find %{gcc_target_platform}/libstdc++-v3/include -name c++config.h`"
for i in `find %{gcc_target_platform}/[36]*/libstdc++-v3/include -name c++config.h 2>/dev/null`; do
  if ! diff -up $cxxconfig $i; then
    cat > %{buildroot}%{_prefix}/include/c++/%{version}/%{gcc_target_platform}/bits/c++config.h <<EOF
#ifndef _CPP_CPPCONFIG_WRAPPER
#define _CPP_CPPCONFIG_WRAPPER 1
#include <bits/wordsize.h>
#if __WORDSIZE == 32
%ifarch %{multilib_64_archs}
`cat $(find %{gcc_target_platform}/32/libstdc++-v3/include -name c++config.h)`
%else
`cat $(find %{gcc_target_platform}/libstdc++-v3/include -name c++config.h)`
%endif
#else
%ifarch %{multilib_64_archs}
`cat $(find %{gcc_target_platform}/libstdc++-v3/include -name c++config.h)`
%else
`cat $(find %{gcc_target_platform}/64/libstdc++-v3/include -name c++config.h)`
%endif
#endif
#endif
EOF
    break
  fi
done

for f in `find %{buildroot}%{_prefix}/include/c++/%{version}/%{gcc_target_platform}/ -name c++config.h`; do
  for i in 1 2 4 8; do
    sed -i -e 's/#define _GLIBCXX_ATOMIC_BUILTINS_'$i' 1/#ifdef __GCC_HAVE_SYNC_COMPARE_AND_SWAP_'$i'\
&\
#endif/' $f
  done
done

# Nuke bits/*.h.gch dirs
# 1) there is no bits/*.h header installed, so when gch file can't be
#    used, compilation fails
# 2) sometimes it is hard to match the exact options used for building
#    libstdc++-v3 or they aren't desirable
# 3) there are multilib issues, conflicts etc. with this
# 4) it is huge
# People can always precompile on their own whatever they want, but
# shipping this for everybody is unnecessary.
rm -rf %{buildroot}%{_prefix}/include/c++/%{version}/%{gcc_target_platform}/bits/*.h.gch

%if %{build_libstdcxx_docs}
libstdcxx_doc_builddir=%{gcc_target_platform}/libstdc++-v3/doc/doxygen
mkdir -p ../rpm.doc/libstdc++-v3
cp -r -p ../libstdc++-v3/doc/html ../rpm.doc/libstdc++-v3/html
cp -r -p $libstdcxx_doc_builddir/html ../rpm.doc/libstdc++-v3/html/api
mkdir -p %{buildroot}%{_mandir}/man3
cp -r -p $libstdcxx_doc_builddir/man/man3/* %{buildroot}%{_mandir}/man3/
find ../rpm.doc/libstdc++-v3 -name \*~ | xargs rm
%endif

%ifarch sparcv9 sparc64
ln -f %{buildroot}%{_prefix}/bin/%{gcc_target_platform}-gcc \
  %{buildroot}%{_prefix}/bin/sparc-%{_vendor}-%{_target_os}-gcc
%endif
%ifarch ppc ppc64 ppc64p7
ln -f %{buildroot}%{_prefix}/bin/%{gcc_target_platform}-gcc \
  %{buildroot}%{_prefix}/bin/ppc-%{_vendor}-%{_target_os}-gcc
%endif

%ifarch sparcv9 ppc
FULLLPATH=$FULLPATH/lib32
%endif
%ifarch sparc64 ppc64 ppc64p7
FULLLPATH=$FULLPATH/lib64
%endif
if [ -n "$FULLLPATH" ]; then
  mkdir -p $FULLLPATH
else
  FULLLPATH=$FULLPATH
fi

find %{buildroot} -name \*.la | xargs rm -f
%if %{build_java}
# gcj -static doesn't work properly anyway, unless using --whole-archive
# and saving 35MB is not bad.
find %{buildroot} -name libgcj.a -o -name libgtkpeer.a \
		     -o -name libgjsmalsa.a -o -name libgcj-tools.a -o -name libjvm.a \
		     -o -name libgij.a -o -name libgcj_bc.a -o -name libjavamath.a \
  | xargs rm -f

mv %{buildroot}%{_prefix}/lib/libgcj.spec $FULLPATH/
sed -i -e 's/lib: /&%%{static:%%eJava programs cannot be linked statically}/' \
  $FULLPATH/libgcj.spec
%endif

mv %{buildroot}%{_prefix}/%{_lib}/libgfortran.spec $FULLPATH/
%if %{build_libitm}
mv %{buildroot}%{_prefix}/%{_lib}/libitm.spec $FULLPATH/
%endif

%if %{build_libasan}
mv %{buildroot}%{_prefix}/%{_lib}/libsanitizer.spec $FULLPATH/
%endif

mkdir -p %{buildroot}/%{_lib}
mv -f %{buildroot}%{_prefix}/%{_lib}/libgcc_s.so.1 %{buildroot}/%{_lib}/libgcc_s-%{version}-%{DATE}.so.1
chmod 755 %{buildroot}/%{_lib}/libgcc_s-%{version}-%{DATE}.so.1
ln -sf libgcc_s-%{version}-%{DATE}.so.1 %{buildroot}/%{_lib}/libgcc_s.so.1
ln -sf /%{_lib}/libgcc_s.so.1 $FULLPATH/libgcc_s.so

%ifarch aarch64
%if %{build_libilp32}
mkdir -p %{buildroot}/libilp32
mv -f %{buildroot}%{_prefix}/libilp32/libgcc_s.so.1 %{buildroot}/libilp32/libgcc_s-%{version}-%{DATE}.so.1
chmod 755 %{buildroot}/libilp32/libgcc_s-%{version}-%{DATE}.so.1
ln -sf libgcc_s-%{version}-%{DATE}.so.1 %{buildroot}/libilp32/libgcc_s.so.1
ln -sf /libilp32/libgcc_s.so.1 $FULLPATH/ilp32/libgcc_s.so
%endif
%endif

%ifarch sparcv9 ppc
ln -sf /lib64/libgcc_s.so.1 $FULLPATH/64/libgcc_s.so
%endif
%ifarch %{multilib_64_archs}
ln -sf /lib/libgcc_s.so.1 $FULLPATH/32/libgcc_s.so
%endif
%ifarch ppc
rm -f $FULLPATH/libgcc_s.so
echo '/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-powerpc)
GROUP ( /lib/libgcc_s.so.1 libgcc.a )' > $FULLPATH/libgcc_s.so
%endif
%ifarch ppc64 ppc64p7
rm -f $FULLPATH/32/libgcc_s.so
echo '/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-powerpc)
GROUP ( /lib/libgcc_s.so.1 libgcc.a )' > $FULLPATH/32/libgcc_s.so
%endif
%ifarch %{arm}
rm -f $FULLPATH/libgcc_s.so
echo '/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-littlearm)
GROUP ( /lib/libgcc_s.so.1 libgcc.a )' > $FULLPATH/libgcc_s.so
%endif

mv -f %{buildroot}%{_prefix}/%{_lib}/libgomp.spec $FULLPATH/

%if %{build_ada}
mv -f $FULLPATH/adalib/libgnarl-*.so %{buildroot}%{_prefix}/%{_lib}/
mv -f $FULLPATH/adalib/libgnat-*.so %{buildroot}%{_prefix}/%{_lib}/
rm -f $FULLPATH/adalib/libgnarl.so* $FULLPATH/adalib/libgnat.so*
%endif

mkdir -p %{buildroot}%{_prefix}/libexec/getconf
if gcc/xgcc -B gcc/ -E -dD -xc /dev/null | grep __LONG_MAX__.*2147483647; then
  ln -sf POSIX_V6_ILP32_OFF32 %{buildroot}%{_prefix}/libexec/getconf/default
else
  ln -sf POSIX_V6_LP64_OFF64 %{buildroot}%{_prefix}/libexec/getconf/default
fi

%if %{build_java}
pushd ../fastjar-%{fastjar_ver}/obj-%{gcc_target_platform}
make -j100 install DESTDIR=%{buildroot}
popd

if [ "%{_lib}" != "lib" ]; then
  mkdir -p %{buildroot}%{_prefix}/%{_lib}/pkgconfig
  sed '/^libdir/s/lib$/%{_lib}/' %{buildroot}%{_prefix}/lib/pkgconfig/libgcj-*.pc \
    > %{buildroot}%{_prefix}/%{_lib}/pkgconfig/`basename %{buildroot}%{_prefix}/lib/pkgconfig/libgcj-*.pc`
fi

%endif

mkdir -p %{buildroot}%{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}
mv -f %{buildroot}%{_prefix}/%{_lib}/libstdc++*gdb.py* \
      %{buildroot}%{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}/

%ifarch aarch64
%if %{build_libilp32}
mkdir -p %{buildroot}%{_datadir}/gdb/auto-load/%{_prefix}/libilp32
mv -f %{buildroot}%{_prefix}/libilp32/libstdc++*gdb.py* \
      %{buildroot}%{_datadir}/gdb/auto-load/%{_prefix}/libilp32
%endif
%endif

pushd ../libstdc++-v3/python
for i in `find . -name \*.py`; do
  touch -r $i %{buildroot}%{_prefix}/share/gcc-%{version}/python/$i
done
touch -r hook.in %{buildroot}%{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}/libstdc++*gdb.py
%ifarch aarch64
%if %{build_libilp32}
touch -r hook.in %{buildroot}%{_datadir}/gdb/auto-load/%{_prefix}/libilp32/libstdc++*gdb.py
%endif
%endif
popd

pushd $FULLPATH
if [ "%{_lib}" = "lib" ]; then
ln -sf ../../../libobjc.so.4 libobjc.so
ln -sf ../../../libstdc++.so.6.*[0-9] libstdc++.so
ln -sf ../../../libgfortran.so.4.* libgfortran.so
ln -sf ../../../libgomp.so.1.* libgomp.so
#ln -sf ../../../libmudflap.so.0.* libmudflap.so
#ln -sf ../../../libmudflapth.so.0.* libmudflapth.so
%if %{build_go}
ln -sf ../../../libgo.so.4.* libgo.so
%endif
%if %{build_libquadmath}
ln -sf ../../../libquadmath.so.0.* libquadmath.so
%endif
%if %{build_libitm}
ln -sf ../../../libitm.so.1.* libitm.so
%endif
%if %{build_libatomic}
ln -sf ../../../libatomic.so.1.* libatomic.so
%endif
%if %{build_libasan}
ln -sf ../../../libasan.so.4.* libasan.so
mv ../../../libasan_preinit.o libasan_preinit.o
%endif
%if %{build_java}
ln -sf ../../../libgcj.so.14.* libgcj.so
ln -sf ../../../libgcj-tools.so.14.* libgcj-tools.so
ln -sf ../../../libgij.so.14.* libgij.so
%endif
else
ln -sf ../../../../%{_lib}/libobjc.so.4 libobjc.so
ln -sf ../../../../%{_lib}/libstdc++.so.6.*[0-9] libstdc++.so
ln -sf ../../../../%{_lib}/libgfortran.so.4.* libgfortran.so
ln -sf ../../../../%{_lib}/libgomp.so.1.* libgomp.so
%ifarch aarch64
%if %{build_libilp32}
ln -sf ../../../../libilp32/libobjc.so.4 ilp32/libobjc.so
ln -sf ../../../../libilp32/libstdc++.so.6.*[0-9] ilp32/libstdc++.so
ln -sf ../../../../libilp32/libgfortran.so.4.* ilp32/libgfortran.so
ln -sf ../../../../libilp32/libgomp.so.1.* ilp32/libgomp.so
%endif
%endif
#ln -sf ../../../../%{_lib}/libmudflap.so.0.* libmudflap.so
#ln -sf ../../../../%{_lib}/libmudflapth.so.0.* libmudflapth.so
%if %{build_go}
ln -sf ../../../../%{_lib}/libgo.so.4.* libgo.so
%ifarch  aarch64
%if %{build_libilp32}
ln -sf ../../../../libilp32/libgo.so.4.* ilp32/libgo.so
%endif
%endif
%endif
%if %{build_libquadmath}
ln -sf ../../../../%{_lib}/libquadmath.so.0.* libquadmath.so
%ifarch  aarch64
%if %{build_libilp32}
ln -sf ../../../../libilp32/libquadmath.so.0.* ilp32/libquadmath.so
%endif
%endif
%endif
%if %{build_libitm}
ln -sf ../../../../%{_lib}/libitm.so.1.* libitm.so
%ifarch  aarch64
%if %{build_libilp32}
ln -sf ../../../../libilp32/libitm.so.1.* ilp32/libitm.so
%endif
%endif
%endif
%if %{build_libatomic}
ln -sf ../../../../%{_lib}/libatomic.so.1.* libatomic.so
%ifarch  aarch64
%if %{build_libilp32}
ln -sf ../../../../libilp32/libatomic.so.1.* ilp32/libatomic.so
%endif
%endif
%endif
%if %{build_libasan}
ln -sf ../../../../%{_lib}/libasan.so.4.* libasan.so
mv ../../../../%{_lib}/libasan_preinit.o libasan_preinit.o
%ifarch  aarch64
%if %{build_libilp32}
ln -sf ../../../../libilp32/libasan.so.4.* ilp32/libasan.so
mv ../../../../libilp32/libasan_preinit.o ilp32/libasan_preinit.o
%endif
%endif
%endif
%if %{build_libtsan}
rm -f libtsan.so
echo 'INPUT ( %{_prefix}/%{_lib}/'`echo ../../../../%{_lib}/libtsan.so.0.* | sed 's,^.*libt,libt,'`' )' > libtsan.so
%ifarch  aarch64
%if %{build_libilp32}
echo 'INPUT ( %{_prefix}/libilp32/'`echo ../../../../libilp32/libtsan.so.0.* | sed 's,^.*libt,libt,'`' )' > ilp32/libtsan.so
%endif
%endif
%endif
%if %{build_java}
ln -sf ../../../../%{_lib}/libgcj.so.14.* libgcj.so
ln -sf ../../../../%{_lib}/libgcj-tools.so.14.* libgcj-tools.so
ln -sf ../../../../%{_lib}/libgij.so.14.* libgij.so
%ifarch  aarch64
%if %{build_libilp32}
ln -sf ../../../../libilp32/libgcj.so.14.* ilp32/libgcj.so
ln -sf ../../../../libilp32/libgcj-tools.so.14.* ilp32/libgcj-tools.so
ln -sf ../../../../libilp32/libgij.so.14.* ilp32/libgij.so
%endif
%endif
%endif
fi
%if %{build_java}
mv -f %{buildroot}%{_prefix}/%{_lib}/libgcj_bc.so $FULLLPATH/
%endif
mv -f %{buildroot}%{_prefix}/%{_lib}/libstdc++.*a $FULLLPATH/
mv -f %{buildroot}%{_prefix}/%{_lib}/libsupc++.*a $FULLLPATH/
mv -f %{buildroot}%{_prefix}/%{_lib}/libgfortran.*a $FULLLPATH/
mv -f %{buildroot}%{_prefix}/%{_lib}/libobjc.*a .
mv -f %{buildroot}%{_prefix}/%{_lib}/libgomp.*a .
%ifarch  aarch64
%if %{build_libilp32}
mv -f %{buildroot}%{_prefix}/libilp32/libstdc++.*a $FULLLPATH/ilp32/
mv -f %{buildroot}%{_prefix}/libilp32/libsupc++.*a $FULLLPATH/ilp32/
mv -f %{buildroot}%{_prefix}/libilp32/libgfortran.*a $FULLLPATH/ilp32/
mv -f %{buildroot}%{_prefix}/libilp32/libobjc.*a ./ilp32/
mv -f %{buildroot}%{_prefix}/libilp32/libgomp.*a ./ilp32/
%endif
%endif

#mv -f %{buildroot}%{_prefix}/%{_lib}/libmudflap{,th}.*a $FULLLPATH/
%if %{build_libquadmath}
mv -f %{buildroot}%{_prefix}/%{_lib}/libquadmath.*a $FULLLPATH/
%ifarch  aarch64
%if %{build_libilp32}
mv -f %{buildroot}%{_prefix}/libilp32/libquadmath.*a $FULLLPATH/ilp32/
%endif
%endif
%endif
%if %{build_libitm}
mv -f %{buildroot}%{_prefix}/%{_lib}/libitm.*a $FULLLPATH/
%ifarch  aarch64
%if %{build_libilp32}
mv -f %{buildroot}%{_prefix}/libilp32/libitm.*a $FULLLPATH/ilp32/
%endif
%endif
%endif
%if %{build_libatomic}
mv -f %{buildroot}%{_prefix}/%{_lib}/libatomic.*a $FULLLPATH/
%ifarch  aarch64
%if %{build_libilp32}
mv -f %{buildroot}%{_prefix}/libilp32/libatomic.*a $FULLLPATH/ilp32/
%endif
%endif
%endif
%if %{build_libasan}
mv -f %{buildroot}%{_prefix}/%{_lib}/libasan.*a $FULLLPATH/
%ifarch  aarch64
%if %{build_libilp32}
mv -f %{buildroot}%{_prefix}/libilp32/libasan.*a $FULLLPATH/ilp32/
%endif
%endif
%endif
%if %{build_libtsan}
mv -f %{buildroot}%{_prefix}/%{_lib}/libtsan.*a $FULLLPATH/
%ifarch  aarch64
%if %{build_libilp32}
mv -f %{buildroot}%{_prefix}/libilp32/libtsan.*a $FULLLPATH/ilp32/
%endif
%endif
%endif
%if %{build_go}
mv -f %{buildroot}%{_prefix}/%{_lib}/libgo.*a $FULLLPATH/
mv -f %{buildroot}%{_prefix}/%{_lib}/libgobegin.*a $FULLLPATH/
%ifarch  aarch64
%if %{build_libilp32}
mv -f %{buildroot}%{_prefix}/libilp32/libgo.*a $FULLLPATH/ilp32/
mv -f %{buildroot}%{_prefix}/libilp32/libgobegin.*a $FULLLPATH/ilp32/
%endif
%endif
%endif

%if %{build_ada}
%ifarch sparcv9 ppc
rm -rf $FULLPATH/64/ada{include,lib}
%endif
%ifarch %{multilib_64_archs}
rm -rf $FULLPATH/32/ada{include,lib}
%endif
if [ "$FULLPATH" != "$FULLLPATH" ]; then
mv -f $FULLPATH/ada{include,lib} $FULLLPATH/
pushd $FULLLPATH/adalib
if [ "%{_lib}" = "lib" ]; then
ln -sf ../../../../../libgnarl-*.so libgnarl.so
ln -sf ../../../../../libgnarl-*.so libgnarl-4.8.so
ln -sf ../../../../../libgnat-*.so libgnat.so
ln -sf ../../../../../libgnat-*.so libgnat-4.8.so
else
ln -sf ../../../../../../%{_lib}/libgnarl-*.so libgnarl.so
ln -sf ../../../../../../%{_lib}/libgnarl-*.so libgnarl-4.8.so
ln -sf ../../../../../../%{_lib}/libgnat-*.so libgnat.so
ln -sf ../../../../../../%{_lib}/libgnat-*.so libgnat-4.8.so
fi
popd
else
pushd $FULLPATH/adalib
if [ "%{_lib}" = "lib" ]; then
ln -sf ../../../../libgnarl-*.so libgnarl.so
ln -sf ../../../../libgnarl-*.so libgnarl-4.8.so
ln -sf ../../../../libgnat-*.so libgnat.so
ln -sf ../../../../libgnat-*.so libgnat-4.8.so
else
ln -sf ../../../../../%{_lib}/libgnarl-*.so libgnarl.so
ln -sf ../../../../../%{_lib}/libgnarl-*.so libgnarl-4.8.so
ln -sf ../../../../../%{_lib}/libgnat-*.so libgnat.so
ln -sf ../../../../../%{_lib}/libgnat-*.so libgnat-4.8.so
fi
popd
fi
%endif

%ifarch sparcv9 ppc
ln -sf ../../../../../lib64/libobjc.so.4 64/libobjc.so
ln -sf ../`echo ../../../../lib/libstdc++.so.6.*[0-9] | sed s~/lib/~/lib64/~` 64/libstdc++.so
ln -sf ../`echo ../../../../lib/libgfortran.so.4.* | sed s~/lib/~/lib64/~` 64/libgfortran.so
ln -sf ../`echo ../../../../lib/libgomp.so.1.* | sed s~/lib/~/lib64/~` 64/libgomp.so
#rm -f libmudflap.so libmudflapth.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libmudflap.so.0.* | sed 's,^.*libm,libm,'`' )' > libmudflap.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libmudflapth.so.0.* | sed 's,^.*libm,libm,'`' )' > libmudflapth.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libmudflap.so.0.* | sed 's,^.*libm,libm,'`' )' > 64/libmudflap.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libmudflapth.so.0.* | sed 's,^.*libm,libm,'`' )' > 64/libmudflapth.so
%if %{build_go}
rm -f libgo.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libgo.so.4.* | sed 's,^.*libg,libg,'`' )' > libgo.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libgo.so.4.* | sed 's,^.*libg,libg,'`' )' > 64/libgo.so
%endif
%if %{build_libquadmath}
rm -f libquadmath.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libquadmath.so.0.* | sed 's,^.*libq,libq,'`' )' > libquadmath.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libquadmath.so.0.* | sed 's,^.*libq,libq,'`' )' > 64/libquadmath.so
%endif
%if %{build_libitm}
rm -f libitm.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libitm.so.1.* | sed 's,^.*libi,libi,'`' )' > libitm.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libitm.so.1.* | sed 's,^.*libi,libi,'`' )' > 64/libitm.so
%endif
%if %{build_libatomic}
rm -f libatomic.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libatomic.so.1.* | sed 's,^.*liba,liba,'`' )' > libatomic.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libatomic.so.1.* | sed 's,^.*liba,liba,'`' )' > 64/libatomic.so
%endif
%if %{build_libasan}
rm -f libasan.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libasan.so.4.* | sed 's,^.*liba,liba,'`' )' > libasan.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libasan.so.4.* | sed 's,^.*liba,liba,'`' )' > 64/libasan.so
mv ../../../../lib64/libasan_preinit.o 64/libasan_preinit.o
%endif
%if %{build_java}
ln -sf ../`echo ../../../../lib/libgcj.so.14.* | sed s~/lib/~/lib64/~` 64/libgcj.so
ln -sf ../`echo ../../../../lib/libgcj-tools.so.14.* | sed s~/lib/~/lib64/~` 64/libgcj-tools.so
ln -sf ../`echo ../../../../lib/libgij.so.14.* | sed s~/lib/~/lib64/~` 64/libgij.so
ln -sf lib32/libgcj_bc.so libgcj_bc.so
ln -sf ../lib64/libgcj_bc.so 64/libgcj_bc.so
%endif
ln -sf lib32/libgfortran.a libgfortran.a
ln -sf ../lib64/libgfortran.a 64/libgfortran.a
mv -f %{buildroot}%{_prefix}/lib64/libobjc.*a 64/
mv -f %{buildroot}%{_prefix}/lib64/libgomp.*a 64/
ln -sf lib32/libstdc++.a libstdc++.a
ln -sf ../lib64/libstdc++.a 64/libstdc++.a
ln -sf lib32/libsupc++.a libsupc++.a
ln -sf ../lib64/libsupc++.a 64/libsupc++.a
#ln -sf lib32/libmudflap.a libmudflap.a
#ln -sf ../lib64/libmudflap.a 64/libmudflap.a
#ln -sf lib32/libmudflapth.a libmudflapth.a
#ln -sf ../lib64/libmudflapth.a 64/libmudflapth.a
%if %{build_libquadmath}
ln -sf lib32/libquadmath.a libquadmath.a
ln -sf ../lib64/libquadmath.a 64/libquadmath.a
%endif
%if %{build_libitm}
ln -sf lib32/libitm.a libitm.a
ln -sf ../lib64/libitm.a 64/libitm.a
%endif
%if %{build_libatomic}
ln -sf lib32/libatomic.a libatomic.a
ln -sf ../lib64/libatomic.a 64/libatomic.a
%endif
%if %{build_libasan}
ln -sf lib32/libasan.a libasan.a
ln -sf ../lib64/libasan.a 64/libasan.a
%endif
%if %{build_go}
ln -sf lib32/libgo.a libgo.a
ln -sf ../lib64/libgo.a 64/libgo.a
ln -sf lib32/libgobegin.a libgobegin.a
ln -sf ../lib64/libgobegin.a 64/libgobegin.a
%endif
%if %{build_ada}
ln -sf lib32/adainclude adainclude
ln -sf ../lib64/adainclude 64/adainclude
ln -sf lib32/adalib adalib
ln -sf ../lib64/adalib 64/adalib
%endif
%endif
%ifarch %{multilib_64_archs}
mkdir -p 32
ln -sf ../../../../libobjc.so.4 32/libobjc.so
ln -sf ../`echo ../../../../lib64/libstdc++.so.6.*[0-9] | sed s~/../lib64/~/~` 32/libstdc++.so
ln -sf ../`echo ../../../../lib64/libgfortran.so.4.* | sed s~/../lib64/~/~` 32/libgfortran.so
ln -sf ../`echo ../../../../lib64/libgomp.so.1.* | sed s~/../lib64/~/~` 32/libgomp.so
%if 0
rm -f libmudflap.so libmudflapth.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libmudflap.so.0.* | sed 's,^.*libm,libm,'`' )' > libmudflap.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libmudflapth.so.0.* | sed 's,^.*libm,libm,'`' )' > libmudflapth.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libmudflap.so.0.* | sed 's,^.*libm,libm,'`' )' > 32/libmudflap.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libmudflapth.so.0.* | sed 's,^.*libm,libm,'`' )' > 32/libmudflapth.so
%endif
%if %{build_go}
rm -f libgo.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libgo.so.4.* | sed 's,^.*libg,libg,'`' )' > libgo.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libgo.so.4.* | sed 's,^.*libg,libg,'`' )' > 32/libgo.so
%endif
%if %{build_libquadmath}
rm -f libquadmath.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libquadmath.so.0.* | sed 's,^.*libq,libq,'`' )' > libquadmath.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libquadmath.so.0.* | sed 's,^.*libq,libq,'`' )' > 32/libquadmath.so
%endif
%if %{build_libitm}
rm -f libitm.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libitm.so.1.* | sed 's,^.*libi,libi,'`' )' > libitm.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libitm.so.1.* | sed 's,^.*libi,libi,'`' )' > 32/libitm.so
%endif
%if %{build_libatomic}
rm -f libatomic.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libatomic.so.1.* | sed 's,^.*liba,liba,'`' )' > libatomic.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libatomic.so.1.* | sed 's,^.*liba,liba,'`' )' > 32/libatomic.so
%endif
%if %{build_libasan}
rm -f libasan.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libasan.so.4.* | sed 's,^.*liba,liba,'`' )' > libasan.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libasan.so.4.* | sed 's,^.*liba,liba,'`' )' > 32/libasan.so
mv ../../../../lib/libasan_preinit.o 32/libasan_preinit.o
%endif
%if %{build_java}
ln -sf ../`echo ../../../../lib64/libgcj.so.14.* | sed s~/../lib64/~/~` 32/libgcj.so
ln -sf ../`echo ../../../../lib64/libgcj-tools.so.14.* | sed s~/../lib64/~/~` 32/libgcj-tools.so
ln -sf ../`echo ../../../../lib64/libgij.so.14.* | sed s~/../lib64/~/~` 32/libgij.so
%endif
mv -f %{buildroot}%{_prefix}/lib/libobjc.*a 32/
mv -f %{buildroot}%{_prefix}/lib/libgomp.*a 32/
%endif
%ifarch sparc64 ppc64 ppc64p7
ln -sf ../lib32/libgfortran.a 32/libgfortran.a
ln -sf lib64/libgfortran.a libgfortran.a
ln -sf ../lib32/libstdc++.a 32/libstdc++.a
ln -sf lib64/libstdc++.a libstdc++.a
ln -sf ../lib32/libsupc++.a 32/libsupc++.a
ln -sf lib64/libsupc++.a libsupc++.a
#ln -sf ../lib32/libmudflap.a 32/libmudflap.a
#ln -sf lib64/libmudflap.a libmudflap.a
#ln -sf ../lib32/libmudflapth.a 32/libmudflapth.a
#ln -sf lib64/libmudflapth.a libmudflapth.a
%if %{build_libquadmath}
ln -sf ../lib32/libquadmath.a 32/libquadmath.a
ln -sf lib64/libquadmath.a libquadmath.a
%endif
%if %{build_libitm}
ln -sf ../lib32/libitm.a 32/libitm.a
ln -sf lib64/libitm.a libitm.a
%endif
%if %{build_libatomic}
ln -sf ../lib32/libatomic.a 32/libatomic.a
ln -sf lib64/libatomic.a libatomic.a
%endif
%if %{build_libasan}
ln -sf ../lib32/libasan.a 32/libasan.a
ln -sf lib64/libasan.a libasan.a
%endif
%if %{build_go}
ln -sf ../lib32/libgo.a 32/libgo.a
ln -sf lib64/libgo.a libgo.a
ln -sf ../lib32/libgobegin.a 32/libgobegin.a
ln -sf lib64/libgobegin.a libgobegin.a
%endif
%if %{build_java}
ln -sf ../lib32/libgcj_bc.so 32/libgcj_bc.so
ln -sf lib64/libgcj_bc.so libgcj_bc.so
%endif
%if %{build_ada}
ln -sf ../lib32/adainclude 32/adainclude
ln -sf lib64/adainclude adainclude
ln -sf ../lib32/adalib 32/adalib
ln -sf lib64/adalib adalib
%endif
%else
%ifarch %{multilib_64_archs}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libgfortran.a 32/libgfortran.a
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libstdc++.a 32/libstdc++.a
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libsupc++.a 32/libsupc++.a
#ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libmudflap.a 32/libmudflap.a
#ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libmudflapth.a 32/libmudflapth.a
%if %{build_libquadmath}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libquadmath.a 32/libquadmath.a
%endif
%if %{build_libitm}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libitm.a 32/libitm.a
%endif
%if %{build_libatomic}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libatomic.a 32/libatomic.a
%endif
%if %{build_libasan}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libasan.a 32/libasan.a
%endif
%if %{build_go}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libgo.a 32/libgo.a
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libgobegin.a 32/libgobegin.a
%endif
%if %{build_java}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/libgcj_bc.so 32/libgcj_bc.so
%endif
%if %{build_ada}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/adainclude 32/adainclude
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}/%{version}/adalib 32/adalib
%endif
%endif
%endif

# Strip debug info from Fortran/ObjC/Java static libraries
%if 0
strip -g `find . \( -name libgfortran.a -o -name libobjc.a -o -name libgomp.a \
		    -o -name libmudflap.a -o -name libmudflapth.a \
		    -o -name libgcc.a -o -name libgcov.a -o -name libquadmath.a \
		    -o -name libitm.a -o -name libgo.a -o -name libcaf\*.a \
		    -o -name libatomic.a -o -name libasan.a -o -name libtsan.a \) \
		 -a -type f`
%endif

strip -g `find . \( -name libgfortran.a -o -name libobjc.a -o -name libgomp.a \
                    -o -name libgcc.a -o -name libgcov.a -o -name libquadmath.a \
                    -o -name libitm.a -o -name libgo.a -o -name libcaf\*.a \
                    -o -name libatomic.a -o -name libasan.a -o -name libtsan.a \) \
                 -a -type f`


popd
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgfortran.so.4.*
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgomp.so.1.*
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libcc1.so.0.*
#chmod 755 %{buildroot}%{_prefix}/%{_lib}/libmudflap{,th}.so.0.*
%if %{build_libquadmath}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libquadmath.so.0.*
%endif
%if %{build_libitm}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libitm.so.1.*
%endif
%if %{build_libatomic}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libatomic.so.1.*
%endif
%if %{build_libasan}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libasan.so.4.*
%endif
%if %{build_libtsan}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libtsan.so.0.*
%endif
%if %{build_go}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgo.so.4.*
%endif
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libobjc.so.4.*

%if %{build_ada}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgnarl*so*
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgnat*so*
%endif

mv $FULLHPATH/include-fixed/syslimits.h $FULLHPATH/include/syslimits.h
mv $FULLHPATH/include-fixed/limits.h $FULLHPATH/include/limits.h
for h in `find $FULLHPATH/include -name \*.h`; do
  if grep -q 'It has been auto-edited by fixincludes from' $h; then
    rh=`grep -A2 'It has been auto-edited by fixincludes from' $h | tail -1 | sed 's|^.*"\(.*\)".*$|\1|'`
    diff -up $rh $h || :
    rm -f $h
  fi
done

cat > %{buildroot}%{_prefix}/bin/c89 <<"EOF"
#!/bin/sh
fl="-std=c89"
for opt; do
  case "$opt" in
    -ansi|-std=c89|-std=iso9899:1990) fl="";;
    -std=*) echo "`basename $0` called with non ANSI/ISO C option $opt" >&2
	    exit 1;;
  esac
done
exec gcc $fl ${1+"$@"}
EOF
cat > %{buildroot}%{_prefix}/bin/c99 <<"EOF"
#!/bin/sh
fl="-std=c99"
for opt; do
  case "$opt" in
    -std=c99|-std=iso9899:1999) fl="";;
    -std=*) echo "`basename $0` called with non ISO C99 option $opt" >&2
	    exit 1;;
  esac
done
exec gcc $fl ${1+"$@"}
EOF
chmod 755 %{buildroot}%{_prefix}/bin/c?9

%if "%{version}" != "%{gcc_version}"
mv -f $RPM_BUILD_ROOT%{_prefix}/libexec/gcc/%{gcc_target_platform}/{%{version},%{gcc_version}}
ln -sf %{gcc_version} $RPM_BUILD_ROOT%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
mv -f $RPM_BUILD_ROOT%{_prefix}/lib/gcc/%{gcc_target_platform}/{%{version},%{gcc_version}}
ln -sf %{gcc_version} $RPM_BUILD_ROOT%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
mv -f $RPM_BUILD_ROOT%{_prefix}/include/c++/{%{version},%{gcc_version}}
ln -sf %{gcc_version} $RPM_BUILD_ROOT%{_prefix}/include/c++/%{version}
mv -f $RPM_BUILD_ROOT%{_prefix}/share/gcc-{%{version},%{gcc_version}}
ln -sf gcc-%{gcc_version} $RPM_BUILD_ROOT%{_prefix}/share/gcc-%{version}
%if %{build_java}
mv -f $RPM_BUILD_ROOT%{_prefix}/%{_lib}/gcj-{%{version},%{gcc_version}}
ln -sf gcj-%{gcc_version} $RPM_BUILD_ROOT%{_prefix}/%{_lib}/gcj-%{version}
mv -f $RPM_BUILD_ROOT%{_prefix}/share/java/libgcj-{%{version},%{gcc_version}}.jar
ln -sf libgcj-%{gcc_version}.jar $RPM_BUILD_ROOT%{_prefix}/share/java/libgcj-%{version}.jar
mv -f $RPM_BUILD_ROOT%{_prefix}/share/java/libgcj-tools-{%{version},%{gcc_version}}.jar
ln -sf libgcj-tools-%{gcc_version}.jar $RPM_BUILD_ROOT%{_prefix}/share/java/libgcj-tools-%{version}.jar
mv -f $RPM_BUILD_ROOT%{_prefix}/share/java/src-{%{version},%{gcc_version}}.zip
ln -sf src-%{gcc_version}.zip $RPM_BUILD_ROOT%{_prefix}/share/java/src-%{version}.zip
%endif
%if %{build_go}
mv -f $RPM_BUILD_ROOT%{_prefix}/%{_lib}/go/{%{version},%{gcc_version}}
ln -sf %{gcc_version} $RPM_BUILD_ROOT%{_prefix}/%{_lib}/go/%{version}
%endif
%endif

cd ..
%find_lang %{name}
%find_lang cpplib

# Remove binaries we will not be including, so that they don't end up in
# gcc-debuginfo
rm -f %{buildroot}%{_prefix}/%{_lib}/{libffi*,libiberty.a}
rm -f $FULLEPATH/install-tools/{mkheaders,fixincl}
rm -f %{buildroot}%{_prefix}/lib/{32,64}/libiberty.a
rm -f %{buildroot}%{_prefix}/%{_lib}/libssp*
rm -f %{buildroot}%{_prefix}/bin/gappletviewer || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gcc-%{version} || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gfortran || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gccgo || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gcj || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gcc-ar || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gcc-nm || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gcc-ranlib || :

%ifarch %{multilib_64_archs}
# Remove libraries for the other arch on multilib arches
rm -f %{buildroot}%{_prefix}/lib/lib*.so*
rm -f %{buildroot}%{_prefix}/lib/lib*.a
rm -f %{buildroot}/lib/libgcc_s*.so*
%if %{build_go}
%if "%{version}" != "%{gcc_version}"
mv -f $RPM_BUILD_ROOT%{_prefix}/lib/go/{%{version},%{gcc_version}}
ln -sf %{gcc_version} $RPM_BUILD_ROOT%{_prefix}/lib/go/%{version}
%endif
rm -rf %{buildroot}%{_prefix}/lib/go/%{gcc_version}/%{gcc_target_platform}
%ifnarch sparc64 ppc64 ppc64p7
ln -sf %{multilib_32_arch}-%{_vendor}-%{_target_os} %{buildroot}%{_prefix}/lib/go/%{gcc_version}/%{gcc_target_platform}
%endif
%endif
%else
%ifarch sparcv9 ppc
rm -f %{buildroot}%{_prefix}/lib64/lib*.so*
rm -f %{buildroot}%{_prefix}/lib64/lib*.a
rm -f %{buildroot}/lib64/libgcc_s*.so*
%if %{build_go}
%if "%{version}" != "%{gcc_version}"
mv -f $RPM_BUILD_ROOT%{_prefix}/lib64/go/{%{version},%{gcc_version}}
ln -sf %{gcc_version} $RPM_BUILD_ROOT%{_prefix}/lib64/go/%{version}
%endif
rm -rf %{buildroot}%{_prefix}/lib64/go/%{gcc_version}/%{gcc_target_platform}
%endif
%endif
%endif

%if %{build_java}
mkdir -p %{buildroot}%{_prefix}/share/java/gcj-endorsed \
	 %{buildroot}%{_prefix}/%{_lib}/gcj-%{gcc_version}/classmap.db.d
chmod 755 %{buildroot}%{_prefix}/share/java/gcj-endorsed \
	  %{buildroot}%{_prefix}/%{_lib}/gcj-%{gcc_version} \
	  %{buildroot}%{_prefix}/%{_lib}/gcj-%{gcc_version}/classmap.db.d
touch %{buildroot}%{_prefix}/%{_lib}/gcj-%{gcc_version}/classmap.db
%endif

rm -f %{buildroot}%{mandir}/man3/ffi*

# Help plugins find out nvra.
echo gcc-%{version}-%{release}.%{_arch} > $FULLHPATH/rpmver

%check

%if %{build_check}

cd obj-%{gcc_target_platform}

%if %{build_java}
export PATH=`pwd`/../fastjar-%{fastjar_ver}/obj-%{gcc_target_platform}${PATH:+:$PATH}
%if !%{bootstrap_java}
export PATH=`pwd`/java_hacks${PATH:+:$PATH}
%endif
%endif
%if 0
# run the tests.
make %{?_smp_mflags} -k check ALT_CC_UNDER_TEST=gcc ALT_CXX_UNDER_TEST=g++ \
RUNTESTFLAGS="--target_board=unix/'{,-fstack-protector-strong}'" || :
echo ====================TESTING=========================
( LC_ALL=C ../contrib/test_summary || : ) 2>&1 | sed -n '/^cat.*EOF/,/^EOF/{/^cat.*EOF/d;/^EOF/d;/^LAST_UPDATED:/d;p;}'
echo ====================TESTING END=====================
mkdir testlogs-%{_target_platform}-%{version}-%{release}
for i in `find . -name \*.log | grep -F testsuite/ | grep -v 'config.log\|acats.*/tests/'`; do
  ln $i testlogs-%{_target_platform}-%{version}-%{release}/ || :
done
tar cf - testlogs-%{_target_platform}-%{version}-%{release} | bzip2 -9c \
  | uuencode testlogs-%{_target_platform}.tar.bz2 || :
rm -rf testlogs-%{_target_platform}-%{version}-%{release}
%endif

%endif #build_check

%clean
rm -rf %{buildroot}

%post
if [ -f %{_infodir}/gcc.info.gz ]; then
  /sbin/install-info \
    --info-dir=%{_infodir} %{_infodir}/gcc.info.gz || :
fi

%preun
if [ $1 = 0 -a -f %{_infodir}/gcc.info.gz ]; then
  /sbin/install-info --delete \
    --info-dir=%{_infodir} %{_infodir}/gcc.info.gz || :
fi

%post -n cpp
if [ -f %{_infodir}/cpp.info.gz ]; then
  /sbin/install-info \
    --info-dir=%{_infodir} %{_infodir}/cpp.info.gz || :
fi

%preun -n cpp
if [ $1 = 0 -a -f %{_infodir}/cpp.info.gz ]; then
  /sbin/install-info --delete \
    --info-dir=%{_infodir} %{_infodir}/cpp.info.gz || :
fi

#%post gfortran
#if [ -f %{_infodir}/gfortran.info.gz ]; then
#  /sbin/install-info \
#    --info-dir=%{_infodir} %{_infodir}/gfortran.info.gz || :
#fi

#%preun gfortran
#if [ $1 = 0 -a -f %{_infodir}/gfortran.info.gz ]; then
#  /sbin/install-info --delete \
#    --info-dir=%{_infodir} %{_infodir}/gfortran.info.gz || :
#fi

#%post java
#if [ -f %{_infodir}/gcj.info.gz ]; then
#/sbin/install-info \
#  --info-dir=%{_infodir} %{_infodir}/gcj.info.gz || :
#fi

#%preun java
#if [ $1 = 0 -a -f %{_infodir}/gcj.info.gz ]; then
#  /sbin/install-info --delete \
#    --info-dir=%{_infodir} %{_infodir}/gcj.info.gz || :
#fi

#%post gnat
#if [ -f %{_infodir}/gnat_rm.info.gz ]; then
#  /sbin/install-info \
#    --info-dir=%{_infodir} %{_infodir}/gnat_rm.info.gz || :
#  /sbin/install-info \
#    --info-dir=%{_infodir} %{_infodir}/gnat_ugn.info.gz || :
#  /sbin/install-info \
#    --info-dir=%{_infodir} %{_infodir}/gnat-style.info.gz || :
#fi

#%preun gnat
#if [ $1 = 0 -a -f %{_infodir}/gnat_rm.info.gz ]; then
#  /sbin/install-info --delete \
#    --info-dir=%{_infodir} %{_infodir}/gnat_rm.info.gz || :
#  /sbin/install-info --delete \
#    --info-dir=%{_infodir} %{_infodir}/gnat_ugn.info.gz || :
#  /sbin/install-info --delete \
#    --info-dir=%{_infodir} %{_infodir}/gnat-style.info.gz || :
#fi

# Because glibc Prereq's libgcc and /sbin/ldconfig
# comes from glibc, it might not exist yet when
# libgcc is installed
#%post -n libgcc -p <lua>
#if posix.access ("/sbin/ldconfig", "x") then
#  local pid = posix.fork ()
#  if pid == 0 then
#    posix.exec ("/sbin/ldconfig")
#  elseif pid ~= -1 then
#    posix.wait (pid)
#  end
#end

#%postun -n libgcc -p <lua>
#if posix.access ("/sbin/ldconfig", "x") then
#  local pid = posix.fork ()
#  if pid == 0 then
#    posix.exec ("/sbin/ldconfig")
#  elseif pid ~= -1 then
#    posix.wait (pid)
#  end
#end

%post -n libstdc++ -p /sbin/ldconfig

%postun -n libstdc++ -p /sbin/ldconfig

#%post -n libobjc -p /sbin/ldconfig

#%postun -n libobjc -p /sbin/ldconfig

#%post -n libgcj
#/sbin/ldconfig
#if [ -f %{_infodir}/cp-tools.info.gz ]; then
#  /sbin/install-info \
#    --info-dir=%{_infodir} %{_infodir}/cp-tools.info.gz || :
#  /sbin/install-info \
#    --info-dir=%{_infodir} %{_infodir}/fastjar.info.gz || :
#fi

#%preun -n libgcj
#if [ $1 = 0 -a -f %{_infodir}/cp-tools.info.gz ]; then
#  /sbin/install-info --delete \
#    --info-dir=%{_infodir} %{_infodir}/cp-tools.info.gz || :
#  /sbin/install-info --delete \
#    --info-dir=%{_infodir} %{_infodir}/fastjar.info.gz || :
#fi

#%postun -n libgcj -p /sbin/ldconfig

#%post -n libgfortran -p /sbin/ldconfig

#%postun -n libgfortran -p /sbin/ldconfig

#%post -n libgnat -p /sbin/ldconfig

#%postun -n libgnat -p /sbin/ldconfig

%post -n libgomp
/sbin/ldconfig
if [ -f %{_infodir}/libgomp.info.gz ]; then
  /sbin/install-info \
    --info-dir=%{_infodir} %{_infodir}/libgomp.info.gz || :
fi

%preun -n libgomp
if [ $1 = 0 -a -f %{_infodir}/libgomp.info.gz ]; then
  /sbin/install-info --delete \
    --info-dir=%{_infodir} %{_infodir}/libgomp.info.gz || :
fi

%postun -n libgomp -p /sbin/ldconfig

#%post -n libmudflap -p /sbin/ldconfig

#%postun -n libmudflap -p /sbin/ldconfig

#%post -n libquadmath
#/sbin/ldconfig
#if [ -f %{_infodir}/libquadmath.info.gz ]; then
#  /sbin/install-info \
#    --info-dir=%{_infodir} %{_infodir}/libquadmath.info.gz || :
#fi

#%preun -n libquadmath
#if [ $1 = 0 -a -f %{_infodir}/libquadmath.info.gz ]; then
#  /sbin/install-info --delete \
#    --info-dir=%{_infodir} %{_infodir}/libquadmath.info.gz || :
#fi

#%postun -n libquadmath -p /sbin/ldconfig

#%post -n libitm
#/sbin/ldconfig
#if [ -f %{_infodir}/libitm.info.gz ]; then
#  /sbin/install-info \
#    --info-dir=%{_infodir} %{_infodir}/libitm.info.gz || :
#fi

#%preun -n libitm
#if [ $1 = 0 -a -f %{_infodir}/libitm.info.gz ]; then
#  /sbin/install-info --delete \
#    --info-dir=%{_infodir} %{_infodir}/libitm.info.gz || :
#fi

#%postun -n libitm -p /sbin/ldconfig

#%post -n libatomic -p /sbin/ldconfig

#%postun -n libatomic -p /sbin/ldconfig

#%post -n libasan -p /sbin/ldconfig

#%postun -n libasan -p /sbin/ldconfig

#%post -n libtsan -p /sbin/ldconfig

#%postun -n libtsan -p /sbin/ldconfig

#%post -n libgo -p /sbin/ldconfig

#%postun -n libgo -p /sbin/ldconfig

%files -f %{name}.lang
%defattr(-,root,root,-)
%{_prefix}/bin/cc
%{_prefix}/bin/c89
%{_prefix}/bin/c99
%{_prefix}/bin/gcc
%{_prefix}/bin/gcov
%{_prefix}/bin/gcc-ar
%{_prefix}/bin/gcc-nm
%{_prefix}/bin/gcc-ranlib
%ifarch ppc
%{_prefix}/bin/%{_target_platform}-gcc
%endif
%ifarch sparc64 sparcv9
%{_prefix}/bin/sparc-%{_vendor}-%{_target_os}-gcc
%endif
%ifarch ppc64 ppc64p7
%{_prefix}/bin/ppc-%{_vendor}-%{_target_os}-gcc
%endif
%{_prefix}/bin/%{gcc_target_platform}-gcc
%{_mandir}/man1/gcc.1*
%{_mandir}/man1/gcov.1*
%{_infodir}/gcc*
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/lto1
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/lto-wrapper
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/liblto_plugin.so*
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/rpmver
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stddef.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdarg.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdfix.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/varargs.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/float.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/limits.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdbool.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/iso646.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/syslimits.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/unwind.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/omp.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/openacc.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdint.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdint-gcc.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdalign.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdnoreturn.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdatomic.h
%ifarch %{ix86} x86_64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/emmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/pmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/tmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ammintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/smmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/nmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/bmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/wmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/immintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avxintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/x86intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/fma4intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xopintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/lwpintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/popcntintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/bmiintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/tbmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ia32intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx2intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/bmi2intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/f16cintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/fmaintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/lzcntintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/rtmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xtestintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/adxintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/prfchwintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/rdseedintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/fxsrintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xsaveintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xsaveoptintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mm_malloc.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mm3dnow.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cpuid.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cross-stdarg.h

%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx5124fmapsintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx5124vnniwintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512bwintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512cdintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512dqintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512erintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512fintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512ifmaintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512ifmavlintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512pfintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512vbmiintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512vbmivlintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512vlbwintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512vldqintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512vlintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx512vpopcntdqintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/cilk.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/cilk_api.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/cilk_api_linux.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/cilk_stub.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/cilk_undocumented.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/common.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/holder.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/hyperobject_base.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/metaprogramming.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_file.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_list.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_max.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_min.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_min_max.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_opadd.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_opand.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_opmul.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_opor.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_opxor.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_ostream.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cilk/reducer_string.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/clflushoptintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/clwbintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/clzerointrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/gcov.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mwaitxintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/pkuintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/quadmath.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/quadmath_weak.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/sgxintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/shaintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xsavecintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xsavesintrin.h
%endif
%ifarch ia64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ia64intrin.h
%endif
%ifarch ppc ppc64 ppc64le ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ppc-asm.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/altivec.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/spe.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/paired.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ppu_intrinsics.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/si2vmx.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/spu2vmx.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/vec_types.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/htmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/htmxlintrin.h
%endif
%ifarch %{arm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/unwind-arm-common.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/arm_neon.h
%endif
%ifarch aarch64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/arm_neon.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/arm_fp16.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/arm_acle.h
%endif
%ifarch sparc sparcv9 sparc64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/visintrin.h
%endif
%ifarch s390 s390x
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/s390intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/htmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/htmxlintrin.h
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/sanitizer
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/collect2
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/crt*.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcov.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcc_eh.a
%ifnarch aarch64_ilp32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcc_s.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgomp.spec
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgomp.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgomp.so
%if %{build_libitm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libitm.spec
%endif
%if %{build_cloog}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libcloog-isl.so.*
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libsanitizer.spec
%endif
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/crt*.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcov.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcc_eh.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcc_s.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgomp.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgomp.so
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libmudflap.a
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libmudflapth.a
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libmudflap.so
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libmudflapth.so
%if %{build_libquadmath}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libquadmath.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libquadmath.so
%endif
%if %{build_libitm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libitm.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libitm.so
%endif
%if %{build_libatomic}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libatomic.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libatomic.so
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libasan.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libasan.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libasan_preinit.o
%endif
%endif
%ifarch  aarch64 aarch64_ilp32
%if %{build_libilp32}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libgomp.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libgomp.so
%endif
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/crt*.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcov.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcc_eh.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcc_s.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgomp.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgomp.so
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libmudflap.a
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libmudflapth.a
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libmudflap.so
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libmudflapth.so
%if %{build_libquadmath}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libquadmath.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libquadmath.so
%endif
%if %{build_libitm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libitm.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libitm.so
%endif
%if %{build_libatomic}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libatomic.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libatomic.so
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libasan.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libasan.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libasan_preinit.o
%endif
%endif
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflap.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflapth.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflap.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflapth.so
%if %{build_libquadmath}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libquadmath.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libquadmath.so
%endif
%if %{build_libitm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libitm.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libitm.so
%endif
%if %{build_libatomic}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libatomic.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libatomic.so
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan_preinit.o
%endif
%if %{build_libtsan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libtsan.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libtsan.so
%endif
%else
%if %{build_libatomic}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libatomic.so
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan_preinit.o
%endif
%if %{build_libtsan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libtsan.so
%endif
%endif
%ifarch  aarch64 arch64_ilp32
%if %{build_libilp32}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libgcc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libgcc_eh.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/crtfastmath.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/crtend.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/crtendS.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/crtbeginT.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/crtbegin.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libgcov.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/crtbeginS.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libgcc_s.so
%endif
%endif
%dir %{_prefix}/libexec/getconf
%{_prefix}/libexec/getconf/default
#%doc gcc/README* rpm.doc/changelogs/gcc/ChangeLog* gcc/COPYING* COPYING.RUNTIME

%files -n cpp -f cpplib.lang
%defattr(-,root,root,-)
%{_prefix}/lib/cpp
%{_prefix}/bin/cpp
%{_mandir}/man1/cpp.1*
%{_infodir}/cpp*
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/cc1

%files -n libgcc
%defattr(-,root,root,-)
/%{_lib}/libgcc_s-%{version}-%{DATE}.so.1
/%{_lib}/libgcc_s.so.1
%doc gcc/COPYING* COPYING.RUNTIME

%ifarch aarch64
%if %{build_libilp32}
%files -n libgcc-32
%defattr(-,root,root,-)
/libilp32/libgcc_s-%{version}-%{DATE}.so.1
/libilp32/libgcc_s.so.1
%endif
%endif

%files c++
%defattr(-,root,root,-)
%{_prefix}/bin/%{gcc_target_platform}-*++
%{_prefix}/bin/g++
%{_prefix}/bin/c++
%{_mandir}/man1/g++.1*
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/cc1plus
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libstdc++.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libsupc++.a
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libstdc++.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libsupc++.a
%endif
%ifarch  aarch64 aarch64_ilp32
%if %{build_libilp32}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libstdc++.so
%endif
%endif
%ifarch sparcv9 ppc %{multilib_64_archs}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libstdc++.so
%endif
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libsupc++.a
%endif
#%doc rpm.doc/changelogs/gcc/cp/ChangeLog*

%files -n libstdc++
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libstdc++.so.6*
%dir %{_datadir}/gdb
%dir %{_datadir}/gdb/auto-load
%dir %{_datadir}/gdb/auto-load/%{_prefix}
%dir %{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}/
%{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}/libstdc*gdb.py*
%dir %{_prefix}/share/gcc-%{gcc_version}
%dir %{_prefix}/share/gcc-%{gcc_version}/python
%if "%{version}" != "%{gcc_version}"
%{_prefix}/share/gcc-%{version}
%endif
%{_prefix}/share/gcc-%{gcc_version}/python/libstdcxx

%ifarch aarch64
%if %{build_libilp32}
%files -n libstdc++-32
%defattr(-,root,root,-)
%{_prefix}/libilp32/libstdc++.so.6*
%dir %{_datadir}/gdb/auto-load/%{_prefix}/libilp32/
%{_datadir}/gdb/auto-load/%{_prefix}/libilp32/libstdc*gdb.py*
%endif
%endif

%files -n libstdc++-devel
%defattr(-,root,root,-)
%dir %{_prefix}/include/c++
%dir %{_prefix}/include/c++/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/include/c++/%{version}
%endif
%{_prefix}/include/c++/%{gcc_version}/[^gjos]*
%{_prefix}/include/c++/%{gcc_version}/os*
%{_prefix}/include/c++/%{gcc_version}/op*
%{_prefix}/include/c++/%{gcc_version}/s[^u]*
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifnarch sparcv9 ppc %{multilib_64_archs} aarch64_ilp32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libstdc++.so
%endif
#%doc rpm.doc/changelogs/libstdc++-v3/ChangeLog* libstdc++-v3/README*

%files -n libstdc++-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libsupc++.a
%endif
%ifarch  aarch64 aarch64_ilp32
%if %{build_libilp32}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libsupc++.a
%endif
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libsupc++.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7 aarch64_ilp32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libsupc++.a
%endif

%if %{build_libstdcxx_docs}
%files -n libstdc++-docs
%defattr(-,root,root)
%{_mandir}/man3/*
%doc rpm.doc/libstdc++-v3/html
%endif


%files objc
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/objc
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/cc1obj
%ifnarch aarch64_ilp32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libobjc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libobjc.so
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libobjc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libobjc.so
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libobjc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libobjc.so
%endif
%ifarch aarch64 aarch64_ilp32
%if %{build_libilp32}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libobjc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libobjc.so
%endif
%endif
#%doc rpm.doc/objc/*
#%doc libobjc/THREADS* rpm.doc/changelogs/libobjc/ChangeLog*

%files objc++
%defattr(-,root,root,-)
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/cc1objplus

%files -n libobjc
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libobjc.so.4*

%ifarch aarch64
%if %{build_libilp32}
%files -n libobjc-32
%defattr(-,root,root,-)
%{_prefix}/libilp32/libobjc.so.4*
%endif
%endif

%files gfortran
%defattr(-,root,root,-)
%{_prefix}/bin/gfortran
%{_prefix}/bin/f95
%{_mandir}/man1/gfortran.1*
%{_infodir}/gfortran*
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/omp_lib.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/omp_lib.f90
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/omp_lib.mod
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/omp_lib_kinds.mod
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/openacc.f90
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/openacc.mod
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/openacc_kinds.mod
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/openacc_lib.h
%ifarch x86_64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/ieee_arithmetic.mod
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/ieee_exceptions.mod
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/ieee_features.mod
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/f951
%ifnarch aarch64_ilp32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgfortran.spec
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgfortranbegin.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libcaf_single.a
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgfortran.a
%endif
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgfortran.so
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgfortranbegin.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libcaf_single.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgfortran.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgfortran.so
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgfortranbegin.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libcaf_single.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgfortran.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgfortran.so
%endif
%ifarch aarch64 aarch64_ilp32
%if %{build_libilp32}
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libgfortranbegin.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libcaf_single.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libgfortran.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/ilp32/libgfortran.so
%endif
%endif
#%doc rpm.doc/gfortran/*

%files -n libgfortran
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libgfortran.so.4*

%ifarch aarch64
%if %{build_libilp32}
%files -n libgfortran-32
%defattr(-,root,root,-)
%{_prefix}/libilp32/libgfortran.so.4*
%endif
%endif

%if 0
%files -n libgfortran-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libgfortran.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libgfortran.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgfortran.a
%endif
%endif

%if %{build_java}
%files java
%defattr(-,root,root,-)
%{_prefix}/bin/gcj
%{_prefix}/bin/gjavah
%{_prefix}/bin/gcjh
%{_prefix}/bin/jcf-dump
%{_mandir}/man1/gcj.1*
%{_mandir}/man1/jcf-dump.1*
%{_mandir}/man1/gjavah.1*
%{_mandir}/man1/gcjh.1*
%{_infodir}/gcj*
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/jc1
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/ecj1
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/jvgenmain
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcj.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcj-tools.so
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcj_bc.so
%endif
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgij.so
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcj.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcj-tools.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcj_bc.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgij.so
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcj.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcj-tools.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcj_bc.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgij.so
%endif
#%doc rpm.doc/changelogs/gcc/java/ChangeLog*

%files -n libgcj
%defattr(-,root,root,-)
%{_prefix}/bin/jv-convert
%{_prefix}/bin/gij
%{_prefix}/bin/gjar
%{_prefix}/bin/fastjar
%{_prefix}/bin/gnative2ascii
%{_prefix}/bin/grepjar
%{_prefix}/bin/grmic
%{_prefix}/bin/grmid
%{_prefix}/bin/grmiregistry
%{_prefix}/bin/gtnameserv
%{_prefix}/bin/gkeytool
%{_prefix}/bin/gorbd
%{_prefix}/bin/gserialver
%{_prefix}/bin/gcj-dbtool
%{_prefix}/bin/gjarsigner
%{_mandir}/man1/fastjar.1*
%{_mandir}/man1/grepjar.1*
%{_mandir}/man1/gjar.1*
%{_mandir}/man1/gjarsigner.1*
%{_mandir}/man1/jv-convert.1*
%{_mandir}/man1/gij.1*
%{_mandir}/man1/gnative2ascii.1*
%{_mandir}/man1/grmic.1*
%{_mandir}/man1/grmiregistry.1*
%{_mandir}/man1/gcj-dbtool.1*
%{_mandir}/man1/gkeytool.1*
%{_mandir}/man1/gorbd.1*
%{_mandir}/man1/grmid.1*
%{_mandir}/man1/gserialver.1*
%{_mandir}/man1/gtnameserv.1*
%{_infodir}/fastjar.info*
%{_infodir}/cp-tools.info*
%{_prefix}/%{_lib}/libgcj.so.*
%{_prefix}/%{_lib}/libgcj-tools.so.*
%{_prefix}/%{_lib}/libgcj_bc.so.*
%{_prefix}/%{_lib}/libgij.so.*
%dir %{_prefix}/%{_lib}/gcj-%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/%{_lib}/gcj-%{version}
%endif
%{_prefix}/%{_lib}/gcj-%{gcc_version}/libgtkpeer.so
%{_prefix}/%{_lib}/gcj-%{gcc_version}/libgjsmalsa.so
%{_prefix}/%{_lib}/gcj-%{gcc_version}/libjawt.so
%{_prefix}/%{_lib}/gcj-%{gcc_version}/libjvm.so
%{_prefix}/%{_lib}/gcj-%{gcc_version}/libjavamath.so
%dir %{_prefix}/share/java
%{_prefix}/share/java/[^sl]*
%{_prefix}/share/java/libgcj-%{gcc_version}.jar
%if "%{version}" != "%{gcc_version}"
%{_prefix}/share/java/libgcj-%{version}.jar
%endif
%dir %{_prefix}/%{_lib}/security
%config(noreplace) %{_prefix}/%{_lib}/security/classpath.security
%{_prefix}/%{_lib}/logging.properties
%dir %{_prefix}/%{_lib}/gcj-%{gcc_version}/classmap.db.d
%attr(0644,root,root) %verify(not md5 size mtime) %ghost %config(missingok,noreplace) %{_prefix}/%{_lib}/gcj-%{gcc_version}/classmap.db

%files -n libgcj-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/gcj
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/jawt.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/jawt_md.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/jni.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/jni_md.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/jvmpi.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcj.spec
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libgcj_bc.so
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libgcj_bc.so
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcj_bc.so
%endif
%dir %{_prefix}/include/c++
%dir %{_prefix}/include/c++/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/include/c++/%{version}
%endif
%{_prefix}/include/c++/%{gcc_version}/[gj]*
%{_prefix}/include/c++/%{gcc_version}/org
%{_prefix}/include/c++/%{gcc_version}/sun
%{_prefix}/%{_lib}/pkgconfig/libgcj-*.pc
%doc rpm.doc/boehm-gc/* rpm.doc/fastjar/* rpm.doc/libffi/*
%doc rpm.doc/libjava/*

%files -n libgcj-src
%defattr(-,root,root,-)
%dir %{_prefix}/share/java
%{_prefix}/share/java/src*.zip
%{_prefix}/share/java/libgcj-tools-%{gcc_version}.jar
%if "%{version}" != "%{gcc_version}"
%{_prefix}/share/java/libgcj-tools-%{version}.jar
%endif
%endif

%if %{build_ada}
%files gnat
%defattr(-,root,root,-)
%{_prefix}/bin/gnat
%{_prefix}/bin/gnat[^i]*
%{_infodir}/gnat*
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/adalib
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/adalib
%endif
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/gnat1
#%doc rpm.doc/changelogs/gcc/ada/ChangeLog*

%files -n libgnat
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libgnat-*.so
%{_prefix}/%{_lib}/libgnarl-*.so

%files -n libgnat-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adalib
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adalib/libgnat.a
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adalib/libgnarl.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adalib
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adalib/libgnat.a
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adalib/libgnarl.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib/libgnat.a
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib/libgnarl.a
%endif

%files -n libgnat-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adalib
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adalib/libgnat.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adalib/libgnarl.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adalib
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adalib/libgnat.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adalib/libgnarl.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib/libgnat.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib/libgnarl.a
%endif
%endif

%files -n libgomp
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libgomp.so.1*
%{_infodir}/libgomp.info*
#%doc rpm.doc/changelogs/libgomp/ChangeLog*

%ifarch aarch64
%if %{build_libilp32}
%files -n libgomp-32
%defattr(-,root,root,-)
%{_prefix}/libilp32/libgomp.so.1*
%endif
%endif

%if 0
%files -n libmudflap
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libmudflap.so.0*
%{_prefix}/%{_lib}/libmudflapth.so.0*

%files -n libmudflap-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mf-runtime.h
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflap.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflapth.so
%endif
#%doc rpm.doc/changelogs/libmudflap/ChangeLog*

%files -n libmudflap-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libmudflap.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libmudflapth.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libmudflap.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libmudflapth.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflap.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflapth.a
%endif
%endif

%if %{build_libquadmath}
%files -n libquadmath
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libquadmath.so.0*
%{_infodir}/libquadmath.info*
#%%doc rpm.doc/libquadmath/COPYING*

%files -n libquadmath-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/quadmath.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/quadmath_weak.h
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libquadmath.so
%endif
#%doc rpm.doc/libquadmath/ChangeLog*

%files -n libquadmath-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libquadmath.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libquadmath.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libquadmath.a
%endif
%endif

%if %{build_libitm}
%files -n libitm
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libitm.so.1*
%{_infodir}/libitm.info*

%files -n libitm-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/itm.h
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/itm_weak.h
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libitm.so
%endif
#%doc rpm.doc/libitm/ChangeLog*

%files -n libitm-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libitm.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libitm.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libitm.a
%endif
%endif

%if %{build_libatomic}
%files -n libatomic
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libatomic.so.1*

%files -n libatomic-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libatomic.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libatomic.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libatomic.a
%endif
#%doc rpm.doc/changelogs/libatomic/ChangeLog*
%endif

%if %{build_libasan}
%files -n libasan
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libasan.so.4*

%files -n libasan-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libasan.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libasan.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan.a
%endif
#%doc rpm.doc/changelogs/libsanitizer/ChangeLog* libsanitizer/LICENSE.TXT
%endif

%if %{build_libtsan}
%files -n libtsan
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libtsan.so.0*

%files -n libtsan-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libtsan.a
#%doc rpm.doc/changelogs/libsanitizer/ChangeLog* libsanitizer/LICENSE.TXT
%endif

%if %{build_go}
%files go
%defattr(-,root,root,-)
%{_prefix}/bin/gccgo
%{_mandir}/man1/gccgo.1*
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/go1
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgo.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgo.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgobegin.a
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgo.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgo.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgobegin.a
%endif
%ifarch sparcv9 ppc %{multilib_64_archs}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgo.so
%endif
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgo.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgobegin.a
%endif
%doc rpm.doc/go/*

%files -n libgo
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libgo.so.4*
%doc rpm.doc/libgo/*

%files -n libgo-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/%{_lib}/go
%dir %{_prefix}/%{_lib}/go/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/%{_lib}/go/%{version}
%endif
%{_prefix}/%{_lib}/go/%{gcc_version}/%{gcc_target_platform}
%ifarch %{multilib_64_archs}
%ifnarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/go
%dir %{_prefix}/lib/go/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/go/%{version}
%endif
%{_prefix}/lib/go/%{gcc_version}/%{gcc_target_platform}
%endif
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libgobegin.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libgobegin.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgobegin.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgo.so
%endif

%files -n libgo-static
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libgo.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libgo.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgo.a
%endif
%endif

%if 1
%files plugin-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{version}
%endif
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/plugin
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%if "%{version}" != "%{gcc_version}"
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{version}
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/plugin
%endif



%changelog
* Fri Apr 3 2020 chenli <chenli147@huawei.com> - 7.3.0-20190804.h31
- Type:enhancement
- ID:NA
- SUG:NA
- DESC:delete unneeded if condition

* Tue Dec 31 2019 openEuler Buildteam <buildteam@openeuler.org> - 7.3.0-20190804.h30
- Type:NA
- ID:NA
- SUG:NA
- DESC:delete unneeded requires

* Mon Dec 30 2019 openEuler Buildteam <buildteam@openeuler.org> - 7.3.0-20190804.h29
- Type:NA
- ID:NA
- SUG:NA
- DESC:delete unneeded requires

* Mon Dec 23 2019 openEuler Buildteam <buildteam@openeuler.org> - 7.3.0-20190804.h28
- Type:NA
- ID:NA
- SUG:NA
- DESC:delete unneeded info in changelog

* Tue Dec 4 2019 guoge<guoge1@huawei.com> - 7.3.0-20190804.h27
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: delete some patches

* Tue Dec 4 2019 guoge<guoge1@huawei.com> - 7.3.0-20190804.h26
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: update patches

* Fri Nov 29 2019 jiangchuangang<jiangchuangang@huawei.com> - 7.3.0-20190804.h25
- Type:enhancement
- ID:NA
- SUG:NA
- DESC:revise gcc_target_platform

* Thu Nov 14 2019 jiangchuangang<jiangchuangang@huawei.com> - 7.3.0-20190804.h24
- Type:enhancement
- ID:NA
- SUG:NA
- DESC:rename patch

* Mon Nov 5 2019 jiangchuangang<jiangchuangang@huawei.com> - 7.3.0-20190804.h23
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: revise gcc_target_platform

* Mon Nov 5 2019 jiangchuangang<jiangchuangang@huawei.com> - 7.3.0-20190804.h22
- Type:enhancement
- ID:NA
- SUG:NA
- DESC:support for x86 architecture

* Thu Oct 24 2019 shenyangyang<shenyangyang4@huawei.com> 7.3.0-20190804.h21
- Type:enhancement
- ID:NA
- SUG:NA
- DESC:add build requires of zlib-devel

* Wed Oct 23 2019 shenyangyang<shenyangyang4@huawei.com> 7.3.0-20190804.h20
- Type:enhancement
- ID:NA
- SUG:NA
- DESC:delete %{?dist}

* Wed Sep 11 2019 gaoyi<gaoyi15@huawei.com> - 7.3.0-20190804.h19
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: export extra_ldflags_libobjc for libobjc

* Tue Sep 10 2019 gaoyi<gaoyi15@huawei.com> - 7.3.0-20190804.h18
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: export FCFLAGS for fortran to add SP

* Mon Sep 09 2019 gaoyi<gaoyi15@huawei.com> - 7.3.0-20190804.h17
- Type:bugfix
- ID:NA
- SUG:NA
- DESC: add CVE-2019-15847

* Sun Aug 04 2019 liufeng<liufeng111@huawei.com> 7.3.0-20190804.h16
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: update gcc version

* Tue Jun 5 2019 zoujing<zoujing13@huawei.com> 7.3.0-20190601.h15
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: update gcc version

* Fri May 31 2019 zoujing<zoujing13@huawei.com> 7.3.0-20190515.h14
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: sync patch from compile

* Tue May 21 2019 zoujing<zoujing13@huawei.com> 7.3.0-20190515.h13
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: add libtsan

* Fri May 17 2019 zoujing<zoujing13@huawei.com> 7.3.0-20190515.h12
- Type:enhancement
- ID:NA
- SUG:NA
- DESC: update gcc version

* Mon May 13 2019 shenyining<shenyining@huawei.com> 7.3.0-20190316.h11
- Type:enhancement
- ID:NA
- SUG:NA
- DESC:add sec compile option

* Mon May 13 2019 yutianqi<yutianqi2@huawei.com> 7.3.0-20190316.h10
- Type:enhancement
- ID:NA
- SUG:NA
- DESC:change gcc src to src and patch

* Wed May 8 2019 luochunsheng<luochunsheng@huawei.com> 7.3.0-20190316.h9
- Type:enhancement
- ID:NA
- SUG:NA
- DESC:remove sensitive information

*Fri Apr 12 2019 liuxueping<liuxueping1@huawei.com> 7.3.0-20190316.h8
- Type:NA
- ID:NA
- SUG:NA
- DESC: delete BuildRequires: -bep-env

*Tue Mar 26 2019 zoujing<zoujing13@huawei.com> 7.3.0-20190316.h7
- Type:NA
- ID:NA
- SUG:NA
- DESC: update gcc-7.3.0

*Wed Mar 20 2019 zoujing<zoujing13@huawei.com> 7.3.0-20190214.h6
- Type:NA
- ID:NA
- SUG:NA
- DESC: revert add --disable-libstdcxx-dual-abi

*Sat Mar 16 2019 zoujing<zoujing13@huawei.com> 7.3.0-20190214.h5
- Type:NA
- ID:NA
- SUG:NA
- DESC: revert add --disable-libstdcxx-dual-abi

*Thu Mar 14 2019 zoujing<zoujing13@huawei.com> 7.3.0-20190214.h4
- Type:NA
- ID:NA
- SUG:NA
- DESC: add --disable-libstdcxx-dual-abi and some include files

*Tue Mar 5 2019 zoujing<zoujing13@huawei.com> 7.3.0-20190214.h3
- Type:NA
- ID:NA
- SUG:NA
- DESC: add plugin-devel and optionial for compile

* Mon Mar 1 2019 hexiaowen<hexiaowen@huawei.com> 7.3.0-20190214.h2
- Type:NA
- ID:NA
- SUG:NA
- DESC: add plugin-devel and option

* Tue Feb 26 2019 zoujing <zoujing13@huawei.com> -1.h1
- Type:NA
- ID:NA
- SUG:NA
- DESC: add libasan

* Sun Feb 24 2019 zoujing <zoujing13@huawei.com>
- Type:NA
- ID:NA
- SUG:NA
- DESC: remove -Werror=format-security

* Thu Feb 21 2019 zoujing <zoujing13@huawei.com>
- Type:NA
- ID:NA
- SUG:NA
- DESC:add libatomic and libitm packages on gcc 7.3.0

* Fri Feb 15 2019 zoujing <zoujing13@huawei.com>
- Type:NA
- ID:NA
- SUG:NA
- DESC:update gcc-7.3.0 sourcecode

* Fri Nov 11 2016 liupeifeng3@huawei.com
- gcc update 199192
* Mon Aug 15 2016 wuhui3@huawei.com
- gcc update svn revision 197280
* Fri Oct 23 2015 wuhui3@huawei.com
- add some
* Sat May 23 2015 john.wanghui@huawei.com
- create spec
* Sat May 23 2015 jiangjiji@huawei.com
- compile programs
