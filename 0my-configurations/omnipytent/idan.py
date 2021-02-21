from __future__ import absolute_import

from omnipytent import task
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


@task.options_multi
def cargo_tests(ctx):
    ctx.key(str)
    import re
    pattern = re.compile(r'^(.*): test$', re.MULTILINE)

    for match in pattern.finditer(cargo['test']['--', '--list']()):
        if '.rs -  (line ' in match.group(1):
            continue
        yield match.group(1)


@task.options
def cargo_example(ctx):
    ctx.key(str)
    if ctx.allow_main:
        ctx.key(lambda value: value or 'No example - use main')
        yield None
    import json
    metadata = json.loads(cargo['metadata']())
    wm_members = {wm.split(' ')[0] for wm in metadata['workspace_members']}
    for package in metadata['packages']:
        if package['name'] not in wm_members:
            continue
        for target in package['targets']:
            if 'example' in target['kind']:
                yield target['name']
cargo_example.allow_main = False


@task
def cargo_fmt_check(ctx):
    import re

    from plumbum import ProcessExecutionError

    from omnipytent.util import populate_quickfix

    header_pattern = re.compile(r'^Diff in (.+) at line (\d+):$')

    with populate_quickfix() as qf:
        try:
            for line, _ in cargo['fmt', '--all', '--', '--check', '--color', 'never'].popen():
                if line is None:
                    continue
                m = header_pattern.match(line)
                if m:
                    print(line)
                    filename, lnum = m.groups()
                    qf(filename=filename, lnum=lnum)
                else:
                    qf(text=line)
        except ProcessExecutionError as e:
            if e.retcode != 1:
                raise


def get_gradle_deps(configuration='runtime'):
    import re

    cmd = gradle['dependencies']
    if configuration:
        cmd = cmd['--configuration', configuration]
    data = cmd()

    deps_root = local.path('~/.gradle/caches/modules-2/files-2.1/')
    for m in re.finditer(r'--- ([^: ]+):([^: ]+):([^: \n]+)$', data, re.MULTILINE):
        group, name, version = m.groups()
        dep_root = deps_root / group / name/ version
        for jar in  dep_root.walk(lambda p: p.suffix == '.jar'):
            yield jar


@task.options
def cargo_manifest(ctx):
    ctx.key(str)
    ctx.value('{}/Cargo.toml'.format)
    import toml
    workspace_members = toml.load('Cargo.toml')['workspace']['members']
    for member in workspace_members:
        yield member
