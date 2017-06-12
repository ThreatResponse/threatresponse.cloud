---
title: "Mozilla takes over Kernel Module Builds"
date: 2017-06-12 10:00 UTC
tags: amazon web service kernel margaritashotgun lime
blog: "blog"
published: true
---

![marhso-sirs](2017-06-12_kernel_module_builds/Mozilla-12jan-1500px_imagery.jpg)

# Mozilla Supports margaritashotgun / aws_ir LiME Module Builds

If you are a user of margaritashotgun you likely love the support
that it provides for acquiring live memory via ssh to your forensics
workstation or Amazon's S3 service.  

Last fall at BSides PDX 2016 we launched a new feature into margaritashotgun
which introduced a repository of signed kernel modules for automatic
use during memory acquisition.  In order to keep up with kernel releases
that service needs to run at least once a day using our lime-compiler rubygem.  This was problematic since running an adequately sized EC2 instance
to do this can be costly.  Enter Mozilla.  

@andrewkrug joined Mozilla in February of 2017 since then Mozilla has agreed to host the lime-compiler service and run module builds ever 4 hours.  _What does this mean for you?_ No more waiting on us to support new kernel versions especially in Amazon Linux!

Wondering what OS variants and kernel versions we support?  Go have a look at our build system conf file?  Pull requests happily accepted if you'd like to add support for a new operating system.

Special thanks to InfoSec Teams at Mozilla and @0x7eff ( Jeff Bryner ) for supporting the module builds.
