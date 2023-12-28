from django import forms
from .models import Demande

class CreateDemandeForm(forms.ModelForm):
    class Meta:
        model = Demande
        fields = ['titre', 'description']  # Correction de 'title' en 'titre'

class UpdateDemandeForm(forms.ModelForm):
    class Meta:
        model = Demande
        fields = ['titre', 'description']  # Correction de 'title' en 'titre'
