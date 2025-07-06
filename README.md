# tiny-odoo

## Description

TinyOdoo (or tiny-odoo) (name is a work-in-progress and therefore subject to change) is an in-development project that aims to create a stripped-down version of Odoo Community Edition to be used more like a web development framework than an ERP.

## Setup

### First Time Setup:

Use `/tiny-odoo-tools/setup.sh -cod -s [fedora|debian|rpi]` to get started.

### Quick Rebuild:

Use `/tiny-odoo-tools/setup.sh -c` to rebuild the `/.venv` and the database.

### Drop DB:

Use `/setup.sh -d` to drop and re-initialize the database used by tiny-odoo.

## Licensing & Copyright

This explanation of this project's licensing and copyright (below) is intended solely as an explanation. The official licensing and copyright details can be found in the `/LICENSE` and `/COPYRIGHT` files in the root directory `/` of this project.


This project contains a modified copy of Odoo Community Edition. The original Odoo Community Edition License and Copyright Notice can be found as `/LICENSE.odoo` and `/COPYRIGHT.odoo` respectively.

Per the LGPLv3 that Odoo Community Edition is licensed under, modifications will "carry prominent notices" of the modification and "a relevant date" for that modification.  
These notices will usually take the form of a comment near the top of the file that inclues who made the modification, when the modification was made, and a brief description of what was modified. When such a comment is impractical or impossible, the notice will be contained in its own dedicated `COPYRIGHT` file (or `COPYRIGHT.additional` file as applicable) in (or as close as possible to) the same directory.  
These modifications are covered by the LGPLv3, per section 5c of the GNU GENERAL PUBLIC LICENSE (GPLv3) included in the LGPLv3 (`/LICENSE`).

The Copyright Notice for the modifications as well as the License and Copyright Notice for software that is not a part of Odoo Community Edition can be found in the root directory of this project `/`, as `/LICENSE` and `/COPYRIGHT` respectively.  
Any parts of the project that are not a part of Odoo Community Edition and have Licensing/Copyright differences from the licensing found in `/LICENSE` and/or the copyright notice(s) in `/COPYRIGHT`, will have dedicated `LICENSE` and/or `COPYRIGHT` file(s) in the relevant directory.
