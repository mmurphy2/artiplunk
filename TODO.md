# NOTE

This was the original "work in progress" TODO document when Artiplunk was under active development. This project has been
abandoned. In academic speak, the following missing features are left as exercises for the reader :).

- Test a number of different cases
- Add support for RAID (md)
- Add a preliminary step for tearing down any md devices that have underlying drives to be reused
- Add a preliminary step (or join above) for running wipefs -a on any devices in TABLE
- Support encrypted swap partitions using the crypttab swap option (needs to skip luksFormat for this - use VKey=swap)
- Since Artix includes the Arch mirrors, setting INIT="systemd" could just install Arch (with a little hackery) [EDITOR'S NOTE:
  Artix has been slowly migrating away from requiring the Arch mirrors since the time this code was written, so this TODO item
  may be completely wrong now.]
- Add support for cryptoloop on top of the filesystem
- Find out if there is a way to prehash passwords, instead of putting them in the cache as plaintext (in case some idiot puts their
  cache somewhere other than tmpfs). Ditto for the LUKS headers.
  ** Passwords can be done with openssl passwd -6 -salt <salt>
- Add support for actually configuring the network, instead of just installing NetworkManager and walking away
- Look at whether or not neovim could replace vim
- Maybe let people install a different editor? But there is only 1 editor.
- Finish documenting the various functions
- Add support for other login managers
- Add support for automatic login
- Add support for custom hooks, files, and modules in initcpio step
- Add a sanity check step at the beginning to catch as many config errors as possible
- It would be nice if certain config variables (like GRUB\_CRYPT\_DEVICE) could be removed. This would require tracing things back through
  the MOUNT, LVM\_LV, PARTITIONS, and CRYPTO. Bash might not be such a good language for that kind of algorithm.
- Another pie in the sky feature: authconfig step, which could handle setting up PAM with Kerberos and/or LDAP auth
- Add support for additional pv/vg/lv creation options with LVM
- Run display messages through fmt to set width properly
