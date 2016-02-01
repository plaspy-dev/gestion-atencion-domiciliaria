"""Build the recovered shared Web Forms library with its pinned packages."""

from argparse import ArgumentParser
from hashlib import sha256
from io import BytesIO
import json
import os
from pathlib import Path
import shutil
import subprocess
from urllib.error import HTTPError
from urllib.request import urlopen
from zipfile import ZipFile


PACKAGES = 'https://api.nuget.org/v3-flatcontainer'
MANIFEST = Path(__file__).with_name('componentes-packages.json')


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


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--output', required=True, type=Path)
    parser.add_argument('--msbuild')
    args = parser.parse_args()
    destination = args.output.resolve()
    checkout = Path(__file__).resolve().parents[1]
    if destination.exists() or destination.is_relative_to(checkout):
        parser.error('Choose a new output directory outside the checkout.')
    source = destination / 'source'
    library = source / 'vendor/componentes'
    shutil.copytree(checkout / 'vendor/componentes', library)
    references = destination / 'references'
    for name, version, digest, placements in json.loads(MANIFEST.read_text(encoding='utf-8')):
        with official_package(name, version, digest) as package:
            for kind, data in placements:
                if kind == 'framework':
                    unpack(package, references, 'build/')
                elif kind == 'project' and data.startswith('vendor/packages/'):
                    unpack(package, source / data)
    project, = library.glob('*.csproj')
    tool = args.msbuild or shutil.which('MSBuild.exe')
    if not tool:
        vswhere = Path(os.environ['ProgramFiles(x86)']) / 'Microsoft Visual Studio/Installer/vswhere.exe'
        if vswhere.is_file():
            relative = str(Path('MSBuild/Current/Bin/amd64/MSBuild.exe'))
            tools = subprocess.check_output([vswhere, '-latest', '-products', '*', '-requires',
                'Microsoft.Component.MSBuild', '-find', relative], text=True)
            tool = next((path.strip() for path in tools.splitlines() if Path(path.strip()).is_file()), None)
    if not tool:
        parser.error('Install Visual Studio MSBuild or supply its path with --msbuild.')
    msbuild(tool, project, references, destination, 'Build', 'v4.5')
    if not (destination / 'bin/SDG.Componentes.dll').is_file():
        raise RuntimeError('MSBuild did not produce the shared library.')


if __name__ == '__main__':
    main()
