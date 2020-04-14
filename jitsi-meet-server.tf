resource "oci_core_instance" "FoggyKitchenJitsiMeetServer" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[1], "name")
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name = "FoggyKitchenJitsiMeetServer"
  shape = var.Shapes[0]
  subnet_id = oci_core_subnet.FoggyKitchenJitsiMeetSubnet.id
  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImageLocal.images[0], "id")
  }
  metadata = {
      ssh_authorized_keys = file(var.public_key_oci)
  }
  create_vnic_details {
     subnet_id = oci_core_subnet.FoggyKitchenJitsiMeetSubnet.id
     assign_public_ip = true 
     nsg_ids = [oci_core_network_security_group.FoggyKitchenJitsiMeetSecurityGroup.id,oci_core_network_security_group.FoggyKitchenSSHSecurityGroup.id]
  }
}

data "oci_core_vnic_attachments" "FoggyKitchenJitsiMeetServer_VNIC1_attach" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[1], "name")
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  instance_id = oci_core_instance.FoggyKitchenJitsiMeetServer.id
}

data "oci_core_vnic" "FoggyKitchenJitsiMeetServer_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.FoggyKitchenJitsiMeetServer_VNIC1_attach.vnic_attachments.0.vnic_id
}

output "FoggyKitchenJitsiMeetServerPublicIP" {
   value = [data.oci_core_vnic.FoggyKitchenJitsiMeetServer_VNIC1.public_ip_address]
}

output "FoggyKitchenJitsiMeetServerPrivateIP" {
   value = [data.oci_core_vnic.FoggyKitchenJitsiMeetServer_VNIC1.private_ip_address]
}