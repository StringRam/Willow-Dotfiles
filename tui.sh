#┌──────────────────────────────  ──────────────────────────────┐
#                            TUI Stuff
#└──────────────────────────────  ──────────────────────────────┘


# ───────────────────────── Terminal helpers ─────────────────────────
if command -v tput >/dev/null 2>&1; then
  BOLD="$(tput bold)"; RESET="$(tput sgr0)"
  CYAN="$(tput setaf 6)"; GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"; RED="$(tput setaf 1)"
else
  BOLD=""; RESET=""; CYAN=""; GREEN=""; YELLOW=""; RED=""
fi

esc() { printf "\033[%s" "$1"; }         # raw ANSI
hide_cursor() { esc "?25l"; }
show_cursor() { esc "?25h"; }
move() { tput cup "$1" "$2"; }           # row col

term_cols() { tput cols; }
term_lines() { tput lines; }

# Guarda/restaura nivel printk (kernel -> consola)
PRINTK_OLD=""

silence_tty_noise() {
  [[ -w /proc/sys/kernel/printk ]] || return 0
  [[ -z "${PRINTK_OLD:-}" ]] && PRINTK_OLD="$(< /proc/sys/kernel/printk 2>/dev/null || true)"
  echo 0 > /proc/sys/kernel/printk 2>/dev/null || true
}

restore_tty_noise() {
  [[ -w /proc/sys/kernel/printk ]] || return 0
  if [[ -n "${PRINTK_OLD:-}" ]]; then
    printf '%s\n' "$PRINTK_OLD" > /proc/sys/kernel/printk 2>/dev/null || true
  else
    echo 4 > /proc/sys/kernel/printk 2>/dev/null || true
  fi
}

#Traslada el tui a pantalla alternativa
have_tty() { [[ -t 0 && -t 1 ]]; }

enter_alt() {
  have_tty || return 0
  silence_tty_noise
  tput smcup >/dev/null 2>&1 || return 0
}

exit_alt() {
  have_tty || return 0
  tput rmcup >/dev/null 2>&1 || return 0
  restore_tty_noise
}


# ───────────────────────── Drawing primitives ─────────────────────────
# draw_box top left height width title
draw_box() {
  local r="$1" c="$2" h="$3" w="$4" title="${5:-}"
  (( h >= 3 )) || return 0
  (( w >= 4 )) || return 0

  local top="┌$(printf '─%.0s' $(seq 1 $((w-2))))┐"
  local mid="│$(printf ' %.0s' $(seq 1 $((w-2))))│"
  local bot="└$(printf '─%.0s' $(seq 1 $((w-2))))┘"

  move "$r" "$c"; printf "%s" "$top"
  for i in $(seq 1 $((h-2))); do
    move $((r+i)) "$c"; printf "%s" "$mid"
  done
  move $((r+h-1)) "$c"; printf "%s" "$bot"

  if [[ -n "$title" ]]; then
    local t=" $title "
    local max=$((w-4))
    t="${t:0:$max}"
    move "$r" $((c+2))
    printf "%s" "$t"
  fi
}

strip_ansi() { sed -r 's/\x1B\[[0-9;?]*[A-Za-z]//g'; }

