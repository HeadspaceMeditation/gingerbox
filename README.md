# gingerbox

Membership and eligibility file upload tool for ginger.io clients and partners.

## Sending files programmatically: 

If you wish to automate your eligibility file transmission, your Ginger.io account manager can send you a utility called gingerbox_upload.sh.  This utility will be accompanied with a credentials.txt file which is sent separately for security purposes.  The utility should work from the command line of any unix or linux machine and can be easily automated.  To upload the file to your google drive, save the credentials.txt file on your computer and use the syntax indicated below to point the uploader at both the credentials file, and the file you wish to upload.  See example command below: 

```
$> ./gingerbox_upload.sh --config credentials.txt file_to_upload.csv 
```

The file_to_upload.csv will be uploaded to your google drive account’s Eligibility file upload folder (see _Sending files with Google Drive_ below).  Processing and error reporting will be handled identically to manually uploaded files via google drive.

## What encryption methods does Ginger.io support?

We recommend that you encrypt your files before sending them to us.  Encrypt the file with gpg and the provided Ginger.io public key.  Be sure to append the additional file extension “.gpg” to the file so that we can identify and correctly route the file for secure storage and decryption.  

## Do files have to be encrypted before uploading them to Ginger.io?

Though we strongly encourage file level encryption, all of our delivery methods are encrypted and comply with HIPAA standards.  If you do not wish to encrypt your files prior to transmission we will still accept your unencrypted file via the secure transmission methods we describe in this document. 

## Sending files with Google Drive

Your account manager will send you an invitation by email that will give you access to your google drive folder <your_org>@gingerbox.io.  

Once you have signed in to Google drive with your gingerbox.io login, you can simply drag your eligibility file into the folder named _Eligibility file upload_.  After the upload completes, the uploaded file will be processed within the hour and will disappear from your google drive _Eligibility upload folder_.  If there was a problem with the file, you will receive a failure notification by email with a link to a document describing issues with the file that may need to be amended.

