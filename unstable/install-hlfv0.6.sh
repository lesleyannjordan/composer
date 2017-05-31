(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �/Y �[o�0�yx�@B(�21��K�AI`�S��&�Ҳ��}v� !a]�j�$�$r9�o���c��"M;�� B��������u�]���w�$IBM�DQ�	]�SĮ(vk@x�P�$Ql j1�R�ֽ��OI�p�ˠީ�E���F�|������fo `�Z#l�!".rֈ���v3�|�꙽nSh�Zb3$(��1$�^&�	���2�42�SL�C~|M��j���Á9�?8\+pԏI�2m[��9-����Z�!B�M�
,Z�Q���&mf�m�I�Y�Pՠ9�P3��u}�0�4��8�u/\Ni"Fsu23�����v��Z�M��d۹�[q���Ǔ��T�*��^�+>?�i�*���
�Y��\�YO荷���F�p��&�]��$��(t]1�b���#}ՠџ>ޅ��}K��]�?���m�.�6�i�F�"����u�v��/�n��lUœOTtwN����K�]k�&A�;�-}%\	2�4�����b+x�N�N�8Tg7��>� ��?P��GvL��9	��\PP��}١%�������9?V8(�	�'����p�)���q1�f.;�vi�z�L������g�&ȡY���'�eq�C}w�.4�M�&�Mw�Q×'`�T9v ��(�q�&�J�T����_,8K�$%���D�s����P�\b�Tp��pVȯ	y����'�[?�ճ�ӿ�_�p8���p8���p8���p8�o�VMSo (  