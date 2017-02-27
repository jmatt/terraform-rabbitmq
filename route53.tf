# Use aws.
provider "aws" {
  region = "us-west-2"
}

# Add rabbit.lsst.codes to rabbit-0.lsst.codes
resource "aws_route53_record" "rabbit_route53" {
  zone_id = "Z3TH0HRSNU67AM"
  name = "rabbit.lsst.codes"
  type = "A"
  ttl = "300"
  records = ["${openstack_compute_instance_v2.rabbit_instances.0.access_ip_v4}"]
}

# Add rabbit-#.lsst.codes
resource "aws_route53_record" "rabbit_numbered_route53" {
  count = "${var.count}"
  zone_id = "Z3TH0HRSNU67AM"
  name = "rabbit-${count.index}.lsst.codes"
  type = "A"
  ttl = "300"
  records = ["${element(openstack_compute_instance_v2.rabbit_instances.*.access_ip_v4, count.index)}"]
}