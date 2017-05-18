# Use Nebula.
provider "openstack" {
}

# Ensure the rabbit_lsst keypair is imported to OpenStack.
resource "openstack_compute_keypair_v2" "rabbit_lsst-keypair" {
  name = "rabbit_lsst"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkVJJH7jBXvdnE+YE+4twX7Zi994duvZPu8JyGpduxEMVum3NwQy7XR+RArNtiMyxlNHw6dt9lifRNAPdnuqo/z+xcSsn1Gu8t3JDeL8SE4iFKg+S0gDLpYFLzT8wjt1nPe47qMfcHJaJ/WHvR0fRsLrUzrzUV0N2gmDhTN9wId0Xz9ZoTFtlCi8stYvYTGL42Fc1cwmjd/gfGzWJPU3/VNuW/oM/eezQCfyz0K8cp7BmBWkQjTdn82ARFzdUk26lFjM7wG5pX3wbceqO4vQOzYnWTS/BlQ7sflBD6VSlWZjuSTINlJX5fSkue0Tnc+xNXgOp3s9SQbhoRj4TrNJr6Hn7X4JLGpeb+Y/HRUIpbq8yWsXfj6sPl95YNdAbDww2EiGanUi7JfQt1ws0XcHbGxVDkOEN6bYW/4BWBEmjYyxB1d0JCr+ZZ9meZL461gaFgrJnlgKAzxnXPRksPjVps/Ih+CVsS1WCZaKokjboGXp1u5JdW54j+8GQyMoxB9pBlmXXGSYfIDdVXehF/GKsJvWoNZKvE5p47jlkY3lRUqAzHtTDcNXnfwDZkrW3ib6ILvmfzptDQbOPzuccKkFYXbTuJux3dkKNWJbE3VOjIDv1OcHr2yNv1EYE3kuC9P9q9jgjszwa9dfZz4gtq4bMeZuW1814f4BkyoaqHpT+llw== jmatt@lsst.org"
}

# Use Nebula's ext_net to get a public floating ip.
resource "openstack_compute_floatingip_v2" "ext" {
  count = "${var.count}"
  pool = "ext-net"
}

resource "openstack_networking_secgroup_v2" "rabbit_secgroup" {
  name = "rabbitmq_site"
  description = "RabbitMQ for local and site networks."
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 4369
  port_range_max = 4369
  remote_ip_prefix = "10.0.42.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_2" {
  direction = "egress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 4369
  port_range_max = 4369
  remote_ip_prefix = "10.0.42.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_3" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 5671
  port_range_max = 5672
  remote_ip_prefix = "10.0.42.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_3_aws" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 5671
  port_range_max = 5672
  remote_ip_prefix = "${aws_instance.rabbit_aws_shovel.public_ip}/32"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_4" {
  direction = "egress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 5671
  port_range_max = 5672
  remote_ip_prefix = "10.0.42.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_4_aws" {
  direction = "egress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 5671
  port_range_max = 5672
  remote_ip_prefix = "${aws_instance.rabbit_aws_shovel.public_ip}/32"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_5" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 25672
  port_range_max = 25672
  remote_ip_prefix = "10.0.42.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_6" {
  direction = "egress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 25672
  port_range_max = 25672
  remote_ip_prefix = "10.0.42.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_7" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 35099
  port_range_max = 35099
  remote_ip_prefix = "10.0.42.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rabbit_rule_8" {
  direction = "egress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 35099
  port_range_max = 35099
  remote_ip_prefix = "10.0.42.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.rabbit_secgroup.id}"
}

# RabbitMQ Nebula Cluster.
resource "openstack_compute_instance_v2" "rabbit_instances" {
  count = "${var.count}"
  name = "rabbit-${count.index}"
  image_id = "e5607bd7-434d-4bf5-91ad-82b689b7c03e"
  flavor_name = "m4.large"
  key_pair = "rabbit_lsst"
  security_groups = ["default", "remote SSH", "remote mosh", "remote https", "rabbitmq_site"]

  user_data = "${file("cloud-config.yaml")}"
  network {
    name = "panopticon-network"
    access_network = true
    floating_ip = "${element(openstack_compute_floatingip_v2.ext.*.address, count.index)}"
  }
}

# resource "openstack_compute_floatingip_associate_v2" "rabbit_floatingip" {
#   count = "${var.count}"
#   floating_ip = "${element(openstack_compute_floatingip_v2.ext.*.address, count.index)}"
#   instance_id = "${element(openstack_compute_instance_v2.rabbit_instances.*.id, count.index)}"
#   fixed_ip = "${element(openstack_compute_instance_v2.rabbit_instances.*.network.0.fixed_ip_v4, count.index)}"
# }
