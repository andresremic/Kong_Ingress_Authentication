# resource "kubernetes_deployment" "hmac_poc" {

#   metadata {
#     name = "hmac-auth-example"
#     labels = {
#       app = "hmac-auth"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "hmac-auth"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "hmac-auth"
#         }
#       }
#       spec {
#         container {
#           image = ""
#           name  = "hmac-auth-poc"

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#           }
#         }

#         container {
#           image = ""
#           name  = "hmac-auth-poc-ingress"

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#           }
#         }
#       }
#     }
#   }

# }


# resource "kubernetes_service" "hmac_poc" {
#   metadata {
#     name = "echo-service"
#     labels = {
#       app = "hmac-auth"
#     }
#   }
#   spec {
#     selector = {
#       app = "echo-pod"
#     }
#     session_affinity = "ClientIP"
#     port {
#       port = 8080
#       target_port = 80
#       protocol = "TCP"
#     }
#     type = "LoadBalancer"
#   }
# }

# resource "kubernetes_ingress_class" "hmac_poc" {
#   metadata {
#     name = "proxy-from-k8s-to-httpbin"
#     annotations = {
#       "konghq.com/strip-path" = true
#     }
#   }
#   spec {
#     controller = "konghq.com/strip-path"
#   }
# }

