#!/usr/bin/env python3
import os
import sys
import datetime
import subprocess
import re
import unicodedata
from itertools import zip_longest

# --- Configuration ---
OBSIDIAN_VAULT_NAME = "Obsidian"
OBSIDIAN_VAULT_PATH = "/home/user/Documents/Obsidian"
DAILY_NOTE_DIR = os.path.join(OBSIDIAN_VAULT_PATH, "02_Daily")
STATE_FILE_MD = os.path.join(OBSIDIAN_VAULT_PATH, "CurrentTask.md")
TASK_LIST_MD = os.path.join(OBSIDIAN_VAULT_PATH, "TaskList.md")
DATE_FORMAT = "%Y-%m-%d"

# --- Design ---
class Box:
    H = "─"          # Thin horizontal
    H_BOLD = "━"     # Bold horizontal
    V = "│"          # Vertical
    CROSS = "┼"      # Thin Cross
    T_DOWN_BOLD = "┯" # Bold Horizontal + Thin Vertical Down
    T_UP_BOLD = "┷"   # Bold Horizontal + Thin Vertical Up

# --- Utilities ---

def clear_screen():
    """Clears the terminal screen."""
    os.system('clear')

def get_char_width(c):
    return 2 if unicodedata.east_asian_width(c) in ('F', 'W', 'A') else 1

def get_str_width(s):
    return sum(get_char_width(c) for c in s)

def pad_str(s, width):
    current_width = get_str_width(s)
    padding_len = max(0, width - current_width)
    return s + " " * padding_len

def truncate_str(s, max_width):
    if get_str_width(s) <= max_width: return s
    res = ""; w = 0
    for c in s:
        cw = get_char_width(c)
        if w + cw > max_width - 2: return res + "..";
        res += c; w += cw
    return res

def safe_input(prompt_text, allow_quit=False):
    """
    入力を受け取る共通関数。
    allow_quit=True の場合のみ 'q' でアプリを終了する。
    それ以外（文字入力時）は 'q' をただの文字として扱う。
    """
    print(prompt_text, end="", flush=True)
    try:
        user_input = sys.stdin.readline()
        if not user_input: # Handle EOF (Ctrl+D)
            sys.exit(0)
        
        user_input = user_input.strip()
        
        if allow_quit and user_input.lower() == 'q':
            print("\nBye!")
            sys.exit(0)
            
        return user_input
    except KeyboardInterrupt:
        # 入力中に Ctrl+C が押されたら強制終了
        print("\nInterrupted.")
        sys.exit(0)

def wait_for_enter():
    print()
    safe_input("Press Enter to return to menu (or 'q' to quit)...", allow_quit=True)

# --- Basic Functions ---

def get_daily_note_path():
    today = datetime.datetime.now().strftime(DATE_FORMAT)
    return os.path.join(DAILY_NOTE_DIR, f"{today}.md")

