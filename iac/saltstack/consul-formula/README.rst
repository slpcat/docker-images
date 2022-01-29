======
consul
======

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``consul``
------------

Installs and configures the Consul service.

``consul.install``
------------------

Downloads and installs the Consul binary file.

``consul.config``
-----------------

Provision the Consul configuration files and sources.

``consul.service``
------------------

Adds the Consul service startup configuration or script to an operating system.

To start a service during Salt run and enable it at boot time, you need to set following Pillar:

.. code:: yaml

    consul:
      service: True

``consul-template``
-------------------

Installs and configures Consul template.

.. vim: fenc=utf-8 spell spl=en cc=100 tw=99 fo=want sts=4 sw=4 et
