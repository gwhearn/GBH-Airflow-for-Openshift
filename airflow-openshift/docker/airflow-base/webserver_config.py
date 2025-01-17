"""Default configuration for the Airflow webserver"""
import os

from airflow.www.security import AirflowSecurityManager
from flask_appbuilder.security.manager import AUTH_DB

# The SQLAlchemy connection string
SQLALCHEMY_DATABASE_URI = os.getenv('AIRFLOW__CORE__SQL_ALCHEMY_CONN', 'sqlite:////opt/airflow/airflow.db')

# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = True

# ----------------------------------------------------
# AUTHENTICATION CONFIG
# ----------------------------------------------------
# For details on how to set up each of the following authentication, see
# http://flask-appbuilder.readthedocs.io/en/latest/security.html

# The authentication type
AUTH_TYPE = AUTH_DB

# Uncomment to setup Full admin role name
AUTH_ROLE_ADMIN = 'Admin'

# Uncomment to setup Public role name, no authentication needed
AUTH_ROLE_PUBLIC = 'Public'

# Will allow user self registration
AUTH_USER_REGISTRATION = False

# The recaptcha it's automatically enabled for user self registration is active and the keys are None
RECAPTCHA_PRIVATE_KEY = os.getenv('AIRFLOW__WEBSERVER__RECAPTCHA_PRIVATE_KEY', None)
RECAPTCHA_PUBLIC_KEY = os.getenv('AIRFLOW__WEBSERVER__RECAPTCHA_PUBLIC_KEY', None)

# Config for Flask-Mail necessary for user self registration
MAIL_SERVER = os.getenv('AIRFLOW__SMTP__SMTP_HOST', 'localhost')
MAIL_USE_TLS = os.getenv('AIRFLOW__SMTP__SMTP_STARTTLS', True)
MAIL_USE_SSL = os.getenv('AIRFLOW__SMTP__SMTP_SSL', False)
MAIL_PORT = int(os.getenv('AIRFLOW__SMTP__SMTP_PORT', 25))
MAIL_USERNAME = os.getenv('AIRFLOW__SMTP__SMTP_USER', None)
MAIL_PASSWORD = os.getenv('AIRFLOW__SMTP__SMTP_PASSWORD', None)
MAIL_DEFAULT_SENDER = os.getenv('AIRFLOW__SMTP__SMTP_MAIL_FROM', 'airflow@example.com')

# The default user self registration role
AUTH_USER_REGISTRATION_ROLE = "Public"

# When using OAuth Auth, uncomment to setup provider(s) info
# Google OAuth example:
# OAUTH_PROVIDERS = [{
#   'name':'google',
#     'token_key':'access_token',
#     'icon':'fa-google',
#         'remote_app': {
#             'api_base_url':'https://www.googleapis.com/oauth2/v2/',
#             'client_kwargs':{
#                 'scope': 'email profile'
#             },
#             'access_token_url':'https://accounts.google.com/o/oauth2/token',
#             'authorize_url':'https://accounts.google.com/o/oauth2/auth',
#             'request_token_url': None,
#             'client_id': GOOGLE_KEY,
#             'client_secret': GOOGLE_SECRET_KEY,
#         }
# }]

# When using LDAP Auth, specify the server details
# AUTH_LDAP_SERVER = "ldap://ldapserver.new"

# When using OpenID Auth, specify the providers details
# OPENID_PROVIDERS = [
#    { 'name': 'Yahoo', 'url': 'https://me.yahoo.com' },
#    { 'name': 'AOL', 'url': 'http://openid.aol.com/<username>' },
#    { 'name': 'Flickr', 'url': 'http://www.flickr.com/<username>' },
#    { 'name': 'MyOpenID', 'url': 'https://www.myopenid.com' }]

# ----------------------------------------------------
# Theme CONFIG
# ----------------------------------------------------
# Flask App Builder comes up with a number of predefined themes
# that you can use for Apache Airflow.
# http://flask-appbuilder.readthedocs.io/en/latest/customizing.html#changing-themes
# Please make sure to remove "navbar_color" configuration from airflow.cfg
# in order to fully utilize the theme. (or use that property in conjunction with theme)
# APP_THEME = "bootstrap-theme.css"  # default bootstrap
# APP_THEME = "amelia.css"
# APP_THEME = "cerulean.css"
# APP_THEME = "cosmo.css"
# APP_THEME = "cyborg.css"
# APP_THEME = "darkly.css"
# APP_THEME = "flatly.css"
# APP_THEME = "journal.css"
# APP_THEME = "lumen.css"
# APP_THEME = "paper.css"
# APP_THEME = "readable.css"
# APP_THEME = "sandstone.css"
# APP_THEME = "simplex.css"
# APP_THEME = "slate.css"
# APP_THEME = "solar.css"
# APP_THEME = "spacelab.css"
# APP_THEME = "superhero.css"
# APP_THEME = "united.css"
# APP_THEME = "yeti.css" 