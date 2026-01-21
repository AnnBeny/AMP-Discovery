#!/usr/bin/env bash
set -euo pipefail
:"${JAVA_LD_LIBRARY_PATH:=}"

# --- Nastavení ---
# Cesta k *.nf souboru (ve WSL formátu /mnt/c/…)
PIPELINE_DIR="/mnt/c/Users/User/kamila/WORKFLOWS/AMP/src/project/xsvato01/amp-nextflow_nf"
# Cesta k jave
export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.462.b08-3.0.1.el9.x86_64/jre"
export PATH="$JAVA_HOME/bin:$PATH"
# Konfigurační soubor (relativně)
CONFIG_FILE="/mnt/c/Users/User/kamila/WORKFLOWS/AMP/src/nextflow.config"
# Jméno conda prostředí
CONDA_ENV_NAME="nextflow"

# --- Rychlé volby pro offline provoz ---
export NXF_DISABLE_CHECK_LATEST=true        # Nextflow nekontroluje novou verzi
export NXF_ANSI_LOG=false                   # čitelnější log v souborech

# --- Funkce pro hezčí chyby ---
die() { echo "ERROR: $*" >&2; exit 1; }

# --- Ověření, že *.nf existuje ---
[[ -e "$PIPELINE_DIR" ]] || die "Nenalezena pipeline: $PIPELINE_DIR"

# --- Java musí být dostupná ---
command -v java >/dev/null 2>&1 || die "Java není v PATH (wsl)."

# --- Zkusit aktivovat conda/mamba ---
if [[ -n "$CONDA_ENV_NAME" ]]; then
  for CSH in \
    "$HOME/miniconda3/etc/profile.d/conda.sh" \
    "$HOME/anaconda3/etc/profile.d/conda.sh" \
    "/opt/conda/etc/profile.d/conda.sh"
  do
    if [[ -f "$CSH" ]]; then
    { source "$CSH"; conda activate "$CONDA_ENV_NAME" && break; }
    fi
  done
fi

# --- Najít nextflow: buď v conda env, nebo na obvyklých místech ---
find_nextflow() {
  command -v nextflow 2>/dev/null && return 0
  for NX in "$HOME/.local/bin/nextflow" "/usr/local/bin/nextflow" "/usr/bin/nextflow"; do
    [[-x "$NX"]] && { echo "$NX"; return 0; }
  done
  return 1
}

NXF_BIN="$(find_nextflow || true)"
[[ -n "${NXF_BIN:-}" ]] || die "Nextflow není dostupný. 
- Online instalace (ve WSL):  curl -s https://get.nextflow.io | bash && mv nextflow ~/.local/bin && chmod +x ~/.local/bin/nextflow
- Offline: zkopíruj soubor 'nextflow' do ~/.local/bin a dej chmod +x; přidej ~/.local/bin do PATH."

echo "[INFO] Použiju nextflow: $NXF_BIN"
exec "$NXF_BIN" run "$PIPELINE_DIR" -c "$CONFIG_FILE" -resume

