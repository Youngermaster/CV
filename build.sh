#!/usr/bin/env bash
#
# Build a CV folder with XeLaTeX inside Docker (no local TeX needed).
#
# Usage:
#   ./build.sh                                  # builds the default Halter folder
#   ./build.sh 2026/<Company>/<Role>            # builds any other CV folder
#
# It builds the image once (cached afterwards) and compiles cv.tex + coverletter.tex,
# writing the PDFs back into the target folder via a bind mount.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-2026/Halter/Senior-Software-Engineer}"
IMAGE="cv-latex"

TARGET_DIR="${REPO_ROOT}/${TARGET}"
if [[ ! -d "${TARGET_DIR}" ]]; then
  echo "Error: target folder not found: ${TARGET_DIR}" >&2
  exit 1
fi

echo ">> Building image '${IMAGE}' (cached after first run)..."
docker build -t "${IMAGE}" "${REPO_ROOT}"

echo ">> Compiling CV in: ${TARGET}"
docker run --rm -v "${TARGET_DIR}":/project "${IMAGE}"

echo ">> Done. PDFs written to: ${TARGET_DIR}"
ls -1 "${TARGET_DIR}"/*.pdf 2>/dev/null || true
