provider "azurerm" {
    version = "~> 2.38"
    features {}
}

data "template_file" "init" {
    template = file("./userdata/userdata.tpl")
    count = "${var.howmany}"
    vars = {
        pp_environment = var.environment
        pp_datacenter  = "azure-eastus"
        pp_role        = "role::development_server"
        pe_server      = var.pe_server
        fqdn           = "your_machine_name-${format("%02d", count.index+1)}.${var.region}.cloudapp.azure.com"
    }
}

resource "azurerm_linux_virtual_machine" "your_machine_name" {
  name                = "your-machine-name-${format("%02d", count.index+1)}"
  count               = var.howmany
  resource_group_name = azurerm_resource_group.your_machine_name.name
  location            = azurerm_resource_group.your_machine_name.location
  size                = "Standard_D1_v2"
  admin_username      = "ubuntu"
  custom_data         = base64encode("${element(data.template_file.init.*.rendered, count.index + 1)}")
  network_interface_ids = ["${element(azurerm_network_interface.your_machine_name.*.id, count.index + 1)}"]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/yourkey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
// Insert the info for your desired machine image
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
//   source_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }
