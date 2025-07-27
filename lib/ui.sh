#!/bin/bash

# User Interface and menu system for Coze Studio management
# 用户界面和菜单系统

# Main menu function
show_main_menu() {
    while true; do
        clear
        msg "main_menu"
        read -r choice
        
        case "$choice" in
            1)
                clear
                install_coze_studio
                ;;
            2)
                clear
                add_model
                ;;
            3)
                clear
                restart_coze_studio
                ;;
            4)
                clear
                stop_coze_studio
                ;;
            5)
                clear
                remove_coze_studio
                ;;
            6)
                clear
                setup_domain
                ;;
            0)
                clear
                msg "goodbye"
                exit 0
                ;;
            *)
                echo
                msg "invalid_option"
                echo
                wait_for_continue
                ;;
        esac
    done
}