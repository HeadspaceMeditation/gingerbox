# gingerbox

#### **Located at:** [https://github.com/HeadspaceMeditation/gingerbox](https://github.com/HeadspaceMeditation/gingerbox)

## Ginger.io Eligibility Files Secure Transfer Instructions

Ginger.io uses a HIPAA compliant account of Google Drive for secure file transfers of Eligibility Files. This mechanism provides a modern and familiar web interface to upload files from a web front end. In addition, Google Drive provides secure APIs to automate the upload from the backend, much like SFTP.

## Initial Credentials For Google Drive

Ginger.io does not share the initial credentials for the Google Drive via clear text. Instead, the secure flow starts with the “Password Reset” workflow in Google Drive. Once the email address of the IT contact person is received, Ginger.io initiates the password reset flow and Google Drive sends an email with a Reset Password link. The email looks like the screenshot below. 

#### Sample Email From Google For Password Reset
![sample password reset email](https://raw.githubusercontent.com/HeadspaceMeditation/gingerbox/master/gingerbox-password-reset.png "sample password reset email")

The customer IT contact person clicks on the Reset Password button to generate a new password for their account. That password is then used to log into the Google Drive account and upload the Eligibility Files.

* **Website:** [https://drive.google.com](https://drive.google.com)
* **Username:** _<yourcompany>_@gingerbox.io _(provided to you by Ginger.io, e.g. acme@gingerbox.io)_
* The password is the one you have reset above.

## File Encryption

The **data-at-rest encryption** is a key requirement of HIPAA compliance. Ginger.io used PGP encryption methodology. The Ginger.io PGP **Public** Key is available within this GitHub repository as `gingerio_pgp_pubkey.asc`. Please use this key to encrypt the Eligibility Files before uploading to Google Drive.

## Uploading Eligibility Files To Google Drive

After signing in to Google Drive with `XXX@gingerbox.io` login, the Eligibility File should be uploaded into the folder named **"ELIGIBILITY UPLOAD"**.  

![google drive home](https://raw.githubusercontent.com/HeadspaceMeditation/gingerbox/master/google-drive-home.png "google drive home")
![google drive folder](https://raw.githubusercontent.com/HeadspaceMeditation/gingerbox/master/google-drive-folder.png "google drive folder")

Once the upload completes, the file will be processed and then it will be removed from your Google Drive for security reasons.  If there are problems with the data in the file, a failure notification will be delivered by email with a secure link to a document describing the issues with the data.

## Automating Eligibility File Uploads

Much like SFTP, the periodic file upload process can be automated using backend server scripts. Ginger.io provides supporting template scripts to get you started with Google Drive APIs. The scripts use the unix `curl` command to upload files. 

### Script: `gingerbox_upload.sh`
The `gingerbox_upload.sh` shell script along with credentials in `gingerbox.conf` file (see below) works from the command line of any Unix machine and may be used for automation.  To upload the Eligibility File to Google Drive, save the `gingerbox.conf` file in a secure path and use the syntax below:

```
$> ./gingerbox_upload.sh --config /path/to/gingerbox.conf /path/to/eligfile.csv 
```

The `eligfile.csv` will get uploaded to Google Drive account’s Eligibility File upload folder. Ginger.io will then pick up this file for downstream processing and remove this file once the processing is completed.

If there are problems with the date in the file, a failure notification will be delivered by email with a secure link to a document describing the issues with the data.

### Credentials: `gingerbox.conf`

The `gingerbox.conf` file contains critical and sensitive credentials of the API access of the Google Drive account provisioned for your organization by Ginger.io. 

After login into Google Drive, this file will be available inside the home folder, as shown in the screenshot above. Download this file for your automation needs.

Please make sure that you always keep it secure and make it available only to authorized personnel and systems within your organization. In case of any unauthorized access to these credentials, please reach out to Ginger.io immediately to help protect your Eligibility Files and rotate the credentials.
