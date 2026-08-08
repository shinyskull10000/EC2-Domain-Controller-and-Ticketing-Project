# AWS EC2 Active Directory Lab

Standing up a Windows domain controller on AWS EC2, managing users/groups via PowerShell, and running the work through a ticketing workflow (Zendesk) to simulate a real IT operations process.

## Table of Contents


## Project Goal
This project simulates a small-business IT environment: provisioning a Windows Server domain controller in AWS, managing the user lifecycle via PowerShell, and processing each change through a ticketing system, to demonstrate proven experience with level 1 sysadmin/help-desk workflows end to end.

## Architecture

Domain Controller/ AMI: Windows Server 2025 t3.medium
Domain: corplab.local
VPC and subnet: The setup for this lab includes one VPC and inside that, one public subnet.
Contained in the public subnet is the domain controller and a domain joined client with an ip given through DCHP.
The internet gateway alsop only lets in RDP from my own IP address.

#### Something to note
In a legitimate production environment outside of this lab, I would not expose my 3389 port directly for RDP and instead using something like a bastion host.

