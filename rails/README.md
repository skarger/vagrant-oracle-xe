- Ensure app can see /etc/tnsnames.ora: $ export TNS_ADMIN=/etc
- Download the ojdbc6.jar and put in the lib directory of the rails app (client_application). Note that Oracle also provides a debug version, ojdbc6_g.jar
- If you get "Illegal key size: possibly you need to install Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files for your JRE" when loading a page:
-- Install JCE Unlimited. See this answer to get the download for your JDK:  http://stackoverflow.com/a/6481658
-- After downloading, unzip the file and do something like this, changing to the appropriate path:
```16492  cd /Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home/jre/lib/security/
sudo mv local_policy.jar local_policy.jar.orig
sudo mv US_export_policy.jar US_export_policy.jar.orig
sudo cp ~/Downloads/UnlimitedJCEPolicy/*jar .
```
