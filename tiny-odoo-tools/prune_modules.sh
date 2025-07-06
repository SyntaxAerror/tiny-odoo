#! /bin/bash

cd ./addons
addons_to_preserve=(
    "auth"
    "auth*"
    "analytic"
    "base"
    "base_address_extended"
    "base_automation"
    "base_geolocalize"
    "base_import"
    "base_import_module"
    "base_install_request"
    "base_setup"
    "base_sparse_field"
    "bus"
    # "certificate" # OEEL-1
    "contacts"
    "data_recycle"
    "digest"
    "gamification"
    "google_recaptcha"
    "hr_work_entry"
    "hr_work_entry_contract"
    "html_editor"
    "http_routing"
    "im_livechat"
    "link_tracker"
    "mail"
    "mail_bot"
    "mail_group"
    "phone_validation"
    "portal"
    "privacy_lookup"
    "project"
    "project_todo"
    "rating"
    "resource"
    "resource_mail"
    "social_media"
    "spreadsheet"
    "spreadsheet_dashboard"
    "spreadsheet_dashboard_im_livechat"
    "test_base_automation"
    "test_html_field_history"
    "test_import_export"
    "test_mail"
    "test_mail_full"
    "test_spreadsheet"
    "test_website"
    "test_website_modules"
    "theme_default"
    "uom"
    "utm"
    "web"
    "web_editor"
    "web_hierarchy"
    "web_tour"
    "website"
    "website_blog"
    "website_forum"
    "website_google_map"
    "website_jitsi"
    "website_links"
    "website_livechat"
    "website_mail"
    "website_mail_group"
    "website_partner"
    "website_profile"
    "website_project"
    "website_twitter"
)
for dir in ./*; do
    if [ -d "$dir" ]; then
        preserve=0
        for pattern in "${addons_to_preserve[@]}"; do
            if [[ $(basename "$dir") == $pattern ]]; then
                preserve=1
                break
            fi
        done
        if [ $preserve -eq 0 ]; then
            git rm -rf "$dir"
        fi
    fi
done

cd ./..