# Lottery in Yul

A lottery dApp using Bitmasking and Binary Flags to store and assess tickets.

# TroubleShooting

> Error: error:0308010C:digital envelope routines::unsupported

* On Unix-like (Linux, macOS, Git bash, etc.):

`export NODE_OPTIONS=--openssl-legacy-provider`

*On Windows command prompt:

`set NODE_OPTIONS=--openssl-legacy-provider`

On PowerShell:

`$env:NODE_OPTIONS = "--openssl-legacy-provider"`