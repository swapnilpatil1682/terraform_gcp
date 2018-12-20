// Configure the Google Cloud provider
// Replace credentials with correct credential file name for you gcp project 
// You can download your credentials file from API and services -> credentials.
// Update the correct project ID 

provider "google" {
 credentials = "${file("test-math-224420-103585a5e699.json")}"
 project     = "test-math-224420"
 region      = "us-west1"
}



// Terraform plugin for creating random ids

resource "random_id" "instance_id" {
 byte_length = 8
}

// A host project provides network resources to associated service projects.
resource "google_compute_shared_vpc_host_project" "host" {
  project = "test-math-224420"
}


// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
 name         = "centos-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-7"
   }
 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}
