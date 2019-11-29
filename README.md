# EMail to YNAB adapter

## Why
I built this for personal use, since YNAB sadly only supports US Banks.

And the only way I could get the data from my bank without needing to go through 2-factor login every sync was to active the email notifications.

## How/What does it do
It gets the emails from the configured imap email server and the mailbox.
All processed and to YNAB pushed emails get marked as 'FLAGGED'

To get all the information for YNAB it relies on regexps

For the configuration I used a yaml file it's the easiest to read/write as a human.


### Config

The configuration is split in 7 parts:

| parent config key | child key | value | required |  
|---|---|---|---|
| email |
|  | email_server | tld of your email server                | ✓ |
|  | server_port  | the port of your email server           | ✓ |
|  | username     | the username of the used account        | ✓
|  | password     | the password of the used account        | ✓
|  | mailbox      | the mailbox where the emails are stored | ✓
| ynab
|  | api_key      | your ynab api key   | ✓
|  | budget_id    | your ynab budget_id | ✓
| pushbullet
|  | active       | set to true if you want to get notified via pushbullet of any failures during the creation of the ynab transactions. otherwise set to false | ✓
|  | api_key      | your pushbullet api key | if pushbullet.active == true
|  | device_id    | your pushbullet device_id which gets notified | if pushbullet.active == true
| accounts        |  | this is a hashmap for mapping different accounts to their id | ✓
|  | the string as its found in your email | the accounts uid in ynab
| transfer_types  |  | the strings used to determine if a email entry is a credit or debit
|  | credit | the string for credit ("Gutschrift" in my example) | ✓
|  | debit  | the string for debit  ("Belastung" in my example)  | ✓
| transfer_ids    |  | this is a hashmap for the mapping of account transfers to their "payee_name" | ✓
|  | the string as its found in the email  | the accounts transfer id in ynab
| email_parts_regexps |  | the regexps to filter the different parts
|  | account      | the account name, this will be compared against the accounts list | ✓
|  | amount       | the payed/received amount                                         | ✓
|  | booking_date | the booking date   | ✓
|  | entry_type   | debit/credit string that will be compared against the transfer_types strings | ✓
|  | memo         | the content to add as the memo in ynab                            | ✓
|  | valuta_date  | the valuta date, will be used for ynab, if there is a date in memo that one will be used instead | ✓
