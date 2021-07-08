resource "null_resource" "test" {
    provisioner "local-exec" {
    command = "echo $IC_IAM_TOKEN ********** $IC_IAM_REFRESH_TOKEN"
    }
}