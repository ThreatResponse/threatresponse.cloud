---
title: "Containing an Instance with AWS_IR"
date: 2017-11-26 01:00 UTC
tags: amazon web service aws_ir reinvent ir dfir forensics
blog: "blog"
published: true
---

# AWS_IR -- Reaching Containment

You may have noticed that since the release of AWS_IR and MargaritaShotgun
nearly two years ago that we have continued to add features.  Features that were
all based on the feedback of users like you.  

Initially we supported the following steps during the run of a response plan:

* Gather Metadata
* Snapshot Disks
* Isolate the Workload
* Gather Memory
* Tag the Instance
* Stop the instance

One piece of feedback that we received from users time and time again was
that they wanted to __be able to select custom incident steps__.  So, we
created the AWS_IR plugin system.  This change abstracted the steps that ran
and all of the code from each plugin.  So now you can choose "only isolate" or
"only snapshot" without stopping the instance.  


## How do you use it?

Let's say that you have a problematic instance or three.  You'd like to do the following:

* Gather Metadata
* Tag the instance
* Isolate the instance
* Allow other examiner's ssh access to gather memory

AWS_IR supports this style of acquisition in a very straight forward manor.

All you need to know is:

1. The IP address of the machine you're processing
2. What you IP address is in CIDR notation.
3. What steps you'd like to perform.  

__Tip__

When running AWS_IR you can pass in _examiner-cidr-range_ as an argument.  If you
do not pass in a range the tool will default to not allowing access.  __This is undesirable
if you want to follow up with grabbing a memory dump.__

Your examiner-cidr-range is equal to YOUR_PUBLIC_IP + /32.
`Example: 32.241.44.210/32`


## Finding out supported aws_ir plugins
Run `aws_ir instance-compromise --help` in order to see a list of supported plugins.  

```bash
aws_ir instance-compromise --help
usage: aws_ir instance-compromise [-h] [--target TARGET] [--targets TARGETS]
                                  [--user USER] [--ssh-key SSH_KEY]
                                  [--plugins PLUGINS]

optional arguments:
  -h, --help         show this help message and exit
  --target TARGET    instance-id|instance-ip
  --targets TARGETS  File of resources to process instance-id or ip-address.
  --user USER        this is the privileged ssh user for acquiring memory from
                     the instance. Required for memory only.
  --ssh-key SSH_KEY  provide the path to the ssh private key for the user.
                     Required for memory only.
  --plugins PLUGINS  Run some or all of the plugins in a custom order.
                     Provided as a comma separated list of supported plugins:
                     examineracl_host,gather_host,isolate_host,snapshotdisks_h
                     ost,stop_host,tag_host,get_memory
```

## AWS_IR Supported Plugins
* examineracl_host
* gather_host
* isolate_host
* snapshotdisks_host
* stop_host
* tag_host
* get_memory


## Getting the Desired Final State

If all you intend is to reach containment I'd suggest running `gather_host,snapshotdisks_host,isolate_host,ttag_host,examineracl_host` in that order.

If examiner acl is not the last plugin run you may deny yourself access to the instance unintentionally.


## The command!

```bash
$ aws_ir --examiner-cidr-range 208.68.222.222/32 instance-compromise --target 55.242.31.26 --user ec2-user --ssh-key responder-key.pem --plugins gather_host,snapshotdisks_host,isolate_host,ttag_host,examineracl_host
```

## See a full video walkthrough

https://vimeo.com/244461130
