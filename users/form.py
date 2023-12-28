from django.contrib.auth.forms import UserCreationForm
from .models import User

class RegisterEmployeForm(UserCreationForm):
    class Meta:
        model = User
        fields = ['email', 'username']
