#!/usr/bin/env bash

clear

echo -ne "\e[32mLOADING FILE MANAGEMENT SYSTEM\e[0m"
for i in {1..5}; do
    echo -n "."
    sleep 0.3
done
echo ""

history_log="$HOME/file_manager_history.log"

# ---------- HISTORY LOGGER ----------
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$history_log"
}

echo "----------------------------------------------------------"
echo -e "\e[32mCurrent files:\e[0m"
ls
echo "----------------------------------------------------------"

show=0

while true; do

    if (( show == 0 )); then
        echo -e "\e[36m================= MAIN MENU =================\e[0m"
        echo "0. Show menu"
        echo "1. Change folder"
        echo "2. Previous folder"
        echo "3. Show files"
        echo "4. Create file/folder"
        echo "5. Delete file/folder"
        echo "6. Rename file"
        echo "7. Move file"
        echo "8. Copy file"
        echo "9. Show history"
        echo "10. Clear history"
        echo "99. Exit"
        echo "============================================="
        show=1
    fi

    read -p "Enter option: " option

    case $option in

        0)
            show=0
            ;;

        1)
            read -p "Enter path: " path
            if cd "$path" 2>/dev/null; then
                echo "Changed to: $(pwd)"
                log_action "Changed directory -> $(pwd)"
            else
                echo "Invalid path!"
                log_action "FAILED change directory -> $path"
            fi
            ;;

        2)
            if cd ..; then
                echo "Current path: $(pwd)"
                log_action "Moved to parent directory -> $(pwd)"
            else
                log_action "FAILED moving to parent directory"
            fi
            ;;

        3)
            echo "Files in $(pwd):"
            ls
            log_action "Viewed files in $(pwd)"
            ;;

        4)
            read -p $'1. Folder\n2. File\nChoose: ' op

            if (( op == 1 )); then
                read -p "Folder name: " name
                if mkdir "$name" 2>/dev/null; then
                    echo "Folder created."
                    log_action "Created folder -> $name"
                else
                    echo "Failed to create folder."
                    log_action "FAILED folder creation -> $name"
                fi

            elif (( op == 2 )); then
                read -p "File name: " file
                read -p "Extension (.txt/.sh/.py/.c): " ext
                filename="$file$ext"

                case $ext in
                    .sh)
                        echo "#!/usr/bin/env bash" > "$filename"
                        chmod +x "$filename"
                        ;;
                    .py)
                        echo "print('Hello World')" > "$filename"
                        ;;
                    .c)
                        cat <<EOF > "$filename"
#include <stdio.h>
int main() {
    printf("Hello World");
    return 0;
}
EOF
                        ;;
                    *)
                        touch "$filename"
                        ;;
                esac

                echo "File created: $filename"
                log_action "Created file -> $filename"
            else
                echo "Invalid option"
            fi
            ;;

        5)
            read -p "Enter file/folder to delete: " name
            if [[ -e "$name" ]]; then
                rm -ri "$name"
                log_action "Deleted -> $name"
            else
                echo "Not found!"
                log_action "FAILED delete -> $name (not found)"
            fi
            ;;

        6)
            read -p "Enter current name: " old
            read -p "Enter new name: " new
            if mv "$old" "$new" 2>/dev/null; then
                echo "Renamed successfully"
                log_action "Renamed $old -> $new"
            else
                echo "Rename failed"
                log_action "FAILED rename -> $old"
            fi
            ;;

        7)
            read -p "Enter file to move: " file
            read -p "Enter destination path: " path
            if mv "$file" "$path" 2>/dev/null; then
                echo "Moved successfully"
                log_action "Moved $file -> $path"
            else
                echo "Move failed"
                log_action "FAILED move -> $file"
            fi
            ;;

        8)
            read -p "Enter file to copy: " file
            read -p "Enter destination path: " path
            if cp -i "$file" "$path" 2>/dev/null; then
                echo "Copied successfully"
                log_action "Copied $file -> $path"
            else
                echo "Copy failed"
                log_action "FAILED copy -> $file"
            fi
            ;;

        9)
            echo "=========== ACTION HISTORY ==========="
            if [[ -f "$history_log" ]]; then
                cat "$history_log"
            else
                echo "No history found."
            fi
            ;;

        10)
            > "$history_log"
            echo "History cleared."
            log_action "History cleared"
            ;;

        99)
            echo "Exiting..."
            log_action "Program exited"
            exit 0
            ;;

        *)
            echo -e "\e[31mInvalid option!\e[0m"
            ;;
    esac
done