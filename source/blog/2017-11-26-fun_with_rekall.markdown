---
title: "Fun with Rekall and the ThreatResponse Workstation"
date: 2017-11-26 01:00 UTC
tags: amazon web service aws_ir reinvent ir dfir forensics
blog: "blog"
published: true
---

# ThreatResponse Workstation and Rekall

Recently I've been working on more automation around the use of rekall.  
Think "random sampling" and analysis but more effective than the TSA.  

Python volatility has always been my go-to for processing live windows Memory
but rekall's shell has a lot to offer as well.  If you follow the ThreatResponse
project you know that we have just released the "ThreatResponse Workstation" in concert
with our friends at ephemeralsystems.com.  Ephemeral Systems provides all commercial
support around aws_ir and the ThreatResponse suite.  

In order to use rekall you need three things:

1. A memory dump.  ( _This can be taken with MargaritaShotgun_ )
2. A rekall profile for the kernel variant.  One has been provided as a sample.
3. A rekall environment.  We'll use the one from the remnux project for the sake of simplicity.

> Rekall has a lot of dependencies.  Using a docker container to deliver the environment
makes all of that quite easy.  We want to focus on analysis not on the installation.  


## Getting a memory capture

MargaritaShotgun is an incredibly useful tool for memory capture.  It has tons of
great features like jump box support, automatic kernel module resolution, and multipart
S3 upload.  If you type `margariashotgun --help` it can be kind of overwhelming if you've
never used the tool.  __That's why we stress preparation in the IR process.__  Know the tools
or you're going to have a bad time.  

Here's an example of just acquiring memory from a single system using margarita shotgun and the
automatic kernel repository.  MargaritaShotgun is provided and installed on the threatresponse workstation.  https://github.com/EphemeralSystems/threatresponse-ws  

> You can use our AMIs or build your own.   

```bash

# margaritashotgun --server 52.37.143.97 --user ec2-user --key ~/.ssh/id_rsa --filename memcapture.lime --repository

```

## You've got a capture now what?  

This is where the _magic_ happens!  Examiner's always say how powerful volatile data can be.
Memory analysis in linux never comes easy.  Under normal circumstances you would have to build a rekall profile.  

> __What's rekall profile?__  Rekall profiles tell the the tooling how the variant of the kernel
lays out the memory space so it can do things like extract network connection, process lists, and
more.  

The most recent version of the Amazon Linux kernel is `4.9.58-18.55` following the instructions
here: https://github.com/google/rekall/tree/master/tools/linux along with some heavy modifications
to the _Makefile_ I was able to build a profile.  

That profile is available here:

https://s3-us-west-2.amazonaws.com/reinvent2018-west.threatresponse.cloud/4.9.58-18.55.amzn1.json

__What are some things you might do with rekall?__

1.  Dump the process tree and examine running processes against known good states.  
2.  Dump the network connections like you would with netstat.
3.  Extract all process memory to individual dmp files for carving or running strings against.

__Sample Commands__

```bash

# Loading Rekall

rekall --profile 4.9.58-18.55.amzn1.json -f YOURDUMP.lime

# Getting the process tree

[1] memcapture.lime 03:00:48> pstree

# Getting netstat

[1] memcapture.lime 03:00:48> netstat

# Dumping all processes to individual files

[1] memcapture.lime 03:00:48> memdump

# Running strings ( Note: You need to exit the rekall shell )

$ strings yourfile.dmp | grep -i thing

```

## Video Walkthrough

See a complete video walkthrough here:

https://vimeo.com/244460871
