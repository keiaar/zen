package=boost
$(package)_version=1_65_0
$(package)_download_path=http://sourceforge.net/projects/boost/files/boost/1.65.0
$(package)_file_name=$(package)_$($(package)_version).tar.bz2
$(package)_sha256_hash=ea26712742e2fb079c2a566a31f3266973b76e38222b9f88b387e3c8b2f9902c
$(package)_patches=deprecated_auto_ptr.patch include_poll.patch boost_1_65_0.patch

define $(package)_set_vars
$(package)_config_opts_release=variant=release
$(package)_config_opts_debug=variant=debug
$(package)_config_opts=--layout=tagged --build-type=complete --user-config=user-config.jam
$(package)_config_opts+=threading=multi link=static -sNO_BZIP2=1 -sNO_ZLIB=1
$(package)_config_opts_linux=threadapi=pthread runtime-link=shared
$(package)_config_opts_darwin=--toolset=gcc runtime-link=shared threadapi=pthread
$(package)_config_opts_mingw32=binary-format=pe target-os=windows threadapi=win32 runtime-link=static
$(package)_config_opts_x86_64_mingw32=address-model=64
$(package)_config_opts_i686_mingw32=address-model=32
$(package)_config_opts_i686_linux=address-model=32 architecture=x86
$(package)_toolset_$(host_os)=gcc
$(package)_archiver_$(host_os)=$($(package)_ar)
$(package)_toolset_darwin=gcc
$(package)_archiver_darwin=$($(package)_ar)
$(package)_config_libraries=chrono,filesystem,program_options,system,thread,test
$(package)_cxxflags=-fvisibility=hidden
$(package)_cxxflags_linux=-fPIC
endef

define $(package)_preprocess_cmds
  echo "using $(boost_toolset_$(host_os)) : g++ : $($(package)_cxx) : <cxxflags>\"$($(package)_cxxflags) $($(package)_cppflags)\" <linkflags>\"$($(package)_ldflags)\" <archiver>\"ar\" <striper>\"strip\"  <ranlib>\"ranlib\" <rc>\"$(host_WINDRES)\" : ;" > user-config.jam && \
   patch -p1 < $($(package)_patch_dir)/deprecated_auto_ptr.patch && \
   patch -p1 < $($(package)_patch_dir)/include_poll.patch && \
   patch -p1 < $($(package)_patch_dir)/boost_1_65_0.patch
endef

define $(package)_config_cmds
  ./bootstrap.sh --without-icu --with-libraries=$(boost_config_libraries)
endef

define $(package)_build_cmds
  ./b2 -d2 -j2 -d1 --prefix=$($(package)_staging_prefix_dir) $($(package)_config_opts) stage
endef

define $(package)_stage_cmds
  ./b2 -d0 -j4 --prefix=$($(package)_staging_prefix_dir) $($(package)_config_opts) install
endef
