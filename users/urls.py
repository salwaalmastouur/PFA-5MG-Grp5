from django.urls import path
from . import views


urlpatterns = [
    path('register_employe/',views.register_employe, name='register-employe'),
    path('login/', views.login_user,name='login'),
    path('logout/',views.logout_user,name='logout')
]