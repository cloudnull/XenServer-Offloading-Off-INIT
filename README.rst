XenServer Turning Off TCP Offloading 
####################################

If you are looking for a simple solution that can allow you to disable TCP offloading on a Hypervisor. This is an INIT script that will ensure that all offloading is off, even on subsequent reboots. Here are the highlights of this script.

* Disables Hardware offloading using the ethtool
* Has the ability to disable ALL of the off loading for the entire Host Server

--------

Making the script usable
========================

Once you have the application you simply have to run it. You can either make it executable or call bash before the script.

Making it executable :

.. code-block:: bash

  chmod +x offloadingoff-init.sh

Then move the script to the "init" script directory and add then add the script to all of the appropriate run levels. 

**Here is how this is done on a RHEL based install of the XenServer Hypervisor**

.. code-block:: bash

  cp offloadingoff-init.sh /etc/init.d/
  chkconfig offloadingoff-init.sh on 

**Here is how this is done on a Debian based install of the XenServer Hypervisor**

.. code-block:: bash

  cp offloadingoff-init.sh /etc/init.d/
  update-rc.d offloadingoff-init.sh defaults

Being that this is an INIT script you can always call it from the command line. The basic functions are :
  start | force-reload | restart

--------

Drop me a line if you have any questions. 


