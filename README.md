# Live infrastructure for production

This repository contains Terraform code for the infrastructure that we 
have live in Staging.

The backend is setup to be in an S3 bucket.

## VPC setup

Our VPC layout in `us-east-1` follow the principle that the larger CIDR is `/16`
and it'll be using a class A (`10.0.0.0`) 

As [this article](https://medium.com/aws-activate-startup-blog/practical-vpc-design-8412e1a18dcc#.bmeh8m3si)
points out, public IPs will be less than private so public IPs will have
half the space of the private ones.

```
10.0.0.0/16 --> 65k IPs

/17 --> split it in 2 subnets
/18 --> split it in 4 subnets
/19 --> split it in 8 subnets - this will work in us-east-1 that has 6 AZs

/16 --> 65k IPs
/19 --> 8.1k IPs
/20 --> 4k IPs

10.0.0.0/16:
    10.0.0.0/19   - AZ A
    10.0.32.0/19  - AZ B
    10.0.64.0/19  - AZ C
    10.0.96.0/19  - AZ D
    10.0.128.0/19 - AZ E
    10.0.160.0/19 - AZ F
    10.0.192.0/19 - spare
    10.0.224.0/19 - spare
```

The mapping for each of the 6 AZs will be:

```
10.0.0.0/19 - AZ A
    10.0.0.0/20 - private
    10.0.16.0/20
        10.0.16.0/21 - public
        10.0.24.0/21 - spare

10.0.32.0/19 - AZ B
    10.0.32.0/20 - private
    10.0.48.0/20
        10.0.48.0/21 - public
        10.0.56.0/21 - spare

10.0.64.0/19  - AZ C
    10.0.64.0/20  - private
    10.0.80.0/20
        10.0.80.0/21 - public
        10.0.88.0/21 - spare

10.0.96.0/19  - AZ D
    10.0.96.0/20 - private
    10.0.112.0/20
        10.0.112.0/21 - public
        10.0.120.0/21 - spare

10.0.128.0/19 - AZ E
    10.0.128.0/20 - private
    10.0.144.0/20
        10.0.144.0/21 - public
        10.0.152.0/21 - spare

10.0.160.0/19 - AZ F
    10.0.160.0/20 - private
    10.0.176.0/20
        10.0.176.0/21 - public
        10.0.184.0/21 - spare
```

## SSH keys
SSH keys are stored in our AWS account SSM.
Follow [these instructions](https://docs.aws.amazon.com/en_us/cloudhsm/classic/userguide/generate_ssh_key.html)
to connect to those instances.

## TODO
- [x] enable VPC Logs
- [x] use ALB instead of ELB
- [x] assign dynamic port to applications
- [x] SSL with LB
- [x] Scale cluster based on CPU
- [ ] Scale cluster based on memory
- [ ] Add CloudWatch agent to ECS instances so they can collect memory metrics
- [x] Use mixed instances
- [x] deploy our console service instead of the example
- [ ] setup access logs for ALB - will work on this later as it requires a S3 bucket
      and in every run the bucket will be populated and to destroy it I will have to manually deleted
- [ ] cloudwatch setup for container insights
- [ ] [Nice to have] Route53 record for jumphost
- [ ] [Nice to have] Enable http2 in the target group
