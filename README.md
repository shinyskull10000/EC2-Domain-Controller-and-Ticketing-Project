# AWS EC2 Active Directory Lab

Standing up a Windows domain controller on AWS EC2, managing users/groups via PowerShell, and running the work through a ticketing workflow (Zendesk) to simulate a real IT operations process.


## Project Goal
This project simulates a small-business IT environment: provisioning a Windows Server domain controller in AWS, managing the user lifecycle via PowerShell, and processing each change through a ticketing system, to demonstrate proven experience with level 1 sysadmin/help-desk workflows end to end.

## Architecture

Domain Controller/ AMI: Windows Server 2022 Base t3.medium
Domain: corplab.local
VPC and subnet: The setup for this lab includes one VPC and inside that, one public subnet.
Contained in the public subnet is the domain controller and a domain joined client with an ip given through DCHP.
The internet gateway also only lets in RDP from my own IP address for both EC instances.

### Diagram
![LabDiagram](screenshots/Architectureoflab.png)
This diagram outlines of the lab as well as showing what connections are allowed between each EC2 isntance.

#### Something to note
In a legitimate production environment outside of this lab, I would not expose my 3389 port directly for RDP and instead using something like a bastion host.

## Provisioning the EC2 instances

![SecurityGroupScreenShot](screenshots/securitygrouprules.png)

Provisioned Windows 2022 Base t3.medium and t3.small with security groups that allow for RDP from my IP. both instances are in seperate security groups but for this lab have the same rules. 

![SecurityGroupInboundRulesDC](screenshots/DCSecuritygroupinboundrules.png)

In order for the client EC2 instance to connect into the domain controller, the inbound rules for the domain controller need to be updated so that when the domain-joined client wants to connect and log in to an account on the DC. It is possible for this to happen outside of using my personal IP. The security group of the client is set as the source so that each individual IP doesn't have to be added if there were more than 1 client.

## RDP into the EC2 instance to begin the lab

![RDPwithAmazon](screenshots/RDPintoDC.png)

Connecting with the EC2 instance through RDP. This represents how in some tech scenarios you may have to RDP into some machines to do changes. However RDP is not the most secure and their should be precautions made to ensure proper authentication and security.

## Powershell Command Processing (full user lifecycle)

#### Installing windows AD DS
![ADDomainServicesInstall](screenshots/ADDomainServices.png)

#### Promoting to a new forest with the domain name as corplab.local
![ADDSForestInstall](screenshots/ADDSForestInstall.png)
This step reboots the server so you will have to log back in with RDP as the administrator for the instance.
#### Post promotion verification
running these 3 lines of script in the AD to ensure promotion was successful
![GET-ADDomain](screenshots/get-addomain.png)
![GET-ADForest](screenshots/get-adforest.png)
![DCDIAG](screenshots/dcdiag.png)

#### Taking an AMI of the instance
Getting an image at this stage of the lab is important in case problems occur and it is required to go back to when the Domain Controller was just promoted.
![AMIImage](screenshots/CreationOfAMIafterpromotingtoDomainController.png)

#### Creating OU Structure
Creating an OU structure for IT, Sales and HR to try and represent a more corporate environment within a lab. It is important to have different organisation untis within to be able to organise network resources like users, groups and computers.
![CreationofOUStruture](screenshots/CreationofOUStructure.png)
![ActiveDirectoryUsersandComputers](screenshots/activedirectoryusersandcomputers.png)

#### Creating a single user
Creating a user called JaneSmith within the Sales OU branch to showcase the ability to add a single user through active directory
![CreatingTempuser](screenshots/creatingtempuserJaneSmithFromSales.png)

#### Creating and adding user to security group
Important to have a security group as it is an object that allows for the collection of accounts to be sorted into manageable units to assign permissions.
![CreatingSecuritygroupandadduser](screenshots/CreatingSecuritygroupandaddingusertoit.png)

#### Modify a user
![ModifyAUser](screenshots/modifyuserattributes.png)
Important to be able to modify users to show appropriate information, could be related to tickets which can be tracked or gives info on the account itself.

#### Reset a Password/ unlock an account
![ResetPassword](screenshots/PasswordReset.png)
Showcasing the ability to reset a password.
![UnlockAccount](screenshots/UnlockAccount.png)
Unlocking an account incase a user becomes locked out for getting the password wrong too many times.

#### Disable/ re-enable an account
![DisableandReenableofACC](screenshots/disablingandre-enablingofanaccount.png)
In cases where the account shouldnt be deleted but disabled.

#### move a user between OUs
Moving a user between OUs e.g. if they are moved to a different apartment or team
![MovingUserBetweenOUs](screenshots/MovingUserbetweenOUs.png)

#### Delete a user
![DeletionofaUser](screenshots/deletionofauser.png)
When an account needs to be deleted.

#### Bulk create users from a csv
![bulkcreationofnewusersviaCSV](screenshots/bulkcreationthroughnewusersCSV.png)
In cases where multiple users need to be added at once, it is possible to use a csv and a powershell script (as seen in scripts/bulkcsvaddition.ps1)

#### Audit after adding accounts
![listofusersafterbulkadd](screenshots/listofusersafterbulkadd.png)

Using the commands in powershell in scripts/audittoreports.ps1 to be able to show the users added.

### Porting Domain Joined client into the domain controller and signing in

#### Setting Preferred DNS Server
![settingpreferredDNSServer](screenshots/ClientSettingPerferredDNS%20server.png)

#### Add-Computer 
Ran in the client powershell terminal: Add-Computer -DomainName "corplab.local" -Credential (Get-Credential) -Restart
This adds the computer to the Domain Controller and will ask you to log in throught the Get-Credential call. You will have to log in as the administrator account of the client PC.


#### Issues Encountered
There were RDP forced password change issues when trying to RDP into the jdoe account meaning a newpassword had to be set. This wouldn't occur if it wasn't done via rdp as you would just be prompted to change the password after using the temp password. It was also required for a net localgroup to be made on the client ec2 instance for the CORPLAB\jdoe account as it would also not let me RDP into that account if i did not add the account to the localgroup.

![Adding to local group](screenshots/runningcommandsonclientadminacc.png)

#### RDP and log in to an account

![LoggingInAsJDoe](screenshots/SigninginasJdoe.png)

Done through RDP into the EC2 client instance. selecting different user and logging in through the username CORPLAB\jdoe.

## ZenDesk Ticketing

This aims to build and demonstrate skills related to it support and or helpdesk roles using ZenDesk as a ticketing medium to showcase the applied skills learned throughout this lab/project.

Something to note with the zendesk tickets is that without creating fake emails to log into for each requester all the information suhc as the description come from me. However I still attempt to make the flow of tickets as accurate as possible to a real enivronment through having a description with internal notes on how the job was completed, with it being solved and closed with a public reply to the requester. 

#### Ticket Mapping Table
Ticket	Task	                        Screenshot
#1	    Provision domain controller	    ![ticket1](tickets/ticket-01-dc-provisioning.png)
#2	    Build OU structure	            ![ticket2](tickets/ticket-02-ou-structure.png)
#3	    New hire Sales	                ![ticket3](tickets/ticket-03-new-hire-sales.png)
#4	    Bulk onboarding	                ![ticket4](tickets/ticket-04-bulk-onboarding.png)
#5	    Temporary account disable	    ![ticket5](tickets/ticket-05-disable-account.png)
#6	    Domain-join CLIENT01	        ![ticket6](tickets/ticket-06-domain-join.png)
#7	    Offboarding account deletion	![ticket7](tickets/ticket-07-offboarding.png)
