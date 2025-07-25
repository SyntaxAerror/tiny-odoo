import { reactive } from "@odoo/owl";

// Part of Odoo. See LICENSE file for full copyright and licensing details.
// This file was modified by SyntaxError on 250527.
// Changes: Removed user-facing references to Odoo and replaced with generic references to "the system" as applicable.

import { browser } from "@web/core/browser/browser";
import {
    isAndroidApp,
    isDisplayStandalone,
    isIOS,
    isIosApp,
} from "@web/core/browser/feature_detection";
import { _t } from "@web/core/l10n/translation";
import { registry } from "@web/core/registry";

async function getIosPwaPermission() {
    if (browser.location.protocol !== "https:") {
        return "denied";
    }
    const registration = await browser.navigator.serviceWorker?.getRegistration();
    return (await registration?.pushManager.permissionState()) ?? "prompt";
}

export const notificationPermissionService = {
    dependencies: ["notification"],

    _normalizePermission(permission) {
        switch (permission) {
            case "default":
                return "prompt";
            case undefined:
                return "denied";
            default:
                return permission;
        }
    },

    /**
     * @param {import("@web/env").OdooEnv} env
     * @param {Partial<import("services").Services>} services
     */
    async start(env, services) {
        const notification = services.notification;
        let permission;
        try {
            if (isIOS() && isDisplayStandalone()) {
                permission = { state: await getIosPwaPermission() };
            } else if (isIOS()) {
                permission = { state: "denied" };
            } else {
                permission = await browser.navigator?.permissions?.query({
                    name: "notifications",
                });
            }
        } catch {
            // noop
        }
        const state = reactive({
            /** @type {"prompt" | "granted" | "denied"} */
            permission:
                isIosApp() || isAndroidApp()
                    ? "denied"
                    : this._normalizePermission(
                          permission?.state ?? browser.Notification?.permission
                      ),
            requestPermission: async () => {
                if (browser.Notification && state.permission === "prompt") {
                    state.permission = this._normalizePermission(
                        await browser.Notification.requestPermission()
                    );
                    if (state.permission === "denied") {
                        notification.add(_t("The system will not send notifications on this device."), {
                            type: "warning",
                            title: _t("Notifications blocked"),
                        });
                    } else if (state.permission === "granted") {
                        notification.add(_t("The system will send notifications on this device!"), {
                            type: "success",
                            title: _t("Notifications allowed"),
                        });
                    }
                }
            },
        });
        if (permission && !isIOS()) {
            permission.addEventListener("change", () => (state.permission = permission.state));
        }
        return state;
    },
};

registry.category("services").add("mail.notification.permission", notificationPermissionService);
