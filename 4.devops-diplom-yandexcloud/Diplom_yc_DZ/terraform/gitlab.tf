resource "null_resource" "gitlab_01" {
  provisioner "local-exec" {
    command = "sh ../gitlab/tf-scripts/gitlab_01.sh"
  }

  depends_on = [
    null_resource.copy_ssh
  ]
}

resource "null_resource" "gitlab_02" {
  provisioner "local-exec" {
    command = "sh ../gitlab/tf-scripts/gitlab_02.sh"
  }

  depends_on = [
    null_resource.gitlab_01
  ]
}
