#!/usr/bin/env python3
import sys
import os
import time
import json

STATE_FILE = "/tmp/pomo_state.json"
WORK_TIME = 25 * 60  # 25 minutos en segundos
BREAK_TIME = 5 * 60  # 5 minutos en segundos

def get_default_state():
    return {"remaining": WORK_TIME, "running": False, "last_tick": 0, "phase": "work"}

def load_state():
    if not os.path.exists(STATE_FILE):
        return get_default_state()
    try:
        with open(STATE_FILE, "r") as f:
            state = json.load(f)
            # Migración por si el estado guardado es de la versión anterior
            if "phase" not in state:
                state["phase"] = "work"
            return state
    except:
        return get_default_state()

def save_state(state):
    with open(STATE_FILE, "w") as f:
        json.dump(state, f)

def update_time(state):
    if state["running"]:
        now = int(time.time())
        elapsed = now - state["last_tick"]
        if elapsed > 0:
            state["remaining"] = max(0, state["remaining"] - elapsed)
            state["last_tick"] = now
            
            # Lógica de transición de fases al llegar a cero
            if state["remaining"] == 0:
                state["running"] = False
                
                if state["phase"] == "work":
                    os.system("notify-send -t 0 'Pomodoro' 'work time over'")
                    state["phase"] = "break"
                    state["remaining"] = BREAK_TIME
                else:
                    os.system("notify-send -t 0 'Pomodoro' 'time off over'")
                    state["phase"] = "work"
                    state["remaining"] = WORK_TIME
    return state

def main():
    state = load_state()
    state = update_time(state)
    
    cmd = sys.argv[1] if len(sys.argv) > 1 else "show"
    
    if cmd == "toggle":
        state["running"] = not state["running"]
        if state["running"]:
            state["last_tick"] = int(time.time())
        save_state(state)
        
    elif cmd == "reset":
        state = get_default_state()
        save_state(state)
        
    elif cmd == "show":
        save_state(state)
        mins, secs = divmod(state["remaining"], 60)
        
        # Indicadores visuales limpios en la barra
        status = ""
        if not state["running"]:
            if state["phase"] == "work" and state["remaining"] < WORK_TIME:
                status = "[P] "
            elif state["phase"] == "break":
                status = "[BREAK] "
                
        print(f"{status}{mins:02d}:{secs:02d}")

if __name__ == "__main__":
    main()
