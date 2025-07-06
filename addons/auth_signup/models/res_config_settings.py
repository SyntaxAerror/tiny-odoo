# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.
# This file was modified by SyntaxError on 250707.
# Changes: Added email disabled message field.
from odoo import fields, models


class ResConfigSettings(models.TransientModel):
    _inherit = 'res.config.settings'

    auth_signup_reset_password = fields.Boolean(
        string='Enable password reset from Login page',
        config_parameter='auth_signup.reset_password')
    auth_signup_reset_password_email_disabled_message = fields.Text(
        string='Message to show users when no email servers are available',
        config_parameter='auth_signup.reset_password_email_disabled_message'
        default="Please Note: Our email services are currently unavailable. As such, we may be unable to send you your password reset link.")
    auth_signup_uninvited = fields.Selection(
        selection=[
            ('b2b', 'On invitation'),
            ('b2c', 'Free sign up'),
        ],
        string='Customer Account',
        default='b2c',
        config_parameter='auth_signup.invitation_scope')
    auth_signup_template_user_id = fields.Many2one(
        'res.users',
        string='Template user for new users created through signup',
        config_parameter='base.template_portal_user_id')
