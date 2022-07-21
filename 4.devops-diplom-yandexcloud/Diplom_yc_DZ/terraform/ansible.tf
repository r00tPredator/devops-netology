resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 100"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "squid" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t squid ../ansible/site.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "preconfigure" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t preconfigure ../ansible/site.yml"
  }

  depends_on = [
    null_resource.squid
  ]
}

resource "null_resource" "nginx" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t nginx ../ansible/site.yml"
  }

  depends_on = [
    null_resource.preconfigure
  ]
}

resource "null_resource" "database" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t mysql ../ansible/site.yml"
  }

  depends_on = [
    null_resource.preconfigure
  ]
}

resource "null_resource" "wordpress" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t wordpress ../ansible/site.yml"
  }

  depends_on = [
    null_resource.database
  ]
}

resource "null_resource" "prometheus" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t prometheus ../ansible/site.yml"
  }

  depends_on = [
    null_resource.preconfigure
  ]
}

resource "null_resource" "alertmanager" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t alertmanager ../ansible/site.yml"
  }

  depends_on = [
    null_resource.prometheus
  ]
}

resource "null_resource" "grafana" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t grafana ../ansible/site.yml"
  }

  depends_on = [
    null_resource.prometheus,
    null_resource.alertmanager
  ]
}

resource "null_resource" "gitlab" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t gitlab ../ansible/site.yml"
  }

  depends_on = [
    null_resource.preconfigure
  ]
}

resource "null_resource" "runner" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t runner ../ansible/site.yml"
  }

  depends_on = [
    null_resource.gitlab
  ]
}

resource "null_resource" "copy_ssh" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml -t copy_ssh ../ansible/site.yml"
  }

  depends_on = [
    null_resource.runner,
    null_resource.wordpress
  ]
}
