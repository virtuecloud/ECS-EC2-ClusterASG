# ECS-EC2-ClusterASG

<h1 align="center"> Virtuecloud </h1> <br>
<p align="center">
  <a href="https://virtuecloud.io/">
    <img alt="Virtuecloud" title="Virtuecloud" src="https://virtuecloud.io/assets/images/VitueCloud_Logo.png" width="450">
  </a>
</p>

# Introduction

Terraform module for AWS ECS Deployment with the EC2

# Core Components

## AWS

_The AWS infrastructure is setup using terraform in the ./terraform._

_The following components are deployed:_
1. Application Load Balancer 
2. ECS Cluster / ECS Service 
3. Security Groups
4. AutoScaling
5. VPC