print_center() {
  local row="$1"; shift
  local text="$*"

  local cols; cols="$(term_cols)"
  local plain; plain="$(printf "%s" "$text" | strip_ansi)"
  local len=${#plain}

  local col=$(( (cols - len) / 2 ))
  (( col < 0 )) && col=0
  move "$row" "$col"
  printf "%s" "$text"
}

# print_in_box r c w text  (prints and clears remainder)
print_in_box() {
  local r="$1" c="$2" w="$3"; shift 3
  local text="$*"

  # recortar a w
  text="${text:0:$w}"

  # rellenar con espacios para sobrescribir lo viejo
  local pad=$(( w - ${#text} ))
  (( pad < 0 )) && pad=0

  move "$r" "$c"
  printf "%s%*s" "$text" "$pad" ""
}


repeat_char() {
  local n="$1" ch="$2"
  (( n <= 0 )) && { printf ""; return 0; }
  local s
  printf -v s '%*s' "$n" ''
  printf '%s' "${s// /$ch}"
}

# ───────────────────────── Screens ─────────────────────────

# ASCII Font: NScript
BANNER_ASCII=$' ,ggg,      gg      ,gg                                               ,gggggggggggg,                               \n'\
$'dP\"\"Y8a     88     ,8P       ,dPYb, ,dPYb,                           dP\"\"\"88\"\"\"\"\"\"Y8b,                I8             \n'\
$'Yb, `88     88     d8\'       IP\'`Yb IP\'`Yb                           Yb,  88       `8b,               I8             \n'\
$' `\"  88     88     88   gg   I8  8I I8  8I                            `\"  88        `8b            88888888          \n'\
$'     88     88     88   \"\"   I8  8\' I8  8\'                                88         Y8               I8             \n'\
$'     88     88     88   gg   I8 dP  I8 dP    ,ggggg,    gg    gg    gg    88         d8   ,ggggg,     I8      ,g,    \n'\
$'     88     88     88   88   I8dP   I8dP    dP\"  \"Y8ggg I8    I8    88bg  88        ,8P  dP\"  \"Y8ggg  I8     ,8\'8,   \n'\
$'     Y8    ,88,    8P   88   I8P    I8P    i8\'    ,8I   I8    I8    8I    88       ,8P\' i8\'    ,8I   ,I8,   ,8\'  Yb  \n'\
$'      Yb,,d8\"\"8b,,dP  _,88,_,d8b,_ ,d8b,_ ,d8,   ,d8\'  ,d8,  ,d8,  ,8I    88______,dP\' ,d8,   ,d8\'  ,d88b, ,8\'_   8) \n'\
$'       \"88\"    \"88\"   8P\"\"Y88P\'\"Y888P\'\"Y88P\"Y8888P\"    P\"\"Y88P\"\"Y88P\"    888888888P\"   P"Y8888P\"   88P\"\"Y88P\' \"YY8P8P\n'

render_splash() {
  hide_cursor

  local lines cols
  lines="$(term_lines)"
  cols="$(term_cols)"

  # count banner lines
  local banner_lines
  banner_lines=$(printf "%s" "$BANNER_ASCII" | wc -l | tr -d ' ')
  local banner_height=$banner_lines

  # find longest line length (rough centering)
  local maxlen=0
  while IFS= read -r line; do
    ((${#line} > maxlen)) && maxlen=${#line}
  done <<< "$BANNER_ASCII"

  local start_row=$(( (lines - banner_height) / 2 - 2 ))
  (( start_row < 0 )) && start_row=0
  local start_col=$(( (cols - maxlen) / 2 ))
  (( start_col < 0 )) && start_col=0

  local r="$start_row"
  while IFS= read -r line; do
    move "$r" "$start_col"
    printf "%s%s%s" "${BOLD}${GREEN}" "$line" "${RESET}"
    ((r++))
  done <<< "$BANNER_ASCII"

  local msg="Willow Dots — dotfiles manager & installer"
  print_center $((start_row + banner_height + 1)) "${BOLD}${GREEN}${msg}${RESET}"
  print_center $((start_row + banner_height + 3)) "${YELLOW}Press any key to continue...${RESET}"

  # wait key
  read -n1 -r -s || true
}

# ───────────────────────── App state ─────────────────────────
TAB=1
TABS=("Overview" "Logs")

PROGRESS=0              # 0..100
STAGE="Idle"
SPIN_IDX=0
SPIN_CHARS=("|" "/" "-" "\\")

declare -a LOG_BUF=()
LOG_SCROLL=0            # 0 = fondo (latest)
LOG_MAX=800

LEAF_ASCII=(
"      _-_      "
"   /~~   ~~\\   "
"  /~~       ~~\\ "
" {             }"
"  \\  _-   -_  / "
"    ~  \\\\//  ~  "
" _- -   || _- _ "
"   _ -  ||   -_ "
"       //\\\\     "
)

now_hms() { date +%H:%M:%S; }

log_add() {
  local msg="$*"
  local line="[$(now_hms)] $msg"
  LOG_BUF+=("$line")
  local n=${#LOG_BUF[@]}
  if (( n > LOG_MAX )); then
    LOG_BUF=("${LOG_BUF[@]:$((n-LOG_MAX))}")
  fi
  # si estamos pegados al final, mantenemos scroll=0
  (( LOG_SCROLL < 0 )) && LOG_SCROLL=0
}

# ───────────────────────── Layout helpers ─────────────────────────
clamp() {
  local v="$1" lo="$2" hi="$3"
  (( v < lo )) && v=$lo
  (( v > hi )) && v=$hi
  printf "%s" "$v"
}

# progress_bar width percent -> string
progress_bar() {
  local w="$1" p="$2"
  p="$(clamp "$p" 0 100)"
  local fill=$(( w * p / 100 ))
  local empty=$(( w - fill ))
  printf "%s%s" "$(repeat_char "$fill" "█")" "$(repeat_char "$empty" "░")"
}

# ───────────────────────── Rendering ─────────────────────────
render_tabs() {
  local cols lines
  cols="$(term_cols)"; lines="$(term_lines)"
  local h=3 w="$cols"

  draw_box 0 0 "$h" "$w" " Willow Dots"

  # contenido en la línea del medio
  local row=1
  local col=2
  local i=1
  for name in "${TABS[@]}"; do
    local label="[$i] $name"
    if (( i == TAB )); then
      label="${BOLD}${GREEN}${label}${RESET}"
    else
      label=" ${label} "
    fi
    move "$row" "$col"; printf "%s" "$label"
    col=$(( col + 12 + ${#name} ))
    ((i++))
  done

  # status a la derecha
  local spin="${SPIN_CHARS[$SPIN_IDX]}"
  local right=" ${spin} ${STAGE}  ${PROGRESS}% "
  local plain; plain="$(printf "%s" "$right" | strip_ansi)"
  local rcol=$(( cols - ${#plain} - 2 ))
  (( rcol < 2 )) && rcol=2
  move 1 "$rcol"; printf "%s" "${CYAN}${right}${RESET}"
}

render_help_in_main() {
  local main_r="$1" main_c="$2" main_h="$3" main_w="$4"
  local help_row=$(( main_r + main_h - 2 ))
  local help_col=$(( main_c + 2 ))
  local help_w=$(( main_w - 4 ))

  local hint="1-2: cambiar pestaña   ↑↓: scroll (Logs)   End: ir al final   Ctrl+C: cancelar"
  print_in_box "$help_row" "$help_col" "$help_w" "${YELLOW}${hint}${RESET}"
}

render_overview() {
  local r0="$1" c0="$2" h="$3" w="$4"
  local inner_r=$(( r0 + 1 ))
  local inner_c=$(( c0 + 1 ))
  local inner_h=$(( h - 2 ))
  local inner_w=$(( w - 2 ))

  # layout: izquierda hoja, derecha specs
  local left_w=$(( inner_w * 40 / 100 ))
  (( left_w < 18 )) && left_w=18
  local right_w=$(( inner_w - left_w - 1 ))
  (( right_w < 20 )) && right_w=20

  # hoja ASCII
  local lr=$(( inner_r + 1 ))
  local lc=$(( inner_c + 2 ))
  for i in "${!LEAF_ASCII[@]}"; do
    print_in_box $((lr+i)) "$lc" $((left_w-4)) "${GREEN}${LEAF_ASCII[$i]}${RESET}"
  done
  print_in_box $((lr+${#LEAF_ASCII[@]}+1)) "$lc" $((left_w-4)) "${BOLD}${GREEN}Willow Dots${RESET}"

  # specs (derecha)
  local sr=$(( inner_r + 1 ))
  local sc=$(( inner_c + left_w + 2 ))

  # recolecta rápida (sin hacer demasiado pesado el render)
  local os kernel host up cpu mem
  os="$(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-Unknown}")"
  kernel="$(uname -r 2>/dev/null)"
  host="$(hostname 2>/dev/null)"
  up="$(uptime -p 2>/dev/null | sed 's/^up //')"
  cpu="$(LC_ALL=C lscpu 2>/dev/null | awk -F: '/Model name/ {gsub(/^[ \t]+/,"",$2); print $2; exit}')"
  mem="$(free -h 2>/dev/null | awk '/Mem:/ {print $3 " / " $2}')"

  print_in_box $((sr+0)) "$sc" "$right_w" "${CYAN}OS:${RESET} $os"
  print_in_box $((sr+1)) "$sc" "$right_w" "${CYAN}Kernel:${RESET} $kernel"
  print_in_box $((sr+2)) "$sc" "$right_w" "${CYAN}Host:${RESET} $host"
  print_in_box $((sr+3)) "$sc" "$right_w" "${CYAN}Uptime:${RESET} ${up:-?}"
  print_in_box $((sr+4)) "$sc" "$right_w" "${CYAN}CPU:${RESET} ${cpu:-?}"
  print_in_box $((sr+5)) "$sc" "$right_w" "${CYAN}RAM:${RESET} ${mem:-?}"

  # progreso abajo (pero arriba de la help line)
  local pr_row=$(( r0 + h - 4 ))
  local bar_w=$(( w - 10 ))
  (( bar_w < 10 )) && bar_w=10
  local bar="$(progress_bar "$bar_w" "$PROGRESS")"
  local line=" ${BOLD}${GREEN}${PROGRESS}%${RESET}  $bar "
  print_in_box "$pr_row" $((c0+2)) $((w-4)) "$line"
}

render_logs() {
  local r0="$1" c0="$2" h="$3" w="$4"
  local inner_r=$(( r0 + 1 ))
  local inner_c=$(( c0 + 2 ))
  local inner_h=$(( h - 3 ))   # deja 1 línea para help dentro del box
  local inner_w=$(( w - 4 ))

  local total=${#LOG_BUF[@]}
  local visible=$inner_h
  (( visible < 1 )) && return 0

  # base index = final - visible - scroll
  local start=$(( total - visible - LOG_SCROLL ))
  (( start < 0 )) && start=0

  for ((i=0; i<visible; i++)); do
    local idx=$(( start + i ))
    local line=""
    (( idx < total )) && line="${LOG_BUF[$idx]}"
    print_in_box $((inner_r+i)) "$inner_c" "$inner_w" "$line"
  done

  # footer de logs (arriba de help)
  local footer_row=$(( r0 + h - 4 ))
  local info="Lines: $total   Scroll: $LOG_SCROLL"
  print_in_box "$footer_row" $((c0+2)) $((w-4)) "${CYAN}${info}${RESET}"
}

render_main() {
  local cols lines
  cols="$(term_cols)"; lines="$(term_lines)"

  local tab_h=3
  local main_r=$tab_h
  local main_c=0
  local main_h=$(( lines - tab_h ))
  local main_w="$cols"

  (( main_h < 6 )) && return 0

  draw_box "$main_r" "$main_c" "$main_h" "$main_w" " ${TABS[$((TAB-1))]}"

  # contenido según tab
  case "$TAB" in
    1) render_overview "$main_r" "$main_c" "$main_h" "$main_w" ;;
    2) render_logs     "$main_r" "$main_c" "$main_h" "$main_w" ;;
  esac

  render_help_in_main "$main_r" "$main_c" "$main_h" "$main_w"
}

render_all() {
  have_tty || return 0
  tput civis 2>/dev/null || true
  clear
  render_tabs
  render_main
}

# ───────────────────────── Input handling ─────────────────────────
handle_key() {
  local k="$1"

  case "$k" in
    "1") TAB=1 ;;
    "2") TAB=2 ;;
    $'\e')  # escape sequence (arrows, end)
      local k2 k3
      read -rsn2 -t 0.001 k2 || return 0
      case "$k2" in
        "[A") # up
          (( TAB == 2 )) && ((LOG_SCROLL+=1))
          ;;
        "[B") # down
          (( TAB == 2 )) && ((LOG_SCROLL-=1))
          ;;
        "[F") # End (algunos términos)
          (( TAB == 2 )) && LOG_SCROLL=0
          ;;
        "[H") # Home
          # optional: ir al inicio
          ;;
        "[1") # puede venir como ESC [1~ (Home) o ESC [4~ (End)
          read -rsn1 -t 0.001 k3 || true # normalmente '~'
          ;;
        "[4") # End: ESC [4~
          read -rsn1 -t 0.001 k3 || true
          (( TAB == 2 )) && LOG_SCROLL=0
          ;;
        "[5") # PgUp: ESC [5~
          read -rsn1 -t 0.001 k3 || true
          (( TAB == 2 )) && ((LOG_SCROLL+=5))
          ;;
        "[6") # PgDn: ESC [6~
          read -rsn1 -t 0.001 k3 || true
          (( TAB == 2 )) && ((LOG_SCROLL-=5))
          ;;
      esac
      ;;
  esac

  # clamp scroll
  local total=${#LOG_BUF[@]}
  local cols lines tab_h main_h inner_h
  cols="$(term_cols)"; lines="$(term_lines)"
  tab_h=3
  main_h=$(( lines - tab_h ))
  inner_h=$(( main_h - 3 ))
  local max_scroll=$(( total - inner_h ))
  (( max_scroll < 0 )) && max_scroll=0
  LOG_SCROLL="$(clamp "$LOG_SCROLL" 0 "$max_scroll")"
}

main_loop() {
  local tick=0
  while true; do
    # spinner
    SPIN_IDX=$(( (SPIN_IDX + 1) % 4 ))

    # demo: generar logs y progreso (para test)
    ((tick++))
    if (( tick % 8 == 0 )); then
      log_add "Applying step $((PROGRESS/10 + 1))..."
      STAGE="Applying dotfiles"
      PROGRESS=$(( PROGRESS + 1 ))
      (( PROGRESS > 100 )) && PROGRESS=100
      (( PROGRESS == 100 )) && STAGE="Done"
    fi

    render_all

    # input no bloqueante
    local k=""
    read -rsn1 -t 0.05 k && handle_key "$k"
  done
}

# ───────────────────────── Local test main ─────────────────────────
main() {
  enter_alt
  render_splash
  log_add "Willow Dots TUI booted"
  log_add "Press 1/2 to switch tabs"
  log_add "Use ↑↓ to scroll logs"
  STAGE="Starting"
  PROGRESS=0
  main_loop
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi


# ───────────────────────── Cleanup ─────────────────────────

cleanup() {
  show_cursor
  esc "0m"
  exit_alt 2>/dev/null || true
  have_tty && clear
}

# Para que el trap ERR se herede en funciones y subshells
set -o errtrace

trap cleanup EXIT INT TERM
trap 'show_cursor; esc "0m"; echo; echo "[ERR] line $LINENO: $BASH_COMMAND"; echo "status=$?"; read -n1 -r -s -p "Press a key..." || true' ERR