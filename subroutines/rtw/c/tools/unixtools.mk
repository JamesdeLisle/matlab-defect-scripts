# Copyright 1994-2013 The MathWorks, Inc.
#
# File    : unixtools.mk   
# Abstract:
#	Setup Unix tools for GNU make

ARCH := $(shell echo "$(COMPUTER)" | tr '[A-Z]' '[a-z]')
OS:=$(shell uname)

#
# Modify the following macros to reflect the tools you wish to use for
# compiling and linking your code.
#


DEFAULT_OPT_OPTS = -O0
ANSI_OPTS        =
CPP_ANSI_OPTS    = 
CPP              = c++
LD               = $(CC)
SYSLIBS          =
LDFLAGS          =
SHRLIBLDFLAGS    =
AR               = ar

# Override based on platform if needed

GCC_WALL_FLAG     :=
GCC_WALL_FLAG_MAX :=
ifeq ($(COMPUTER),GLNXA64)
  CC  = gcc
  CPP = g++
  DEFAULT_OPT_OPTS = -O0
  SHRLIBLDFLAGS = -shared -Wl,--no-undefined -Wl,--version-script,
  COMMON_ANSI_OPTS = -fwrapv -fPIC
  ANSI_OPTS        = -ansi -pedantic -Wno-long-long $(COMMON_ANSI_OPTS)
  CPP_ANSI_OPTS    = -std=c++98 -pedantic -Wno-long-long $(COMMON_ANSI_OPTS)
  # Allow ISO-C functions like fmin to be called
  ifeq ($(TGT_FCN_LIB),ISO_C)
    ANSI_OPTS     = -std=c99 -pedantic $(COMMON_ANSI_OPTS)
    CPP_ANSI_OPTS = $(COMMON_ANSI_OPTS)
  else
    ifeq ($(TGT_FCN_LIB),GNU)
      ANSI_OPTS     = -std=gnu99 -pedantic $(COMMON_ANSI_OPTS)
      CPP_ANSI_OPTS = $(COMMON_ANSI_OPTS)
    else
      ifeq ($(SINGLE_LINE_COMMENTS),1)
	  ANSI_OPTS     = $(COMMON_ANSI_OPTS)
      endif	
      ifneq ($(TGT_FCN_LIB),ISO_C++)
        ifeq ($(NON_ANSI_TRIG_FCN), 1)
          ANSI_OPTS     = 
          CPP_ANSI_OPTS = 
        endif
      endif	
    endif
  endif
  # These definitions are used by targets that have the WARN_ON_GLNX option
  GCC_WARN_OPTS     := -Wall -W -Wwrite-strings -Winline \
                       -Wpointer-arith -Wcast-align

  # Command line options valid for C/ObjC but not for C++
  ifneq ($(TARGET_LANG_EXT),cpp)
    GCC_WARN_OPTS := $(GCC_WARN_OPTS) -Wstrict-prototypes -Wnested-externs 
  endif

  # if TGT_FCN_LIB is C89/90 add -Wno-long-long flag. This flag will stop
  # gcc from throwing warning: ISO C90 does not support 'long long'.
  ifneq ($(NON_ANSI_TRIG_FCN), 1)
    GCC_WARN_OPTS     := $(GCC_WARN_OPTS) -Wno-long-long
  endif

  GCC_WARN_OPTS_MAX := $(GCC_WARN_OPTS) -Wcast-qual -Wshadow

  ifeq ($(WARN_ON_GLNX), 1)
    GCC_WALL_FLAG     := $(GCC_WARN_OPTS)
    GCC_WALL_FLAG_MAX := $(GCC_WARN_OPTS_MAX)
  endif
endif

ifeq ($(COMPUTER),MACI64)
  DEFAULT_OPT_OPTS = -O0
  MW_SDK_ROOT := $(shell find `xcode-select -print-path` -name MacOSX10.8.sdk)
  
  # architecture support x86_64 
  ARCHS = x86_64
  CC  = xcrun clang -arch $(ARCHS) -isysroot $(MW_SDK_ROOT)
  CPP = xcrun clang++ -arch $(ARCHS) -isysroot $(MW_SDK_ROOT)
  AR  = xcrun ar
  
  ANSI_OPTS = -fno-common -fexceptions 

  #instead of using -bundle, use -dynamiclib flag to make the lib dlopen compatible
  SHRLIBLDFLAGS = \
    -dynamiclib \
    -Wl,$(LD_NAMESPACE) $(LD_UNDEFS) -Wl,-exported_symbols_list,
endif

# To create a Quantify (from Rational) build,
# specify
#     QUANTIFY=1
# or
#     QUANTIFY=/path/to/quantify
#
# Note, may also need QUANTIFY_FLAGS=-cachedir=./q_cache
#
ifdef QUANTIFY
  ifeq ($(QUANTIFY),1)
    QUANTIFY_ROOT = /hub/$(ARCH)/apps/quantify
  else
    QUANTIFY_ROOT = $(QUANTIFY)
  endif

  INSTRUMENT_INCLUDES := -I$(QUANTIFY_ROOT)
  INSTRUMENT_LIBS     := $(QUANTIFY_ROOT)/quantify_stubs.a
  LD                  := quantify $(QUANTIFY_FLAGS) $(LD)
  OPT_OPTS            := -g
endif

# To create a Purify (from Rational) build, specify
#   PURIFY=1
#
ifeq ($(PURIFY),1)
  PURIFY_ROOT = /hub/$(ARCH)/apps/purify

  INSTRUMENT_INCLUDES := -I$(PURIFY_ROOT)

  INSTRUMENT_LIBS     := $(PURIFY_ROOT)/purify_stubs.a

  CC       := purify $(CC)
  OPT_OPTS := -g
endif

# [eof] unixtools.mk
