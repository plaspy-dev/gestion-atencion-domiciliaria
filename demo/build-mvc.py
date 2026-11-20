"""Compile the recovered MVC C# sources from an isolated Git export."""

from argparse import ArgumentParser
from hashlib import sha256
from io import BytesIO
import json
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory
from urllib.error import HTTPError
from urllib.request import urlopen
from zipfile import ZipFile


PACKAGES = 'https://api.nuget.org/v3-flatcontainer'
EDITION_MANIFEST = Path(__file__).with_name('mvc-packages.json')


def official_package(name, version, digest):
    try:
        with urlopen(f'{PACKAGES}/{name}/{version}/{name}.{version}.nupkg', timeout=60) as response:
            raw = response.read()
    except HTTPError as error:
        raise RuntimeError(f'NuGet returned HTTP {error.code} for {name} {version}.') from None
    if sha256(raw).hexdigest() != digest:
        raise RuntimeError(f'The official package {name} {version} did not match its pinned SHA-256.')
    return ZipFile(BytesIO(raw))


def unpack(archive, destination, prefix=''):
    for item in archive.infolist():
        if item.is_dir() or not item.filename.startswith(prefix):
            continue
        target = (destination / item.filename.removeprefix(prefix)).resolve()
        if not target.is_relative_to(destination.resolve()):
            raise ValueError('Unexpected package member path.')
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(archive.read(item))


def msbuild(tool, project, references, output, operation, framework):
    output.mkdir(parents=True, exist_ok=True)
    subprocess.run([
        tool, project, '/nologo', '/m:1', '/nr:false', f'/t:{operation}',
        '/p:Configuration=Release', '/p:UseSharedCompilation=false',
        '/p:BuildProjectReferences=false', f'/p:TargetFrameworkVersion={framework}',
        f'/p:TargetFrameworkRootPath={references}\\',
        f'/p:OutDir={output / "bin"}\\', f'/p:IntermediateOutputPath={output / "obj"}\\',
    ], cwd=project.parent, check=True)


def build(msbuild_tool, source, scratch, edition, manifest):
    downloads = scratch / 'references'
    project = source / edition
    for name, version, digest, placements in manifest['packages']:
        with official_package(name, version, digest) as archive:
            for placement in placements:
                kind, data = placement
                if kind == 'framework':
                    unpack(archive, downloads, 'build/')
                if kind == 'project':
                    unpack(archive, source / data)
                if kind == 'assembly':
                    target = project / 'Bin' / Path(data).name
                    target.parent.mkdir(parents=True, exist_ok=True)
                    target.write_bytes(archive.read(data))
    own = source / 'vendor/componentes-web/Componentes.csproj'
    msbuild(msbuild_tool, own, downloads, scratch / 'componentes', 'Build', 'v4.5')
    dependency = scratch / 'componentes/bin/SDG.Componentes.dll'
    (project / 'Bin').mkdir(parents=True, exist_ok=True)
    (project / 'Bin/SDG.Componentes.dll').write_bytes(dependency.read_bytes())
    current, = sorted(project.glob('*.csproj'))
    destination = scratch / 'edition'
    msbuild(msbuild_tool, current, downloads, destination, 'Compile', 'v4.6')
    output = list((destination / 'obj').glob('*.dll'))
    if not output:
        raise RuntimeError('MSBuild did not produce an MVC assembly.')
    print(f'{edition}: C# source compilation passed. Web packaging is a separate step.', flush=True)


def main():
    manifest = json.loads(EDITION_MANIFEST.read_text(encoding='utf-8'))
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--edition', choices=manifest['editions'], action='append')
    parser.add_argument('--msbuild', default='MSBuild.exe')
    args = parser.parse_args()
    repo = Path(__file__).resolve().parents[1]
    for edition in args.edition or manifest['editions']:
        with TemporaryDirectory(prefix='home-care-mvc-build-') as temporary:
            scratch = Path(temporary)
            version = subprocess.check_output(['git','-C',repo,'rev-parse','HEAD']).decode().strip()
            archive = scratch / 'edition.zip'
            subprocess.run(['git','-C',repo,'archive','-o',archive,'--format=zip',version],check=True)
            source = scratch / 'source'
            with ZipFile(archive) as packed:
                unpack(packed, source)
            print(f'SHA {version}', flush=True)
            build(args.msbuild, source, scratch, edition, manifest)


if __name__ == '__main__':
    main()
