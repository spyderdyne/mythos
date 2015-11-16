Medusa slave script executors

This mechanism allows the administrator to place ad-hoc commands into .sh files for the
slaves to execute randomly over a 15 minute window.

Files placed in the '/var/www/html/medusa/scripts' directory will from the master server 
every 15th minute on the hour.  They are made executable, and then run after downloading.
The automation will check for previous runs of the same script via filename, renaming 
each executed script with a .bak extension to ensure that multiple runs of the same posted 
set script is only executed once on each slave to prevent race conditions.

Those files are pulled to, managed at, and archived in this directory.  the master host 
scripts directory that is exposed behind the web server is a symbolic link to this location,
and any scripts placed here on the master will be downloaded and executed from here.  Files 
here should be owned by root and set to 644 permissions.
