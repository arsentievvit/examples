resource "yandex_vpc_network" "vpc" {
  name = "net"
}

resource "yandex_vpc_gateway" "gw" {
  name = "gw"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "to-gw" {
  name = "internal-to-nat"
  network_id = yandex_vpc_network.vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id = yandex_vpc_gateway.gw.id
  }
}

resource "yandex_vpc_subnet" "internal" {
  name = "internal"
  description = "Used for internal instances"
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["172.31.1.0/24"]
  route_table_id = yandex_vpc_route_table.to-gw.id
}

resource "yandex_vpc_subnet" "public" {
  name = "public"
  description = "Used for public instances"
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["172.31.2.0/24"]
}
