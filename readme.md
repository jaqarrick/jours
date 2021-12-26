# Jours
#### 🚧 _This is a W.I.P._ 🚧
Jours is a simple CLI designed for safe and secure journaling. 

## Installing
Use curl to add `jours` to your path:

```
curl 'https://raw.githubusercontent.com/jaqarrick/jours/main/jours.sh' -o /usr/local/bin/jours
```
Make the script executable:
```
chmod +x /usr/local/bin/jours
```


## Getting started

After installing run

```
jours init
```

You will be prompted to input a location for your journal. This defaults to `~/Documents/jours` 

You will then be prompted to create a password for your journal. Just hit enter to let jours recommend a password. 

**IMPORTANT**: **If you forget or lose your password, you will not have access to any of your encrypted entries!**

Once initiated, you can run
```
jours login
```
You'll be prompted for a password. 

## Creating an entry
Compose an entry with:
```
jours compose
```
Or, edit a specific entry with 
```
jours compose <date>
```
`<date>` is in `YYYY-MM-DD` format, for example:
```
jours compose 2011-11-31
```

## Reading your entries
If you want to read a single entry or collection of entries without editing run
```
jours read <date>

# or

jours read <month>
```
`<month>` is in `YYYY-MM` format and concatinates all entries from a given month into a single text file. 

The `read` command decrypts all relevant entries and prints the result in the `/exposed/<journal name>.txt`.

## Logging out
To logout from jours simply type
```
jours logout
```

This encrypts all unencrypted entries, removes the `journal.txt` file, and locks the `/entries` directory.

## Switching Journals 
Jours supports multiple journals to keep your thoughts and notes more organized. To create a new one use
```
jours create <journal name>
```

To switch journals while logged in use
```
jours switch 

# or

jours switch <journal name>
```

## Locking entries

If you want to manually lock or unlock entries while logged in, use the `lock` or `unlock` command. 

To lock/unlock the entry for today's date just run
```
jours lock

# or 

jours unlock
```
To lock/unlock a specific entry run
```
jours lock <date>

# or

jours unlock <date>
```
To lock/unlock _all_ entries run
```
jours lock all

# or

jours unlock all
```