def open_obsidian_daily():
    uri = f"obsidian://daily?vault={OBSIDIAN_VAULT_NAME}"
    subprocess.Popen(["xdg-open", uri], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def load_state():
    default_state = {"current_task": None, "start_time": None}
    if not os.path.exists(STATE_FILE_MD): return default_state
    state = default_state.copy()
    try:
        with open(STATE_FILE_MD, 'r') as f:
            for line in f:
                if line.strip().startswith("- **Task**:"):
                    state["current_task"] = line.split(":", 1)[1].strip()
                elif line.strip().startswith("- **Start**:"):
                    state["start_time"] = line.split(":", 1)[1].strip()
        if state["current_task"] == "None" or not state["current_task"]: return default_state
        return state
    except: return default_state

def save_state(task_name, start_time):
    display_time = datetime.datetime.fromisoformat(start_time).strftime("%H:%M") if start_time else "--:--"
    content = f"""# Current Task Status

- **Task**: {task_name if task_name else "None"}
- **Start**: {start_time if start_time else "None"}
- **Display**: {display_time}

---
"""
    with open(STATE_FILE_MD, 'w') as f: f.write(content)

def append_to_daily_note(text):
    path = get_daily_note_path()
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if not os.path.exists(path):
        with open(path, 'w') as f:
            f.write(f"# {datetime.datetime.now().strftime(DATE_FORMAT)}\n\n")
    with open(path, 'a') as f: f.write(text + "\n")

def stop_current_task(status="Done", comment=""):
    """
    Stops the current task.
    status="Done" -> Marks as [x] (Completed)
    status="Interrupted" -> Marks as [/] (Incomplete/Paused)
    comment: Optional comment to append as a nested list item.
    """
    state = load_state()
    if not state.get("current_task"): return None
    task_name = state["current_task"]
    start_dt = datetime.datetime.fromisoformat(state["start_time"])
    end_dt = datetime.datetime.now()
    
    # Obsidian Tasks / Markdown Checkbox convention
    mark = 'x' if status == 'Done' else '/'
    
    # ログ形式で追記
    log_text = f"- [{mark}] {start_dt.strftime('%H:%M')} - {end_dt.strftime('%H:%M')} : {task_name} ({status})"
    
    # コメントがある場合はインデントして追記
    if comment and comment.strip():
        log_text += f"\n    - {comment}"

    append_to_daily_note(log_text)
    save_state(None, None)
    return task_name

# --- Task List Management ---

def parse_deadline(task_str):
    # (Same as before)
    match = re.search(r'\[due::\s*(\d{4}-\d{1,2}-\d{1,2})\]', task_str)
    if match: return match.group(1)
    match_sch = re.search(r'\[scheduled::\s*(\d{4}-\d{1,2}-\d{1,2})\]', task_str)
    if match_sch: return match_sch.group(1)
    match_emoji = re.search(r'📅\s*(\d{4}-\d{1,2}-\d{1,2})', task_str)
    if match_emoji: return match_emoji.group(1)
    return "9999-99-99"

def parse_task_content(task_str):
    # (Same as before)
    due_match = re.search(r'\[due::\s*(\d{4}-\d{1,2}-\d{1,2})\]', task_str)
    deadline = due_match.group(1) if due_match else None
    if deadline:
        clean_name = task_str.replace(due_match.group(0), "").strip()
        clean_name = re.sub(r'\s+', ' ', clean_name)
    else:
        clean_name = task_str
    return deadline, clean_name

def format_task_for_display(task_str):
    # (Same as before)
    deadline, clean_name = parse_task_content(task_str)
    if deadline:
        return f"[{deadline}] {clean_name}"
    return clean_name

def load_tasks_categorized():
    # (Same as before)
    scheduled = []
    someday = []
    if not os.path.exists(TASK_LIST_MD): return scheduled, someday
    current_section = None
    with open(TASK_LIST_MD, 'r') as f:
        for line in f:
            line = line.strip()
            if "Scheduled" in line and line.startswith("##"): current_section = "scheduled"
            elif "Someday" in line and line.startswith("##"): current_section = "someday"
            elif line.startswith("- "):
                content = re.sub(r'^- \[[ x/]\] ', '', line)
                content = re.sub(r'^- ', '', content)
                content = content.strip()
                if not content: continue
                if current_section == "scheduled": scheduled.append(content)
                elif current_section == "someday": someday.append(content)
    scheduled.sort(key=lambda x: parse_deadline(x))
    return scheduled, someday

def save_tasks_categorized(scheduled, someday):
    # (Same as before)
    content = "# Task List\n\n## Scheduled\n"
    scheduled.sort(key=lambda x: parse_deadline(x))
    for t in scheduled: content += f"- [ ] {t}\n"
    content += "\n## Someday\n"
    for t in someday: content += f"- [ ] {t}\n"
    with open(TASK_LIST_MD, 'w') as f: f.write(content)

def get_task_by_index(idx, scheduled, someday):
    # (Same as before)
    n_scheduled = len(scheduled)
    if 1 <= idx <= n_scheduled:
        return scheduled, idx - 1
    elif n_scheduled < idx <= n_scheduled + len(someday):
        return someday, idx - 1 - n_scheduled
    return None, None

def input_deadline():
    # (Same as before)
    print(f"\n{Box.H*3} Set Deadline (Press Enter to skip/clear) {Box.H*10}")
    year = safe_input(" Year (YYYY): ")
    if not year: return None
    month = safe_input(" Month (MM): ")
    day = safe_input(" Day (DD): ")
    if not month or not day: return None
    date_str = f"{year}-{month.zfill(2)}-{day.zfill(2)}"
    return date_str

def input_comment():
    """Helper to input comment when stopping/interrupting."""
    print(f"\n{Box.H*3} Comment (Optional) {Box.H*10}")
    comment = safe_input(" > ")
    return comment

def print_task_table(scheduled, someday, border_idx):
    # (Same as before)
    s_lines = [f"{i+1}. {format_task_for_display(t)}" for i, t in enumerate(scheduled)]
    d_lines = [f"{i+1+border_idx}. {format_task_for_display(t)}" for i, t in enumerate(someday)]
    
    header_left = "Scheduled"
    header_right = "Someday"
    MAX_COL_WIDTH = 50
    SEP_STR = f" {Box.V} "
    
    left_content_max = get_str_width(header_left)
    for line in s_lines: left_content_max = max(left_content_max, get_str_width(line))
    left_w = min(left_content_max, MAX_COL_WIDTH)

    right_content_max = get_str_width(header_right)
    for line in d_lines: right_content_max = max(right_content_max, get_str_width(line))
    right_w = min(right_content_max, MAX_COL_WIDTH)

    top_line = (Box.H_BOLD * (left_w + 1)) + Box.T_DOWN_BOLD + (Box.H_BOLD * (right_w + 1))
    mid_line = (Box.H * (left_w + 1)) + Box.CROSS + (Box.H * (right_w + 1))
    bot_line = (Box.H_BOLD * (left_w + 1)) + Box.T_UP_BOLD + (Box.H_BOLD * (right_w + 1))

    print() 
    print(top_line)
    print(f"{pad_str(header_left, left_w)}{SEP_STR}{pad_str(header_right, right_w)}")
    print(mid_line)
    
    for left, right in zip_longest(s_lines, d_lines, fillvalue=""):
        left_disp = truncate_str(left, left_w)
        right_disp = truncate_str(right, right_w)
        print(f"{pad_str(left_disp, left_w)}{SEP_STR}{pad_str(right_disp, right_w)}")
    
    print(bot_line)

# --- Interactive Commands ---

def add_new_task_interactive():
    # (Same as before)
    print(f"\n{Box.H_BOLD*3} Create New Task {Box.H_BOLD*20}")
    print(f" Type: [1] Scheduled / [2] Someday")
    type_choice = safe_input("> ")
    if not type_choice: return

    is_scheduled = (type_choice == "1")
    
    task_name = safe_input(" Task Name: ")
    if not task_name: return 
    
    deadline = input_deadline()
    
    if deadline:
        final_task_str = f"{task_name} [due:: {deadline}]"
    else:
        final_task_str = task_name
    
    scheduled, someday = load_tasks_categorized()
    if is_scheduled: scheduled.append(final_task_str)
    else: someday.append(final_task_str)
    save_tasks_categorized(scheduled, someday)
    print(f"-> Added: {final_task_str}")

def edit_task_interactive():
    # (Same as before)
    scheduled, someday = load_tasks_categorized()
    border_idx = len(scheduled)
    print_task_table(scheduled, someday, border_idx)
    
    choice = safe_input(" Select number to edit: ")
    if not choice.isdigit(): return

    target_list, target_idx = get_task_by_index(int(choice), scheduled, someday)
    if target_list is None:
        print("Invalid number.")
        return

    original_task = target_list[target_idx]
    current_deadline, current_name = parse_task_content(original_task)

    print(f"\n{Box.H*3} Edit Task {Box.H*10}")
    print(f" Current Name: {current_name}")
    new_name = safe_input(" New Name (Enter to keep): ")
    if not new_name: new_name = current_name

    print(f" Current Deadline: {current_deadline if current_deadline else 'None'}")
    change_dl = safe_input(" Change Deadline? (y/n): ").lower()
    
    final_deadline = current_deadline
    if change_dl == 'y':
        final_deadline = input_deadline()
    
    new_task_str = new_name
    if final_deadline:
        new_task_str = new_task_str.strip() + f" [due:: {final_deadline}]"
    
    target_list[target_idx] = new_task_str
    save_tasks_categorized(scheduled, someday)
    print(f"-> Updated: {new_task_str}")

def remove_task_interactive():
    # (Same as before)
    scheduled, someday = load_tasks_categorized()
    border_idx = len(scheduled)
    print_task_table(scheduled, someday, border_idx)
    
    choice = safe_input(" Select number to remove: ")
    if not choice.isdigit(): return

    target_list, target_idx = get_task_by_index(int(choice), scheduled, someday)
    if target_list is None:
        print("Invalid number.")
        return
    
    task_to_remove = target_list[target_idx]
    confirm = safe_input(f" Delete '{task_to_remove}'? (y/n): ").lower()
    if confirm == 'y':
        target_list.pop(target_idx)
        save_tasks_categorized(scheduled, someday)
        print("-> Deleted.")
    else:
        print("-> Cancelled.")

def start_command(args):
    # Quick start via arguments
    if len(args) > 2:
        task_name = " ".join(args[2:])
        scheduled, someday = load_tasks_categorized()
        if task_name not in scheduled and task_name not in someday:
            someday.append(task_name)
            save_tasks_categorized(scheduled, someday)
        
        state = load_state()
        if state.get("current_task"): 
            # Note: Quick switch usually doesn't prompt for comment to keep it fast
            stop_current_task(status="Interrupted")
        
        save_state(task_name, datetime.datetime.now().isoformat())
        print(f"Started: {task_name}")
        return

    # Interactive start
    scheduled, someday = load_tasks_categorized()
    all_tasks = scheduled + someday
    border_idx = len(scheduled)

    print_task_table(scheduled, someday, border_idx)

    print(" Enter number / Enter task name / 'a' (Add)")
    choice = safe_input("> ")
    if not choice: return
    if choice.lower() == 'a':
        add_new_task_interactive()
        return

    task_name = ""
    if choice.isdigit():
        idx = int(choice) - 1
        if 0 <= idx < len(all_tasks):
            task_name = all_tasks[idx]
        else:
            print("Invalid number.")
            return
    else:
        task_name = choice
        someday.append(task_name)
        save_tasks_categorized(scheduled, someday)

    state = load_state()
    if state.get("current_task"):
        print(f"Interrupting: {state['current_task']}")
        stop_current_task(status="Interrupted")
    
    save_state(task_name, datetime.datetime.now().isoformat())
    print(f"Started: {task_name}")

def interrupt_command():
    state = load_state()
    if not state.get("current_task"):
        print("No active task.")
        return

    # コメント入力を求める
    comment = input_comment()
    stopped = stop_current_task(status="Interrupted", comment=comment)
    
    if stopped:
        print(f"Interrupted: {stopped}")

def list_command():
    scheduled, someday = load_tasks_categorized()
    border_idx = len(scheduled)
    print_task_table(scheduled, someday, border_idx)

def show_status():
    state = load_state()
    if state.get("current_task"):
        start_dt = datetime.datetime.fromisoformat(state['start_time'])
        print(f"Running: {state['current_task']} (since {start_dt.strftime('%H:%M')})")
    else:
        print("No active task.")

def interactive_main_menu():
    WIDTH = 40
    while True:
        try:
            clear_screen()
            
            print()
            print(Box.H_BOLD * WIDTH)
            print(" Task Manager Menu")
            print(Box.H * WIDTH)
            print(" 1. Start Task (List & Select)")
            print(" 2. Add Task")
            print(" 3. Edit Task")
            print(" 4. Remove Task")
            print(" 5. Stop Current Task (Done)")
            print(" 6. Show Status")
            print(" 7. List Tasks (View only)")
            print(" 8. Interrupt Task (Pause)")
            print(" q. Quit")
            print(Box.H_BOLD * WIDTH)

            raw_choice = safe_input("> ", allow_quit=True).strip()
            choice = raw_choice.lower()

            clear_screen()

            if choice in ['1', 'start']:
                start_command(['tm', 'start'])
                wait_for_enter()
            elif choice in ['2', 'add']:
                add_new_task_interactive()
                wait_for_enter()
            elif choice in ['3', 'edit']:
                edit_task_interactive()
                wait_for_enter()
            elif choice in ['4', 'remove', 'rm', 'delete']:
                remove_task_interactive()
                wait_for_enter()
            elif choice in ['5', 'stop']:
                state = load_state()
                if state.get("current_task"):
                    # コメント入力を求める
                    comment = input_comment()
                    stopped = stop_current_task(status="Done", comment=comment)
                    if stopped:
                        print(f"Completed: {stopped}")
                        open_obsidian_daily()
                else:
                    print("No active task.")
                wait_for_enter()
            elif choice in ['6', 'status', 'show']:
                show_status()
                wait_for_enter()
            elif choice in ['7', 'list', 'ls']:
                list_command()
                wait_for_enter()
            elif choice in ['8', 'interrupt', 'pause']:
                state = load_state()
                if state.get("current_task"):
                    # コメント入力を求める
                    comment = input_comment()
                    stopped = stop_current_task(status="Interrupted", comment=comment)
                    print(f"Interrupted: {stopped}")
                else:
                    print("No active task.")
                wait_for_enter()
            else:
                if not choice: continue
                print(f"Invalid choice: {raw_choice}")
                wait_for_enter()
                
        except KeyboardInterrupt:
            print("\nBye!")
            sys.exit(0)

def main():
    if len(sys.argv) < 2:
        interactive_main_menu()
        return

    command = sys.argv[1]

    if command == "start": start_command(sys.argv)
    elif command == "add": add_new_task_interactive()
    elif command == "edit": edit_task_interactive()
    elif command == "remove" or command == "rm": remove_task_interactive()
    elif command == "list": list_command()
    elif command == "stop":
        state = load_state()
        if state.get("current_task"):
            # CLI引数実行時もコメントを聞く
            comment = input_comment()
            stopped = stop_current_task(status="Done", comment=comment)
            if stopped:
                print(f"Completed: {stopped}")
                open_obsidian_daily()
        else: print("No active task.")
    elif command in ["interrupt", "pause"]:
        interrupt_command()
    elif command == "status": show_status()
    else: print(f"Unknown command: {command}")

if __name__ == "__main__":
    main()
