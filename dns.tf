# Cria uma Zona DNS na OCI para gerenciar o seu domínio.
resource "oci_dns_zone" "amcm_zone" {
  compartment_id = var.compartment_ocid
  name           = var.domain_name
  zone_type      = "PRIMARY"
}

# Cria um registro do tipo A para o domínio raiz (ex: amcm.com.br)
# Ele aponta para o IP público da instância que será criada.
resource "oci_dns_record" "a_record_root" {
  zone_name_or_id = oci_dns_zone.amcm_zone.id
  domain          = var.domain_name
  rtype           = "A"
  rdata           = oci_core_instance.always_free_vm.public_ip
  ttl             = 300
}

# Cria um registro do tipo A para o subdomínio www (ex: www.amcm.com.br)
resource "oci_dns_record" "a_record_www" {
  zone_name_or_id = oci_dns_zone.amcm_zone.id
  domain          = "www.${var.domain_name}"
  rtype           = "A"
  rdata           = oci_core_instance.always_free_vm.public_ip
  ttl             = 300
}