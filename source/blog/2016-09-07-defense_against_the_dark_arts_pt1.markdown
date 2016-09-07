---
title: Defense Against the Dark Arts Series Part 1
date: 2016-09-07 05:10 UTC
tags: grzelak security web amazon defense cloud
author: Andrew Krug
published: false
---

# Defense Against the Dark Arts Series

__Part 1__

This has been a really great year for analysis of Cloud Security on Amazon.
As part of presenting the ThreatResponse tool kit the team and I have been
out seeing all of the best talks on the security scene and getting hands on
with some very clever attack patterns.  This series of blog articles beginning
today and culminating in our DerbyCon talk will explore those clever attack patterns
in some detail and present workarounds for dealing with these types of attacks
in a live environment.  

### Just what are these attacks?

What are the scariest attacks of summer for Amazon Web Services users?  They
mainly boil down to persistence methods for maintaining control of an AWS account
well beyond disabling a compromised access key.  At BlackHat USA 2016 we heard from
Dan Amiga and Dor Knafo in their talk, Account Jumping Post Infection Persistency & Lateral Movement in AWS.

This presentation focused on two major areas:

* Evasion : How do I stay undetected?
* Persistence : How do I maintain access after my initial foot hold is compromised?

This was of particular interest to us as an incident response and threat mitigation project due to the fact that we were unsure that our tool suite _ThreatResponse_ addressed all these varietals of attack pattern.

### Evasion in the Cloud

When we talk about evasion techniques in Amazon Web Services we get to the true spirit
of the hacker and what really is a _hack_.  All of the evasion techniques we saw exploited
something in the Amazon Web Services API that was just a __feature__ to remain undetected
or alter evidence.  

__Disclaimer__

>It is important to point out that all of these evasion techniques require a very high level of access to take place inside of your account.  This further illustrates that there is really no substitute for concepts like separation of responsibility and least privilege computing.  

An Australian Security Researcher by the name of Daniel Grzelak who maitains a blog
called CyberFree https://danielgrzelak.com was the first to present some of these
techniques in blogs earlier in 2016.  

#### Understanding Logging in Amazon

Any Cloud Security professional that has been around will tell you, "The value of
CloudTrail logs can not be understated."  What information is stored in a CloudTrail log?
All of the calls to the API and actions taken over time.  This is incredibly valuable
when it comes time to perform timeline reconstruction on a compromised AWS account.  Without CloudTrail it becomes an arduous task to determine the scope of the incursion.  So you can imagine as an attacker how awesome it would be to destroy this data or cause
logging to not take place when you don't want it to.

#### Evasion Technique 1 - Disrupting Logging ( Simple )

We don't need to show you how to perform this attack.  Mr. Grzelak does a fine job of that here.
https://danielgrzelak.com/disrupting-aws-logging-a42e437d6594#.2m18u72vu In short this attack simply boils down to stopping logging in all or some regions of the AWS account.  

> What does all or one region really mean?  In Amazon Web Services CloudTrail logs are sent to a "home region".  In order to consolidate these from multiple regions you need to have all regions log back to a central bucket via a feature called multi-region logging.  So a stealthy attacker may only elect to disable one region at a time.

__What are the forensic artifacts produced by this?__

As incident responders in the Cloud we are interested in how might detect this behavior.  Simply disabling CloudTrail is relatively noisy and can be detected with the following:

1. CloudWatch Events
2. Config Rules

Both of these however actually use CloudTrail as the mechanism for detecting when CloudTrail is stopped. CloudWatch events will probably be the fast of the two since Config Rules takes time to perform and evaluation and for that to make it back into the logs.

CloudWatch Events can fire within 2-4 minutes of an event occurring.  

__How do we setup a CloudWatch Event to check for CloudTrail Disable?__

![cloudwatch](2016-09-07-defense_against_the_dark_arts_pt1/cloudwatch.png)
> As you can see in the above shot simply setting up a CloudWatch event is quite simple
to monitor the start and stop of CloudTrail as a service.  

__The Last CloudTrail Event__

The act of disabling itself also produces an event sort of as a last in CloudTrail.
![cloudwatch](2016-09-07-defense_against_the_dark_arts_pt1/stoplogging.png)

So forensically we know that this type of activity is detectable and has some artifacts.  However, in order to really be effective and monitor disabling for every region in the account we need to set up this kind of CloudWatch event for each region or use a 3rd party monitoring service.  

### Response to Evasion Technique 1 - Disrupting Logging ( Simple )

Now simply stopping the log is a rather noisy activity so it's very easy to detect and respond to.  We can do a couple different things as a means of responding to this type of activity.  

1. Chain CloudWatch events to a Lambda function to re-enable logging to a known good state.
2. Use a 3rd party tool to monitor the AWS account either on premise or in a "Security Cloud" to put the account back to a known good state.  

> In this sense "Security Cloud" is defined as another AWS account with separate security boundaries receiving logs from the organizations accounts running workloads.  
