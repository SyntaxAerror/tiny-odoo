#! /bin/bash

install_sys_deps=0
clean_build=0
# update_odoo=0
drop_db=0
no_init=0
distro="fedora"
while getopts "s:cnd" flag
do
    case "${flag}" in
        c) clean_build=1;;
        # o) update_odoo=1;;
        d) drop_db=1;;
        n) no_init=1;;
        s) install_sys_deps=1
            if [ "$OPTARG" = "fedora" ]; then
                echo "Setting up for Fedora"
                distro="fedora"
            elif [ "$OPTARG" = "debian" ]; then
                echo "Setting up for Debian"
                distro="debian"
            elif [ "$OPTARG" = "rpi" ]; then
                echo "Setting up for Raspberry Pi"
                distro="rpi"
            else
                echo "Unsupported argument. Defaulting to Fedora Setup"
                distro="fedora"
            fi
        ;;
    esac
done


# Install system requirements if they are not already installed
if [ $install_sys_deps -eq 1 ]; then
    if [ $distro == "fedora" ]; then
        packages=("postgresql-server" "postgresql-contrib" "libpq-devel" "python3-devel" "openldap-devel")
    elif [ $distro == "debian" ]; then
        packages=("postgres" "libpq-dev" "python-dev" "libldap-dev")
    elif [ $distro == "rpi" ]; then
        packages=("postgres" "libpq-dev" "python3-dev" "python-ldap" "libldap-dev")
    else
        echo "Unknown distribution. Please use the -s flag to specify 'fedora', 'debian', or 'rpi'."
    fi
    if [ ! -z "$distro" ]; then
        for package in "${packages[@]}"; do
            if ! rpm -q $package &>/dev/null; then
                echo "$package is not installed. Installing..."
                if [ $distro == "fedora" ]; then
                    sudo dnf install -y $package # dnf
                elif [ $distro == "debian" ] || [ $distro == "rpi" ]; then
                    sudo apt-get install -y $package # apt-get
                fi
            fi
        done
    else
        echo "No distribution specified. Please use the -s flag to specify 'fedora', 'debian', or 'rpi'."
    fi
fi


# if [ $update_odoo -eq 1 ]; then

#     git clone --branch 18.0 --depth 1 --single-branch https://github.com/odoo/odoo ./odoo-source

#     git remote add upstream https://github.com/odoo/odoo.git
#     git fetch --depth=1 upstream 18.0

# fi


# Check if PostgreSQL is set up and set it up if not
pgsql_data_exists=0
if [ -e "/var/lib/pgsql/data" ] || [ ! -z "$(sudo ls -A /var/lib/pgsql/data 2>/dev/null)" ]; then
    pgsql_data_exists=1
fi
if [ $pgsql_data_exists -eq 0 ]; then
    echo "Initializing PostgreSQL..."
    sudo postgresql-setup --initdb --unit postgresql
else
    echo "PostgreSQL already initialized."
fi

# Check if PostgreSQL is running and start it if not
if ! systemctl is-active --quiet postgresql; then
    echo "Starting PostgreSQL..."
    sudo systemctl start postgresql
fi

db_exists=0
if [ ! -z "$(sudo -u postgres psql -lqt | grep -o odoo)" ]; then
    db_exists=1
fi
user_exists=0
if [ ! -z "$(sudo -u postgres psql -c '\du' | grep -Po '(?<!Super)user')" ]; then
    user_exists=1
fi

sys_uname=$(whoami)
if [ $pgsql_data_exists -eq 1 ]; then
    if [ $db_exists -eq 1 ] && ([ $clean_build -eq 1 ] || [ $drop_db -eq 1 ]); then
        echo "Dropping database 'odoo'..."
        sudo -u postgres dropdb odoo
        db_exists=0
    fi
    if [ $user_exists -eq 1 ] && [ $clean_build -eq 1 ]; then
        echo "Dropping user..."
        sudo -u postgres dropuser "$sys_uname"
        user_exists=0
    fi
fi

if [ $user_exists -eq 0 ]; then
    echo "Creating PostgreSQL user..."
    if [ "$sys_uname" = "user" ]; then
        sudo -u postgres createuser "user" --pwprompt
    else
        sudo -u postgres createuser "$sys_uname" --pwprompt
    fi
else
    echo "PostgreSQL user already exists."
fi
if [ $db_exists -eq 0 ]; then
    echo "Creating PostgreSQL database 'odoo'..."
    sudo -u postgres createdb --owner="$sys_uname" odoo
else
    echo "PostgreSQL database 'odoo' already exists."
fi


# Create a Python virtual environment if it doesn't exist or if the -c flag is set
if [ -d "./.venv" ] && [ $clean_build -eq 1 ]; then
    echo "Clean Build: Removing existing Python virtual environment..."
    rm -rf ./.venv
fi
if [ ! -d "./.venv" ]; then
    echo "Creating new Python virtual environment..."
    python3 -m venv ./.venv
    source ./.venv/bin/activate
    echo "Installing requirements..."
    pip install --upgrade pip
    if [ $distro == "rpi" ]; then
        pip install -r requirements.rpi.txt
    else
        pip install -r requirements.txt
    fi
    deactivate
else
    echo "Python virtual environment already exists."
fi


# Initialize the database if the -n flag is not set
if [ $no_init -eq 0 ]; then
    echo "Initializing database..."
    source ./.venv/bin/activate
    ./odoo-bin --without-demo --addons-path="addons/" -d "odoo" --init=base --stop-after-init
    deactivate
    echo "To start odoo, use:"
    echo "./start.sh"
else
    echo "Skipping database initialization."
    echo "To start odoo, use:"
    echo "./start.sh -i"
fi

