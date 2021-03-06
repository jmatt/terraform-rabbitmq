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

# RabbitMQ Nebula Cluster.
resource "openstack_compute_instance_v2" "rabbit_instances" {
  count = "${var.count}"
  name = "rabbit-${count.index}"
  image_id = "e5607bd7-434d-4bf5-91ad-82b689b7c03e"
  flavor_name = "m4.large"
  key_pair = "rabbit_lsst"
  security_groups = ["default", "remote SSH", "remote mosh", "remote https"]

  user_data = "${file("cloud-config.yaml")}"
  network {
    name = "panopticon-network"
    access_network = true
    floating_ip = "${element(openstack_compute_floatingip_v2.ext.*.address, count.index)}"
  }
}
