resource "null_resource" "FoggyKitchenJitsiMeetServerProvisioner" {
 depends_on = [oci_core_instance.FoggyKitchenJitsiMeetServer]
 
provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host     = data.oci_core_vnic.FoggyKitchenJitsiMeetServer_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/ubuntu/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "jitsi-meet-answer2.sh"
    destination = "/tmp/jitsi-meet-answer2.sh"
}

 provisioner "remote-exec" {
        connection {
                type     = "ssh"
                user     = "ubuntu"
		        host     = data.oci_core_vnic.FoggyKitchenJitsiMeetServer_VNIC1.public_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/ubuntu/myssh.sh"
                agent = false
                timeout = "10m"
        }
  inline = ["echo '== 1. Add the Jitsi package repository'",
            "sudo /bin/su -c \"echo 'deb https://download.jitsi.org stable/' >> /etc/apt/sources.list.d/jitsi-stable.list\"",
            "sudo /bin/su -c \"wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | sudo apt-key add - \"",
            
            "echo '== 2. Ensure support is available for apt repositories served via HTTPS'",
            "sudo -u root apt-get install apt-transport-https", 

            "echo '== 3. Retrieve the latest package versions across all repositories'",
            "sudo -u root apt-get update", 

            "echo '== 4. Perform jitsi-meet installation'",
            "sudo /bin/su -c \"echo 'jitsi-videobridge jitsi-videobridge/jvb-hostname string ${data.oci_core_vnic.FoggyKitchenJitsiMeetServer_VNIC1.public_ip_address}' | debconf-set-selections\"", 
            "sudo -u root chmod +x /tmp/jitsi-meet-answer2.sh",
            "sudo -u root /tmp/jitsi-meet-answer2.sh",
            "sudo -u root debconf-get-selections | grep jitsi-meet-web-config",
            "sudo -u root apt-get -y install jitsi-meet", 

            "echo '== 5. Adding entries to /etc/jitsi/videobridge/sip-communicator.properties'",
            "sudo /bin/su -c \"echo 'org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS=${data.oci_core_vnic.FoggyKitchenJitsiMeetServer_VNIC1.private_ip_address}' >> /etc/jitsi/videobridge/sip-communicator.properties\"",    
            "sudo /bin/su -c \"echo 'org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS=${data.oci_core_vnic.FoggyKitchenJitsiMeetServer_VNIC1.public_ip_address}' >> /etc/jitsi/videobridge/sip-communicator.properties\"",    

            "echo '== 6. Removing IPtables and reboot'",
            "sudo -u root apt-get -y remove iptables",
            "sudo /bin/su -c \"(sleep 2 && reboot)&\""]
  }

}

resource "null_resource" "FoggyKitchenPauseFor3Minutes" {
   depends_on = [null_resource.FoggyKitchenJitsiMeetServerProvisioner]
   
   provisioner "local-exec" {
        command = "sleep 180"
   }
}

resource "null_resource" "FoggyKitchenJitsiMeetServerStatus" {
    depends_on = [null_resource.FoggyKitchenPauseFor3Minutes]

    provisioner "remote-exec" {
        connection {
                type     = "ssh"
                user     = "ubuntu"
                host     = data.oci_core_vnic.FoggyKitchenJitsiMeetServer_VNIC1.public_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/ubuntu/myssh.sh"
                agent = false
                timeout = "10m"
        }
  inline = ["echo '== 1. Verify Jitsi status'",
            "sudo /bin/su -c \"systemctl status jitsi-videobridge2 | cat\""]
            
  }

}

