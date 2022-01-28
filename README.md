
# Integrating SCOM with Server Suite
This documentation is for people who are deploying the Centrify custom SCOM management pack. This documentation includes information about prerequisites, setup, and how to use the Centrify custom [SCOM management pack](https://confluence.centrify.com/pages/viewpage.action?pageId=61538958).

## Prerequisites
1. System Center Operation Manager (SCOM) 2016 or above.
  1. Management Server. (Required)
  2. Operations Console. (Required)
  3. Web Console. (Optional)
  4. Reporting Server. (Optional)
2. Microsoft SQL Server.
3. For detailed prerequisites of SCOM 2016, please go through this [https://docs.microsoft.com/en-us/system-center/scom/system-requirements?view=sc-om-2016](https://docs.microsoft.com/en-us/system-center/scom/system-requirements?view=sc-om-2016).
4. Centrify Products installed that need to be monitored.
5. Centrify provided custom SCOM management pack "Centrify.MP.mp"

Make sure that you deploy SCOM with appropriate user permissions for its Operations Manager Accounts. Factors that can affect the account permissions depend on your network setup, such as a local administrator or domain administrator, and also where the systems are that you need to monitor.

You use the the SCOM Discover Wizard to start SCOM monitoring on systems where you have installed Centrify Server Suite components. Below is information for adding different types of systems and some information for how to use SCOM with Server Suite.

## Adding Windows systems to monitor in SCOM
In this section, we will learn to add Windows systems under SCOM monitoring using discovery wizard. This is a pre-requisite for Centrify SCOM management pack to work, only those machines which are being monitored by SCOM can be monitored by Centrify SCOM management pack.

1. After you have installed SCOM, open the SCOM console.
2. At the bottom, click  **Administration**.
3. Right-click in the top-left panel of that area to open the context menu.
4. Click on the  **Discovery Wizard**  from the context menu.
5. A wizard should open, at its first step select  **Windows**  and click  **Next**.
6. Choose  **Automatic computer discovery** , or you can specify the required parameters manually in the next step.
7. In the next step, select the option to  **Use selected Management Server Action Account**  for scanning the network. This account should be a domain account if systems that you want to monitor are in the network domain.
8. To start finding systems in your network, click  **Discover**.
9. From the Discovery Results page, select the desired systems that you want to monitor.
10. For the Management mode, select  **Agent. ** Selecting this option will automatically install the SCOM-Agent software on the selected system(s).
11. Follow the instructions to finish the discovery wizard. After you have successfully discovered and added the required systems, a message displays indicating success.
12. The added system(s) display in the Administration \&gt; Device Management \&gt; Agent Managed section. Added systems are also displayed in the Monitoring \&gt; Windows Computer section (_this one includes Management Server_). At this point, these selected Windows machines are being monitored. For instance, if any system shuts down, SCOM will know and will show the system status with a grey icon.

## Adding Unix/Linux systems to monitor in SCOM
Before you add Unix or Linux systems, you need to first configure the resource pool and Run As account settings.

###### Configuring the Unix/Linux resource pool and run as account settings
1. Go to  **Administration**  ->  **Resource**  pool, and click  **Create Resource Pool**  in the Tasks panel.
2. Click  **Add**  and then click  **Search**  to display all management servers.
3. Select the Management server(s) that you want to perform Unix and Linux Monitoring.
4. Add your management servers and click on the "Create" button at the last step to create the pool.
5. In the actions panel, click  **View Resource Pool Members**  to verify membership.
6. To add "Run As Account", go to  **Administration**  ->  **Run As configuration**  ->  **Unix/Linux accounts**  -> click  **Create Run As Account**  from Task Panel.
7. In the wizard enter a display name for the account.
8. On the next screen, enter the credentials that you want to use for monitoring the UNIX/Linux system(s).  These accounts must exist on each UNIX/Linux system and have the required permissions.
9. Choose distribution security. The  **More Secure**  option is recommended.
10. Because of the More Secure distribution security selection, choose the distribution of the Run As account.
  1. Find your  **UNIX/Linux Monitoring Account**  under the UNIX/Linux Accounts screen, and open the properties.
  2. On the Distribution Security screen, click  **Add** , then select  **Search by resource pool name**  and click  **Search**.
  3. Find your Unix/Linux monitoring resource pool, and click  **Add** , then click  **OK**.  This distributes the account credential to all management servers in the pool.
11. Create the Agent Maintenance Account, following a similar process as earlier.
 The Agent Maintenance Account is used for SSH, which includes the ability to deploy, install, uninstall, upgrade, and sign certificates –- these are all activities that involve the agent on the UNIX/Linux system.
  1. On the wizard presented, give the Agent Maintenance account a name:
  2. From here you can choose to use an SSH key, or a username and password credential only.  You also can choose to leverage a privileged account or a regular account that uses sudo.
  3. Repeat the steps to choose the distribution security and the Run As Account distribution.
12. Configure the Run As profiles.
 There are three profiles for Unix/Linux accounts:
  - Unix/Linux Action Account
  - Unix/Linux Agent Maintenance Account
  - Unix/Linux Privileged Account
  - Start with the Unix/Linux Action Account profile.  Right-click the account and choose  **Properties** , and on the Run As Accounts screen, click  **Add** , then select the "UNIX/Linux Monitoring Account". Leave the default of "All Targeted Objects" and click  **OK** , then click  **Save**.
  - Repeat this same process for the Unix/Linux Privileged Account profile, and associate it with your "UNIX/Linux Monitoring Account".
  - Repeat this same process for the Unix/Linux Agent Maintenance Account profile, but use the "Unix/Linux Agent Maintenance Account".

## Adding the Unix/Linux systems in SCOM
1. Open the Discovery Wizard (_as mentioned in the first section above_).
2. For the Discovery Type choose  **Unix/Linux**  and click  **Next**.
3. On the next screen click  **Add**...
4. Here you will enter the FQDN of the Linux/Unix machine, its SSH port (22 default), and then choose  **All Computers**  in the discovery type. Check the box for  **Use Run As Credentials**.  This will leverage the existing Agent Maintenance account for the discovery and deployment.
5. Click  **Save. **
6. On the next screen, select a resource pool. Choose the resource pool that you already created.
7. Click  **Discover** , and the results will display:
8. Check the box next to your discovered Unix/Linux system and click  **Manage**  to deploy the SCOM agent.
9. After the agent deploys successfully, the selected machine displays in Administration "Device Management" Unix/Linux Computers.
10. Note: you may need to add/import some OS-specific SCOM management pack when you try setting up a non-Windows machine. Please follow the respective instructions that SCOM presents.

## Installing the Centrify SCOM Management Pack
You need to install the provided custom SCOM management pack Centrify.MP.mp.
1. Go to  **Administration**  panel \&gt; right-click  **Management Pack**  \&gt;  **Select Import Management Packs...**
2. In the wizard, Click  **Add**  \&gt;  **Add from disk...**
3. Choose  **Yes**  if asked for "Online Catalog Connection".
4. Search for the file "Centrify.MP.mp" from your disk; this is the custom SCOM management pack provided by Centrify.
5. Click  **Install**.
6. After a successful install, the management pack displays in the "Installed Management Pack" section.

## Using the Centrify SCOM Management Pack

The installed custom management pack does all of the work on its own. You just need to check the SCOM console sections mentioned below to see the monitoring being done and alerts being raised.

1. **Discovering: Centrify Collector:**: After the installation of the custom SCOM management pack, in the SCOM Monitoring section, there is a custom folder "Centrify". This folder is the Collectors node which lists all Collectors installed system(s) being managed by SCOM. The Details View of SCOM also shows information regarding those collector(s).
2. **Monitoring: Centrify Collector:**: You can go to "health explorer" for a discovered Collector from Task Panel on the right. It shows that it is monitoring the availability of collector service. If that service is stopped, an alert displays in the SCOM Console. You can access the Health Explorer window by selecting the collector system and then from the Task pane you click Health Explorer.
3. **Discovering: Centrify DirectAudit Agent:**: In the "Centrify" folder is the DirectAudit Agents node. This node lists all the DirectAudit Agent installed systems(s) that are managed by SCOM. The Details View also shows information regarding those DirectAudit Agents.
4. **Monitoring: Centrify DirectAudit Agent:**: You can go to "health explorer" for a discovered DirectAudit Agent from Task Panel on the right. It shows that it is monitoring the availability of the DirectAudit Agent service, the status of the DirectAudit Agent according to registry key entries and disk space (for the C drive). If the DirectAudit Agent service stops (by either the Windows service or its status in the registry entry), a Critical alert displays in SCOM. And if "% free disk space" for the C drive goes below the configured threshold,  a warning displays.
5. **Discovering: Centrify DirectAuthorize Agent:**: In the "Centrify" folder is the DirectAuthorize Agents node. This node lists all DirectAuthorize Agents installed on the system(s) being managed by SCOM. In the Details View, it also shows information regarding those DirectAuthorize Agent(s).
6. **Monitoring: DirectAuthorize Agent:**: You can go to "health explorer" for a discovered DirectAuthorize Agent from Task Panel on the right. It shows that it is monitoring the availability of the DirectAuthorize Agent service and the status of the DirectAudit Agent according to the registry key entry. If the DirectAuthorize Agent service stops (by either the Windows service or its status in the registry entry) a Critical alert displays in SCOM.
