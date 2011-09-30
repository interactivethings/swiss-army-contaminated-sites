DEVELOPMENT
===========

* ALWAYS develop new features in the "develop" branch.
* Only merge working versions, which have been deployed, into the master branch.
* When you deploy a version, create a version tag and update the changelog in this document.
* Don't forget to push, and publish branches and tags.

LOCAL TESTING
=============

<code>middleman server</code>

Runs on http://0.0.0.0:4567/ per default.


DEPLOYMENT
==========

<code>middleman build</code>

Asks for Hostpoint server password, publishes to <code>/www/staging.interactivethings.com/frankexp_i2021_awesome_website</code> (http://staging.interactivethings.com points to this folder).

To deploy into production, move the contents of above's location to /www/interactivethings.com using an FTP client.

CHANGELOG
=========

1.1
-----
Date: 2011-09-26
Author: Benjamin

Switched to Middleman

1.0
---
Date: 2011-05-26
Author: Benjamin

Initial release. Yay!

REFERENCES
==========

* Compass:      http://compass-style.org/
* CoffeeScript: http://jashkenas.github.com/coffee-script/