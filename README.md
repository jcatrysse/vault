# Vault

Is a plugin for project management system Redmine.
Allows you to store various passwords/keys in one place for the project.

# Installation

```
# cd redmine/plugins 
# git clone https://github.com/noshutdown-ru/vault
# cd ../
# bundle install --without development test
# rake redmine:plugins:migrate RAILS_ENV=production
```

* After installing a plugin, open the settings ( http://*/settings/plugin/vault ) 
and enter encryption key in the Encryption key field.

* Or use encryption Redmine Encryption, to do this, 
add the encryption key to a file ( config/configuration.yml ), for example ( database_cipher_key: HediddAwkAbCunnoashtAlEcBuobdids ) and check the box on the Use Redmine Encryption.