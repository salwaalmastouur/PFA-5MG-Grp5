from django.urls import path
from . import views

urlpatterns = [
    path('demande-details/<int:pk>/', views.demande_details, name='demande-details'),
    path('create-demande/', views.create_demande, name='create-demande'),
    path('update-demande/<int:pk>/', views.update_demande, name='update-demande'),
    path('all-demande/', views.all_demande, name='all-demande'),
    path('demande-queue/', views.demande_queue, name='demande-queue'),
    path('accept-demande/<int:pk>/', views.accept_demande, name='accept-demande'),
    path('close-demande/<int:pk>/', views.close_demande, name='close-demande'),
    path('workspace/', views.workspace, name='workspace'),
    path('all-closed-demande/', views.all_closed_demande, name='all-closed-demande'),
    path('all-repande-demande/', views.all_repande_demande, name='all-repande-demande'),
]

