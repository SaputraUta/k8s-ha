variable "nodes" {
  description = "VMs to create, keyed by node name"
  type = map(object({
    cpus   = number
    memory = string
    disk   = string
  }))
  default = {
    cp1 = { cpus = 2, memory = "2G", disk = "20G" }
    cp2 = { cpus = 2, memory = "2G", disk = "20G" }
    cp3 = { cpus = 2, memory = "2G", disk = "20G" }
    w1  = { cpus = 2, memory = "3G", disk = "20G" }
    w2  = { cpus = 2, memory = "3G", disk = "20G" }
  }
}

variable "ubuntu_version" {
  type    = string
  default = "24.04"
}