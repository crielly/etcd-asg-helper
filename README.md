# etcd-asg-helper

A Lambda Function designed to help facilitate etcd autoscaling on Amazon EC2 using SRV Discovery

## Motivation

etcd is a major pain to autoscale. In particular, using an existing etcd cluster or the public CoreOS endpoint are not always an option.

## What is this thing?

This lambda function has very simple functionality. It:

1. Finds a list of servers matching specific tags - Environment, Project, and an arbitrary ID tag. TODO: Make this an arbitrary dict of tags

2. Using those instances and the parameters provided via Environment Variables to the lambda function, constructs the content of an SRV DNS record for etcd discovery

3. UPSERTs the specified SRV record in the specified Route53 Hosted Zone.

This is used to keep aforementioned SRV record in-sync with the reality of your etcd autoscaling group so that when a new etcd scales up, it can easily locate its desired peers and join the cluster.

## Suggested Deployment Methodology

The intended use case for this Lambda is that it be triggered via CloudWatch Event Rules whenever an autoscaling event occurs - ie, whenever an instance is launched or terminated by your etcd autoscaling group. This should be the only time when the SRV record would need to change.

## Deployment

`make build` creates a .zip deploy packagge for Lambda. How you get it to Lambda after that is your business!

## Lambda Environment Variables

See constants.py for the authoritative list, but here's an explanation of each entry

* `project_name` - This is a tag the lambda looks for. `tag:Project` on your ec2 instances must match the value provided to lambda
* `environment` - This is a tag the lambda looks for. `tag:Environment` on your ec2 instances must match the value provided to lambda
* `etcd_tag_name` - This is a tag the lambda looks for. In this case, you're providing a tag name `tag:YOURTAG` for which the value must be true. This identifies the instance as an etcd.
* `srv_record_name` - the name of the SRV record you want upserted. [This will usually be](https://coreos.com/etcd/docs/latest/v2/clustering.html#dns-discovery) `_etcd-server._tcp`, or `_etcd-server-ssl._tcp` for TLS-enabled deployments.
* `domain_name` - your Route53 Domain Name (ie example.com)
* `r53_zone_id` - Your Route53 Hosted Zone ID.
* `srv_record_ttl` - Record TTL for your SRV Record
* `etcd_port` - the port you're running etcd on - will usually be 2380
* `log_level` - DEBUG, INFO, ERROR etc. Not currently super meaningful, as you can see if you take a glance at the code.

### Example

![Example](https://i.imgur.com/dLeMxay.png)
