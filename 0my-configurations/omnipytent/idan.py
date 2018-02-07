from __future__ import absolute_import

from omnipytent.integration.plumbum import local
from omnipytent.ext.erroneous import ERUN


python2 = local['python2']
python3 = local['python3']
cargo = local['cargo']
dub = local['dub']
gradle = local['gradle']['-q']


def zip_vim_plugin(plugin_name):
    import re

    def version_numbers():
        pattern = re.compile(r'^v?(\d+\.)\d+')
        for tag in local['git']['tag']().splitlines():
            if pattern.match(tag):
                yield tuple(map(int, tag.strip('v').split('.')))

    version_number = '.'.join(map(str, sorted(version_numbers())[-1]))
    zip_command = local['zip']['%s_v%s.zip' % (plugin_name, version_number)]
    zip_command = zip_command[local['git']['ls-files']().splitlines()]
    return zip_command
