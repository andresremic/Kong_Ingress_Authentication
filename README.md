# Table of contents

1. [Summary](#summary)
2. [Guide](#guide)  
3. [Appendix](#appendix)

## Summary 
This repository contains the files and steps necessary to deploy a kubernetes cluster with a Kong service to perform authentication. 

## Guide

Steps:

1) Create infrastructure  
```bash 
> Terraform plan + apply <br>
```

2) Configure kubectl  
```bash 
> aws eks update-kubeconfig --region region-code --name my-cluster <br>
```

3) Create namespace for Kong <br>

We create the kong namespace, where all our tests will be done. <br>

```bash 
> kubectl create namespace kong
```

We expect to see: <br>
```bash 
namespace/kong created <br>
```

4) Deploy Kong without DB <br>

Run 
```bash 
kubectl apply -f kong_files/kong_deploy_no_db.yml <br>
```
To create a minimal installation of Kong without a DataBase. This means all the consumers and credentials will be treated as objects in the following steps. <br>
This step creates several resources: <br>
```bash 
customresourcedefinition.apiextensions.k8s.io/kongplugins.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongconsumers.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongcredentials.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongingresses.configuration.konghq.com created
serviceaccount/kong-serviceaccount created
clusterrole.rbac.authorization.k8s.io/kong-ingress-clusterrole created
clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-clusterrole-nisa-binding created
configmap/kong-server-blocks created
service/kong-proxy created
service/kong-validation-webhook created
deployment.extensions/kong created
```

if this went well, the command ```kubectl get svc -n kong``` will output the kong-proxy LoadBalancer's IP and ports. 

5) Save the Load Balancer's address in an environment variable <br>

```bash 
> export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" service -n kong kong-proxy)
```

6) Create a service to test Kong <br>
```bash 
> kubectl apply -f kong_files/kong_httpbin_custom_service.yml 
```

This is the example service we are using to see what happens with our requests. In the final product, our software service will be here. This example will create a forward to an external service, provided by httpbin.org in the path /foo, and an internal echo service in /bar. <br>

We should get the response 
```bash 
 "service/httpbin created"
```

If everything went well, doing 
```bash 
> curl -i $PROXY_IP/bar 
```
will give us information regarding out request and the state of the pod running the Kong Proxy. 

7) Create the HMAC plugin for Ingress. 
```bash 
> kubectl apply -f kong_files/kong_plugin_hmac.yml
```

8) Create the Ingress controller's rules that will perform the authentication
```bash 
> kubectl apply -f kong_files/kong_ingress_hmac.yml
```

9) Create a `consumer` with HMAC credentials. 
```bash 
kubectl apply -f kong_files/kong_consumer_hmac.yml
```

Now doing 
```bash 
>curl -i $PROXY_IP/bar 
```
should respond with a `"401: Unauthorized"` message. 

10) Authenticate in Kong

To authenticate, one can either use a Postman script or use the provided script located in `hmac_scripts` called `kong_hmac.py`.  
By default it has the user and key values set in the example consumer. 

Running this script should return a `Response` code `200` and information regarding the request and the pod running Kong Proxy. 


## Appendix:

For the sake of reusability and learning potential, I have included in this repository other files I created along the development process that would allow developers to set up a Kong Ingress controller with anonymous access, basic user+password authentication, API key authentication, and HMAC authentication. All that is needed is to apply the corresponding combination of consumer + plugin to use that authentication, and commenting out the unnecessary ones in the service file. Keep in mind that if more than one authentication is enabled there, then Kong will try to enforce *ALL* of them. 
