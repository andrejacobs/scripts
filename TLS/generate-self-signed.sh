#!/bin/bash
# Generate self-signed certificates
# André Jacobs
# Based on previous scripts, stack overflow and the references metioned below

# This script will create inside the ./certs directory the following files
# rootCA.crt: A new root CA cert if it doesn't exist
# rootCA.key: A signing key for the root CA if the rootCA.crt above was created
# <DOMAIN_OR_IP>.crt (server certificate) & .key (private key) & .conf (config files used to generate the certs)

# NOTES:
# Depending on what you want to use this for (and the answer better be: only for secured own internal services)
# you might need to add "subject alternative name" and other bits for browser to even consider it

# macOS NOTES:
# I ran into issues with the default macOS OpenSSL. So decided to install a more sane one using homebrew
# brew install openssl && brew link openssl
# echo 'export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"' >> ~/.zshrc

# References:
# https://devopscube.com/create-self-signed-certificates-openssl/
# https://stackoverflow.com/questions/10175812/how-to-generate-a-self-signed-ssl-certificate-using-openssl

if [ "$#" -ne 1 ]; then
    >&2 echo "Error: Please provide the domain name or IP of the server."
    echo "Usage: <DOMAIN_OR_IP>"
    exit 1
fi

set -eu
# Uncomment to debug commands
# set -o xtrace

SERVER_DOMAIN=$1
BITS=4096
DAYS=365

# Country code
CONF_C="GB"
# State or province
CONF_ST="Surrey"
# Locality or city
CONF_L="London"
# Organisation
CONF_O="Awesome Inc"
# Organisation unit
CONF_OU="R&D"
CONF_CN="${SERVER_DOMAIN}"


# Check if openssl is installed
if ! command -v openssl &> /dev/null
then
    echo "Please install openssl."
    exit 1
fi

pushd . &> /dev/null
mkdir -p certs
cd certs

if ! [ -f rootCA.crt ]; then
    # Create a new root CA and private key
    # NOTE: To inspect the certificate use: openssl x509 -in rootCA.crt -text
    echo "-----------------------------------------------------------"
    echo "Creating new rootCA at: certs/rootCA.crt (key: rootCA.key)"
    echo "-----------------------------------------------------------"
    echo ""
    openssl req -x509 \
                -days ${DAYS} \
                -nodes \
                -sha512 \
                -newkey rsa:${BITS} \
                -subj "/CN=${CONF_CN}/C=${CONF_C}/L=${CONF_L}/ST=${CONF_ST}/O=${CONF_O}/OU=${CONF_OU}" \
                -keyout rootCA.key -out rootCA.crt
    #           -addext "subjectAltName=DNS:example.com,DNS:www.example.net,IP:10.0.0.1" \


    # Create a new private key for the domain
    echo ""
    echo "-----------------------------------------------------------"
    echo "Creating new private key for the domain at: certs/${SERVER_DOMAIN}.key"
    echo "-----------------------------------------------------------"
    echo ""
    openssl genrsa -out "${SERVER_DOMAIN}.key" ${BITS}
else
    echo "-----------------------------------------------------------"
    echo "rootCA.crt already exists. No new one will be generated"
    echo "-----------------------------------------------------------"
    echo ""
fi

# Create config file used for the CSR
echo ""
echo "-----------------------------------------------------------"
echo "Creating new CSR config file at: certs/${SERVER_DOMAIN}.csr.conf"
echo "-----------------------------------------------------------"
cat > "${SERVER_DOMAIN}.csr.conf" <<EOF
[ req ]
default_bits = ${BITS}
prompt = no
default_md = sha512
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = ${CONF_C}
ST = ${CONF_ST}
L = ${CONF_L}
O = ${CONF_O}
OU = ${CONF_OU}
CN = ${CONF_CN}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ${SERVER_DOMAIN}
#DNS.2 = www.${SERVER_DOMAIN}
#IP.1 = 192.168.1.1 
#IP.2 = 192.168.1.2

EOF

echo ""
echo "-----------------------------------------------------------"
echo "Creating new CSR at: certs/${SERVER_DOMAIN}.csr"
echo "-----------------------------------------------------------"
# Create a new CSR (Certificate Signing Request)
openssl req -new \
            -key "${SERVER_DOMAIN}.key" \
            -out "${SERVER_DOMAIN}.csr" \
            -config "${SERVER_DOMAIN}.csr.conf"

echo ""
echo "-----------------------------------------------------------"
echo "Creating new certificate config at: certs/${SERVER_DOMAIN}.crt.conf"
echo "-----------------------------------------------------------"
# Create config file used to create the server certificate
cat > ${SERVER_DOMAIN}.crt.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${SERVER_DOMAIN}

EOF

echo ""
echo "-----------------------------------------------------------"
echo "Creating new server certificate at: certs/${SERVER_DOMAIN}.crt"
echo "-----------------------------------------------------------"
# Create the new server certificate
openssl x509 -req \
             -in "${SERVER_DOMAIN}.csr" \
             -CA rootCA.crt \
             -CAkey rootCA.key \
             -CAcreateserial -out "${SERVER_DOMAIN}.crt" \
             -days ${DAYS} \
             -sha512 \
             -extfile "${SERVER_DOMAIN}.crt.conf"

echo ""
echo "-----------------------------------------------------------"
echo "Done!"
echo "-----------------------------------------------------------"

popd &> /dev/null
