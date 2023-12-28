from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User

class EmployeUserAdmin(UserAdmin):
    fieldsets = (
        *UserAdmin.fieldsets,
        (
            'Employe Field Heading',
            {
                'fields':(
                    'is_employe',
                    'is_engineer'
                )
            }
        )
    )

admin.site.register(User,EmployeUserAdmin)

