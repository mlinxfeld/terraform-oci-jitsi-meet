resource "oci_core_network_security_group" "FoggyKitchenJitsiMeetSecurityGroup" {
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    display_name = "FoggyKitchenJitsiMeetSecurityGroup"
    vcn_id = oci_core_virtual_network.FoggyKitchenVCN.id
}

resource "oci_core_network_security_group" "FoggyKitchenSSHSecurityGroup" {
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    display_name = "FoggyKitchenSSHSecurityGroup"
    vcn_id = oci_core_virtual_network.FoggyKitchenVCN.id
}

