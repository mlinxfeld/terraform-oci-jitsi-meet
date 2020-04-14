resource "oci_core_network_security_group_security_rule" "FoggyKitchenJitsiMeetSecurityEgressGroupRule" {
    network_security_group_id = oci_core_network_security_group.FoggyKitchenJitsiMeetSecurityGroup.id
    direction = "EGRESS"
    protocol = "6"
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
}

resource "oci_core_network_security_group_security_rule" "FoggyKitchenJitsiMeetSecurityIngressGroupTCPRules" {
    for_each = toset(var.jitsi_meet_tcp_service_ports)

    network_security_group_id = oci_core_network_security_group.FoggyKitchenJitsiMeetSecurityGroup.id
    direction = "INGRESS"
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    tcp_options {
        destination_port_range {
            min = each.value
            max = each.value
        }
    }
}

resource "oci_core_network_security_group_security_rule" "FoggyKitchenJitsiMeetSecurityIngressGroupUDPRules" {
    for_each = toset(var.jitsi_meet_udp_service_ports)

    network_security_group_id = oci_core_network_security_group.FoggyKitchenJitsiMeetSecurityGroup.id
    direction = "INGRESS"
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    tcp_options {
        destination_port_range {
            min = each.value
            max = each.value
        }
    }
}

resource "oci_core_network_security_group_security_rule" "FoggyKitchenJitsiMeetSecurityIngressGroupUDP2Rules" {
    network_security_group_id = oci_core_network_security_group.FoggyKitchenJitsiMeetSecurityGroup.id
    direction = "INGRESS"
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    tcp_options {
        destination_port_range {
            min = 10000
            max = 20000
        }
    }
}