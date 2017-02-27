terraform-rabbitmq
==================

[![Build Status](https://travis-ci.org/jmatt/terraform-rabbitmq.svg?branch=master)](https://travis-ci.org/jmatt/terraform-rabbitmq)

Use [Terraform](https://www.terraform.io/) to configure infrastructure for [RabbitMQ](https://www.rabbitmq.com/).

This terraform deployment will create Ubuntu 16.04 instances in LSST's Nebula project. Next it will use [Amazon Route 53](https://aws.amazon.com/route53/) to create DNS entries for those instances.

Use
---

   terraform apply

Variables
---------

`count` *(default 3)* Create count many rabbit instances for the rabbit cluster.

License
-------

See the [LICENSE file](https://github.com/jmatt/terraform-rabbitmq/blob/master/LICENSE).