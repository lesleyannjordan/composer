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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �/Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq�)�$p�������Ӝ��dk;�վ�S{;�^.�Z�?�#�'��v��^N�z/��˟�	��xM��)����!�K%��f�_�S\.�,�+������W\������O���/�$�����q�2.�?I�t%�2p_����˰3]�?�GSq'��B�c����$]��Oj�#��?����ʽ������]��]�<�l�%l���(M�Iظ�E����OS$����Q����O�7�g��
?G�?��xQ��$�X�����/5��������ؐ՚�}P��	���S�4]h�(�H��&��I����V���l5�M[�Ta&��~ʧ1�<�j���@.6�&h!�S�J�MJO��<�Mt��h�C����@O�{<e��t�����24H���ֶޗ�.��P�Ȗ(z9�����tj��
/=���ѿ)~i��^4]�~���cx��GaT��W
>J�wWǷ׉=��+�=����'�J�����uC�d�P���_������� �9ʚ���d���̐�Ys)n[D� m.W�����4̸PѲ�5K05�!�-sp��@"�)m�2{8޺�X�8T8���u�IY�!kH��:s�� ���"�s����� �D��P59�|�[�G���;�#F�`��"(�r�,D1�`�E��W�i�%���-�(�i*;� t�\sh�su�4���6�P�I308繆`yS��F���c�[q ~�,]̅��/��O����xk��X��?�&��B�7�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��r��sM<�<��ީ������B���J�υ%(��}��t9^eu�Ș��6|#;��a��l�E�$m.o4F�t�4W���%�(‗5����e�Ob`���1f��:���a�����w�\��$mIm45Q�u�!�%�H�X4�9����l���̆g������6�@������|���?�^��)�ch�V�_^�qV�����#ü�ީ��.Yo	$��-����9ǉP�1�%�
��Q�N����٩pP��*�*Hv�Vp?�+3�>M�� ��,,LCѕ�&�,�`w�8b�N��(��K���s԰�D�/['RS�w�йY��f�Ǧ�{E��bn5o;�p��;P �{�-C���O�e虻l�S�r!<QuhM���ãr����)gF���Y ���@��O��8^���X{x�gB��Z���C]��;����6%�|�H�9��A�A�9lQ��Qt�f��LH��5>�8�hQ�y��k�_
r���M��X����sS��gr]K���m3�>�P�0Y����O�K�ߵ������IV���C��3���{��.�D��%���+�����\{����c/��x[��%�f�Oe���*�������O��$�^@�lqu�"���a��a���]sY��(?pQ2@1g=ҫ��.�!�W����P]�e������qG��V�4��e��,��h\�o����b��Z6�`۶�17�ij��ɗ޲���f�V_r̹�4p�N�#ڃ967�hk�� ����V��(A��f)�Ӱ��y/~i�f�O�_
>J��CT��T���_��W���K�f�O�������(�#�*���-�gz����C��!|��l����:�f��w�бY��{�Ǧ��|h ���N����p\�� ��I��!&��{SinM�	����0w�s��t��$��P�s��m6�7�y�ֻ� 
�4%
��<.&�R��;Y�c���'Zט#m�G��lp�H:����9:'�8���c� N��9`H΁ ҳm��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2hBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K��3�Ȋ��������(���RP����_���=�f����>�r�G���Rp��_��q1��*�/�W�_������C�J=��HA���2p	�{�M:x�������Юoh�a8�zn��(°J",�8, �Ϣ4K��]E��~(C����!4�U�_� �Oe®ȯV+U���؜����=�i�m����?��)���H�	�S����;����^����=��n�c�Vi�ہ�8"��	�y� ���`�ʇ7y��)%�v�Y��n<��q�������D��_� ���<��?Tu�w9�P���/S
��'�j������A��˗����q���_>R�/m�X�8�!���R�;��`8�|�']����O��,�Ѕ��bD�b�cۤ��K�.F!�K�,f{X�������L8��2��VE���_���#�������?]D��� �D4L^L�ݠ�nci�x�s�X鮑&����V�p�e���+�au]��S��0"7�3�`��(�|�G�|F�T��Nc�[����&���k��3[��ލ���/m}��GP��W
~�%�������W>i�?Ⱦ4Z�B�(C���(A>��&����R�Z�W���������]���X��a���ǳ�>�Y@���g�ݏ��{P����]P�z�F��=tw��ρnX�΁���~�9�Ѓ��6��2q�p��N�}1/�.���G��&1]���&�����k��4�Gx,�3��gr�CMf=Q'���7G����Q[x+.�K����Dӭ3�YO>�#ܖ�Q�2��8��n�u_;ms.���k ��ݚ�r.k)ZV�y:E��ڔ�9��t��nw�cC��B�w{�C ����䶷�<����à�bM p"�r65�y{WW\����Vd���Fg9�,3�V�֟��A��߃ j�;%6�NГr�&{+~f��ni���p�5��!��x����/m�����_
~���+��o�����Vn�o�2�����l�'q	���������6���z��ps'���B�ó�ч���7���3C��o�<���� o�2|�z����k����&>q[��'�A@�H���PwSR������ؚ���ms�ѷl���D��!�5S9v-Mhҩl�$��ԺN�t-�\9N�j�x�<��o?�l�C�����}�@�,4GN�F��Y�ͻ�����2�g�d5���ן��v�^�=�K�^����w:��M!��#Z�������g�?�G��������Gh���+���O>�������Ϙ����?e��=���������G��_��W��������N�����0����rp��/��.��*�W�_*������?�����B�?[�����\���G�4�a(�R�C�,�2��`���h��.��>J8d��T��>B�.�8�W���V(C���?:������Rp����Lɖ�þeN�6;}�!Bs�m�me�E��#mѢ&/��1ќ��J;�����(���)�G�  �mow���c�o]�5�Oaz���z8#P�249�P�7�+u�Ŧ=4����^������Qg��>Z|�=~>��b�?=��@����J��O�B�����A��n���}�j5�F��Zm١��6�'~�𽰘����S�ʵ���"��k�����>}�_n�i�����\I�vU� ���n�]E��k�a�W�v���I����u��.�����Ҋ��K�k-�Ԯ��_O�Ż�])��Պ`��k����yh�:����e�|��y�+�v�`���7���]y�.�ƋM�?�k��Sݾ��)n�{���K?�Y�Q1*\��2�(pk+܎����r_V��.[]]uQ�i�����MG��
A��o�������k_�+���
ߎ�}��$w~0������<��0��}�kgQ�ٗ��AG��d�[����ͫ�Yނ(K��+0:���o��X<���^~�c�[&-����֋{����8C~Z�����ͷ�֦w������������3�X��W[ ����ߩ�y�Χ��ƛ�_kp���0N���R���ƹ.T���#��k���O4a���"D~��j��Ծ���}�������,n{����S�+��X�"��wu�oY廂x#�D~`����݁�=Z �˪����N7��dS)���ʪ�m����0<��5��S8�,�%u�=��O��b�S���=�*�������u���p�\υˡ��2f��{�t]�ҡ"]�n;]�ukO׵ۺ���;1AM�	&����?1�OJ�F��|P	4bD!&������l;g�p� ���=�����������{�'�1F69_�)7�2�Bz.�L��H
�FÃ�xA�H2���.%ӑx׭mY;&�:���"�/��e8������[h90���Xti1 ��f��O�9��-mB�W�ń�E>�h���*K�����������pM4'�F��~� 4��2i�aXW�@������8X�1�Ȓ�mE�uS�F�ޱJ�3v��qa�zxN�CI���Mf�#�m![H�)Z��O���^��U�#��!����	G����f�\We�ДF�#!2�R���A�a�e����;��Cn��/��
��vI�Э�Y^�M��h�|��t��o�t�M�)r8]ZȆSN���98�������t�1�Ӏ9��-Z����� vr��"�A�;�ʢѾsa�����1�Z�1u�c]�t����$�J�8R���[���u�p8�^�x��*/�	]F�F:7wF?g����+�ѽ^�ԚbTaFw��A�E]�Q4_�����E�O�0�g�����!��a���|�X�.�"��5J��A����5���5'Tku�?#4'3y9��~jϹ�c=S��JF�U�t���(���sA����{p�!���wҼhs0�1'�[G,dȌ���k���z����{�3��V����s��T�w��j�
�]]��C�עK�]��څ,o������道S��^UM���٧<4�7�":�Wv������,l���������5&��~�A�����?�~���C��vb�����~��W;��T���H��wy\� �� `�m/�������<`��m_���o� Ώp��r���������g~��c�V3�=��o�_~�k����W(�v+�x��~�׌�����w��^�s�G��U��3�o���87s��' 59cS��xS��~rS�#0��)n^�gq�������"���\���zt��K�x�<a6����� ��a���6���e�z�����`#G$7C�6�%�n�3�,�Q��!�n�_��[��!��L��P;e��k`�4��Wɝ.��i2_�Q,S�׃�~N6s��x� �8�ws��[�&�<��tw@?�Q�R��p����O�Y:8�.�cJt��'d�>��5�B(���J���*
.2!�ʞZ=��QB�Qʋr˩jK�	I�����	m���2Ų��z)5��I��^
Qx�K�����O�LX�	k3aWa�BO���!a�}6<�����֦���蚝�R3��=`����nUCLpl-��)و�[�]�d ����D`����2���ׯl�L��ITh�[��@kpGBI1&�w8��H�0�ᐕd�&���)�i�A��#ky�<��{�gd��
��D6ar��[E<��*�uвBP��Z�����/�d����ka(FIs�N��{�]��n&�uz;/rA�f�]���w�w_Y�Ǥ,K6`�Q�-wf3��Y.�};�J�`8�N3����=-���b��"�~%�c�TKlR�B�]l��P��2���6u8e���kE����B�
(��}Lϴ�Ԝ����]�,QՃ�|�>��IB��1�U`�@N�0�ՉD�'o�"���2V�9�NTA��-$�R�H͏�L9�+T�n_,!���B��{�,�E��_�,�������D�X�g(ߪpy�$�~	J hb�N
����m0/�W�<��C�a\�孝\;1���l�����0�h�	��%,&kRl���(� �0)W:S�dNY���.U&�	{�>��m�j�O%U��� K���Z�`	!��&�t��`�͆����d_k�\���>O����lRd�d�p{��N��OY���f�l�϶�϶q
7~���Z�W5�#й�+�h:��=�v����Wi������C��}��:tf�����U�y�r��6���6'!v�ӆn��W����f���*o~J�R�@7A7�p��6.I�̍;�M�(��浶Z3�jh��TU�z��:Zv���:t
��dI�D��Z�5�ڐ�n�N����~9�����Nkp�Bg֮�����	K��!hP �T��-�n��ׅ��n����a�d��2����:�s��i\Q��U��y�e����~�yh�Z�(���3rBg W����G��cd�+~k@�qyy{zk��������`嗂�|t�LZ�-�P�J+�@��ny��s
Ǿ𠥎�H[�h,:Ύ梃Ѡd=΃�"Xu��Ҟ'�8ꂃ�V�Әn֔A�{b��0c	>nzh��;CjSj�W����R��2�p���%�!ъ#��P� 9��
�"Bpd�)�Ѽ��&�tR�J�zq�и�T���*u<F�	�#�#A!m��11���Gv���5I�� �Q�7��w����J1���H��0�K����>�H������RPQ�ٰi�.Ε��5�0������>Ջ	���n���T׺��) �ԡ���L.մb/��}��i�m�q�Ǻv�����t��)�������i�����ݡ�:U�z�U`��xX�=,��[�O���޿���,�I��D�V}�d��#l��$�rW�$�c^v��)�����}X̠�`)*�q��g�"��8jPd�*0
�L7kʲ��������l0�Q�JS�N\�Ai�$S8"�S��\�	�(��|��0��J��!�r{:�,w�������RJB�����!{c!����XQ�n�a��v9L���R�oG=;�A)ʓC��D��FP^�˗v���e��>*߯z�TO�r�PF\p�I T?�Ì��+[r����kbbK����,�k�z)�v�I�U��Haߥ�W��l㰍���8���g#~+9e�C;e3%V}��[!̶q�j��Bl����Xk	�����Ռ��GO7L���#�x����k��� ����Z�������$�z�&Ak�T&������4*w��Q�&���$t��rs/����#�}s����F藿��S����/������8t��k���{�w��lZ8Q���8���z��������˒�s����Ƀt��7N���_�n<�@���y�__|���?=�^<߉?�u�J��~erEO�ym4��V�6��o�?�'?����n���󯁗����Г��x���HA��v���ޜ�v�jS;mj�M��i6M��v�_q��_q퀴����6�Ӧv�>��������[^F>�C�*W����Y�=�rAl�נ�B'��zl��c&�N�����/�C�MQ^�l�����<�S��)����a�{�38G����Af���צ��,��93v�՞3cO���sfl㰍�2̙9�|�#L��3s.w���Ui��.y�ɜ��/�h\1�g';��Nvzߦ��&-  