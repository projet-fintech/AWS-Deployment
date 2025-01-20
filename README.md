# Cloud-Native Application Deployment
![WhatsApp Image 2025-01-20 at 00 04 35_d9bb6ec2](https://github.com/user-attachments/assets/d0c47e92-e642-4c24-b597-47eb28ad435a)



## Infrastructure Preparation with Terraform
To deploy a cloud-native application, the first step was to prepare the infrastructure using Terraform, an Infrastructure as Code (IaC) tool.

### Virtual Private Cloud (VPC) Setup
The initial phase involved creating a **Virtual Private Cloud (VPC)**, which provides a logically isolated environment within AWS, containing multiple subnets:

--> **Public Subnets:** These host services that require direct internet access, such as the **Application Load Balancer (ALB).**

--> **Private Subnets:** These accommodate internal services such as **Amazon EKS** (Elastic Kubernetes Service) and **Amazon RDS** (Relational Database Service), ensuring security by preventing direct internet access.

To manage inbound and outbound traffic, the following components were added:

 -->**Internet Gateway:** Enables resources within the VPC to send and receive traffic to and from the internet.
 -->**NAT Gateway:** Allows instances in private subnets to access the internet for updates and API interactions while blocking inbound internet access.

Multiple **Availability Zones (AZs)** were configured to enhance high availability and fault tolerance.

## Security Configuration
-->To ensure infrastructure security, we implemented **Security Groups**, which act as virtual firewalls to control inbound and outbound traffic. The security rules were defined to allow only necessary traffic to the services.

## AWS Services Deployment
After setting up the network, critical cloud services were deployed:

### Amazon EKS (Elastic Kubernetes Service)

 -->Deployed within private subnets.
 
 -->Created **Node Groups**, consisting of multiple EC2 instances serving as compute nodes to run containerized workloads.
 
 -->Deployed **Kubernetes manifests**, defining resources such as pods, services, and deployments.
 
 -->Container images are stored in **Amazon ECR (Elastic Container Registry)** before execution within pods.

### Amazon RDS (Relational Database Service)

 --> Deployed a **MySQL instance** within the private subnet.
 
 -->Integrated with **Amazon S3** to facilitate data import and export.

## Monitoring and Observability
To monitor both the infrastructure and applications, the following tools were set up:

 **Amazon CloudWatch:** Collects and analyzes AWS service metrics.
 **Prometheus:** Gathers Kubernetes cluster metrics.
 **Grafana:** Provides interactive dashboards for visualizing collected metrics.

![image](https://github.com/user-attachments/assets/fdd88721-e5e8-4002-9820-826678b96d32)
![image](https://github.com/user-attachments/assets/a3bc3ba7-1de2-4746-b7c2-2eff7c2b4e97)
![image](https://github.com/user-attachments/assets/40fc7632-b828-4931-b2db-b8327de5c43d)
![image](https://github.com/user-attachments/assets/361e2ff0-a1c4-4ce4-9f4a-70256c56fb5c)





## Automation with Terraform
Terraform was used to declaratively manage the entire infrastructure. The `data` command in Terraform was leveraged to dynamically retrieve VPC and subnet IDs, enabling seamless and scalable service integration within AWS.


## Elastic Kubernetes Cluster Architecture
![WhatsApp Image 2025-01-20 at 00 18 11_161e522d](https://github.com/user-attachments/assets/cebfcf4b-5b46-4784-9748-18f2edd22a62)


The diagram above illustrates the architecture of an Elastic Kubernetes Service (EKS) cluster used to deploy a cloud-native application. The deployment consists of multiple node groups categorized by their roles and functionalities.

### Node Groups Overview

1. **Backend Node Group (Spring Boot)**  
   - This node group contains microservices implemented using Spring Boot. Each microservice is deployed as a container to provide various backend functionalities, including:  
     - **Account container:** Handles user accounts management.  
     - **Authentication container:** Manages user authentication and authorization.  
     - **Insurance management container:** Manages insurance-related operations.  
     - **Transaction container:** Handles financial transactions processing.  
     - **Loan management container:** Provides loan-related services.  
     - **User container:** Manages user profiles and information.  
     - **Notification container:** Handles notifications and messaging.  
   - The backend services are exposed internally within the cluster via a **ClusterIP** service.

2. **Frontend Node Group (React)**  
   - The frontend node group hosts React-based dashboards to provide user interfaces for different roles:  
     - **Client dashboard container:** Interface for end-users to interact with the system.  
     - **Admin dashboard container:** Interface for administrators to monitor and manage the system.  
   - These frontend services are exposed externally using a **LoadBalancer** service.

3. **Models Node Group (Flask)**  
   - This node group contains machine learning models implemented in Flask for various predictive services:  
     - **Loan approval container:** Provides loan approval predictions.  
     - **Car insurance container:** Handles insurance risk assessment for vehicles.  
     - **Health insurance container:** Manages predictive analytics for health insurance.  
   - The services in this node group are exposed internally within the cluster via a **ClusterIP** service.

### Networking and Load Balancing

- **AWS Load Balancer Controller (ALB Ingress)**  
  - The AWS Load Balancer Controller is responsible for handling external requests and routing traffic to the appropriate frontend services.  
  - It ensures proper distribution of requests and facilitates secure access from the internet to the frontend services.


### the home page of our project from aws url 
![image](https://github.com/user-attachments/assets/41209654-d017-43f1-9924-4844105e9d7c)









