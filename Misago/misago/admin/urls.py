from django.urls import path

from .. import admin
from .views import auth, index

urlpatterns = [
    # "misago:admin:index" link symbolises "root" of Misago admin links space
    # any request with path that falls below this one is assumed to be directed
    # at Misago Admin and will be checked by Misago Admin Middleware
    path("", index.admin_index, name="index"),
    path("logout/", auth.logout, name="logout"),
]

# Discover admin and register patterns
admin.discover_misago_admin()
urlpatterns += admin.urlpatterns()
