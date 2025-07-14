output "instance_public_ip" {
  description = "Endereço IP público da instância de VM."
  value       = oci_core_instance.always_free_vm.public_ip
}

output "latest_ubuntu_image_used" {
  description = "Informações sobre a imagem do Ubuntu que foi automaticamente selecionada e utilizada."
  value       = data.oci_core_images.latest_ubuntu_image.images[0]
}