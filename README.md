[![Build Status](https://travis-ci.org/durandmorgan/DecoupleR.svg?branch=master)](https://travis-ci.org/durandmorgan/DecoupleR)
[![Build status](https://ci.appveyor.com/api/projects/status/qwqoai8fhio1mjxl?svg=true)](https://ci.appveyor.com/project/durandm/decoupler)

# DecoupleR
Strict separation of settings from code.

*DecoupleR* is an attempt to port the excellent python-decouple library into R.

As stated by its original author, python-decouple makes it easy to:
- store parameters in *ini* or *.env* files;
- define comprehensive default values;
- properly convert values to the correct data type;
- have **only one** configuration module to rule all your instances.

DecoupleR general behavior have been in order to mimic as much as possible python-decouple, and is tested against python-decouple unit tests.

## Priority rules and config files serach

*DecoupleR* always searches for *Options* in this order:

1. Environment variables;
2. Repository: ini or .env file;
3. Default argument passed to config.

It has to be noted that environment variables have precedence over config files in order to be unix consistent.

## Config file search
The config files are searched for, by default, in the working directory, or in the any other directory provided via the *path* argument. If no config files, *settings.ini* or *.env* is found in the directory, the search will continue in its parent directories.

## Example

### On-the-fly parameter evaluation

Parameter value can be retrieve anytime by invoking the *DecoupleR::get_var* function. If the *config* parameter is not provided, a config file search will be carried out at each function call. 

```r
  get_var('R_HOME')
```

### Preload the config file

In order to avoid recurrent config file search at each *get_var* call, the config file search can be carried out once via the *get_config* function. A list will be returned, containing the parameters from the config file if any.


## Implementated parser

*DecoupleR* supports both *.ini* and *.env* files.

### Ini file

DecoupleR can read *ini* files and provide simple interpolation.

Simply create a ``settings.ini` in your working directory or in its roots.

```ini

  [settings]
  DEBUG=True
  TEMPLATE_DEBUG=%(DEBUG)s
  SECRET_KEY=ARANDOMSECRETKEY
  DATABASE_URL=mysql://myuser:mypassword@myhost/mydatabase
  PERCENTILE=90%%
  #COMMENTED=42
```

### Env file
Simply create a ``.env`` text file on your repository's root directory in the form:

``` bash

    DEBUG=True
    TEMPLATE_DEBUG=True
    SECRET_KEY=ARANDOMSECRETKEY
    DATABASE_URL=mysql://myuser:mypassword@myhost/mydatabase
    PERCENTILE=90%
    #COMMENTED=42
```

## *undefined* parameters

On the above example, all configuration parameters except ``SECRET_KEY = config('SECRET_KEY')``
have a default value to fallback if it does not exist on the ``.env`` file.

If ``SECRET_KEY`` is not present in the ``.env``, *DecoupleR* will raise an error.

This *fail fast* policy helps you avoid chasing misbehaviors when you eventually forget a parameter.



### Casting argument

By default, all values returned by ``DecoupleR`` are ``strings``.

To easily specify a returned type, the ``get_var`` function accepts a ``cast`` argument which receives any *callable*, that will be used to *transform* the string value into something else. Some prefedined transformation have also been implementated:
- Integer: ``int``, ``integer``
- Bolean: ``bool``, ``boolean``, ``logical``
- Float: ``float``
