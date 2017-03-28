"""Set aside only the pages requiring unavailable controls in a local build copy."""

from argparse import ArgumentParser
from hashlib import sha256
import json
from pathlib import Path, PurePosixPath


def main():
    parser=ArgumentParser(description=__doc__)
    parser.add_argument('site', type=Path)
    args=parser.parse_args()
    root=Path(__file__).resolve().parents[1]
    site=args.site.resolve()
    if site==root or site.is_relative_to(root) or root.is_relative_to(site):
        parser.error('Provide the separate site directory created by the build recipe.')
    if not (site/'Web.config').is_file():
        parser.error('The temporary Web Forms site was not found.')
    excluded=json.loads(Path(__file__).with_name('missing-controls.json').read_text(encoding='utf-8'))
    inspected=[]
    for name,digest in excluded.items():
        path=PurePosixPath(name)
        if path.is_absolute() or '..' in path.parts or ':' in name or '\\' in name:
            raise ValueError(f'Invalid site path {name}')
        file=(site/path).resolve()
        if not file.is_relative_to(site):
            raise ValueError(f'Site path escapes the build copy: {name}')
        contents=file.read_bytes().replace(b'\r\n',b'\n')
        if sha256(contents).hexdigest()!=digest:
            raise RuntimeError(f'The staged file differs from the checked historical source: {name}')
        inspected.append(file)
    for file in inspected:
        file.unlink()
    print(f'The Web Forms build set aside {len(inspected)} tracked files that require unavailable controls.')


if __name__=='__main__':
    main()
