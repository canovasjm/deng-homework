## GCP SDK set up  

For the sake of standardization rename your gcp-service-accounts-credentials file to `google_credentials.json` and store it in your `$HOME` directory.  

``` bash
cd ~ && mkdir -p ~/.google/credentials/
mv <path/to/your/service-account-authkeys>.json ~/.google/credentials/google_credentials.json
```

### In my laptop  

Set the environment variable:  

`export GOOGLE_APPLICATION_CREDENTIALS="/home/jm/.google/credentials/google_credentials.json"`

Then authenticate (in this case using OAuth):  

`gcloud auth application-default login`  

### In the remote VM in GCP  

Set the environment variable:    

```bash
cd ~
sudo nano .bashrc
# add the GOOGLE_APPLICATION_CREDENTIALS environmnet variable to .bashrc
export GOOGLE_APPLICATION_CREDENTIALS="/home/canovasjm/.google/credentials/google_credentials.json"
```  

Then authenticate:  
`gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS`  
