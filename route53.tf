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

# Add rabbit-site.lsst.codes to rabbit-site-0.lsst.codes
resource "aws_route53_record" "rabbit_site_route53" {
  zone_id = "Z3TH0HRSNU67AM"
  name = "rabbit-site.lsst.codes"
  type = "A"
  ttl = "300"
  records = ["${openstack_compute_instance_v2.rabbit_instances.0.network.0.fixed_ip_v4}"]
}

# Add rabbit-site-#.lsst.codes
resource "aws_route53_record" "rabbit_site_numbered_route53" {
  count = "${var.count}"
  zone_id = "Z3TH0HRSNU67AM"
  name = "rabbit-site-${count.index}.lsst.codes"
  type = "A"
  ttl = "300"
  records = ["${element(openstack_compute_instance_v2.rabbit_instances.*.network.0.fixed_ip_v4, count.index)}"]
}

# Add rabbit.lsst.codes to rabbit-0.lsst.codes
resource "aws_route53_record" "rabbit_aws_route53" {
  zone_id = "Z3TH0HRSNU67AM"
  name = "rabbit-aws.lsst.codes"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.rabbit_aws_shovel.public_ip}"]
}