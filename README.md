# NodeJS DLL for Windows

This repository contains a script that:
  1) clones NodeJS source,
  2) [modifies the build system](https://github.com/metacall/core/blob/66fcaac300611d1c4210023e7b260296586a42e0/cmake/NodeJSGYPPatch.py) a bit and
  3) builds NodeJS as a shared library that can be dynamically linked to other projects.


The Windows binaries (dll and lib) are published in the **[repository releases](https://github.com/metacall/node.dll/releases)**.
