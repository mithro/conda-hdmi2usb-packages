#! /usr/bin/python3


PACKAGES="""\
[ENV]
HOME=/home/travis
TRAVIS_BUILD_DIR=/workspace
TRAVIS_REPO_SLUG=SymbiFlow/conda-packages
TRAVIS_BRANCH=master
PACKAGE=libusb

# Packages
# ======================================

# Support libraries
# --------------------------
[libxml]
group=libraries

[libusb]
group=libraries

# FPGA Toolchain - Bitstream
# --------------------------
[icestorm]
group=fpga-toolchain
type=bitstream

# FPGA Toolchain - Synthesis
# --------------------------
[yosys]
group=fpga-toolchian
type=synthesis

[odin_II]
channels=pkgw-forge,conda-forge
group=fpga-toolchian
type=synthesis

# FPGA Toolchain - Place and Route
# --------------------------------
[vtr]
channels=pkgw-forge,conda-forge
group=fpga-toolchain
type=pnr

# FPGA Toolchain - Simulation
# ---------------------------
[iverilog]
group=fpga-toolchain
type=simulation

[verilator]
group=fpga-toolchain
type=simulation

# C Toolchain
# -----------
[riscv32/binutils]
disable=True
group=c-toolchian
type=binutils

# Utilities
# ---------
[netlistsvg]
channels=conda-forge
group=support

# SystemVerilog tools
# -------------------
[zachjs-sv2v]
channels=conda-forge
group=sv-tests

[tree-sitter-verilog]
group=sv-tests

[slang]
group=sv-tests
channels=conda-forge

# Protocol Analyzers
# ------------------
[sigrok-cli]
channels=conda-forge
group=support
"""

"""
- name: 'travis-ci'
  args: ['bash', './.github/ci/script.sh']
  volumes:
  - name: 'home'
    path: '/home/travis'
  env:
  - 'HOME=/home/travis'
  - 'TRAVIS_BUILD_DIR=/workspace'
  - 'TRAVIS_REPO_SLUG=SymbiFlow/conda-packages'
  - 'TRAVIS_BRANCH=master'
  - 'PACKAGE=libusb'
"""

import configparser
config = configparser.ConfigParser()
config['DEFAULT'] = {'disabled': False}
config.read_string(PACKAGES)

def print_env(sobj):
    """Print the env yaml section from a section object."""
    print("  env:")
    for k in sobj:
        print("  - '{}={}'".format(k, sobj[k]))

for section in config.sections():
    if section in ['ENV',]:
        continue
    section = config[section]
    if section.getboolean('disabled'):
        continue
    print(repr(section))
    config['ENV']['PACKAGE'] = section.name
    print_env(config['ENV'])
    print(section.get('group'))


