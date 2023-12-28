import datetime  # Correction de l'importation de datatime (corrigé en datetime)
from django.shortcuts import render, redirect
from django.contrib import messages
from .models import Demande
from .form import CreateDemandeForm, UpdateDemandeForm
from users.models import User
from django.contrib.auth.decorators import login_required
from django.http import HttpResponseBadRequest
# View demande details
@login_required
def demande_details(request, pk):
    demande = Demande.objects.get(pk=pk)
    t = User.objects.get(username=demande.created_by)
    demande_per_user = t.created_by.all()

    # Récupérez le contenu de repons_title
    repons_title = demande.repons_title

    # Utilisez le contenu de repons_title dans le message
    reponse_employe = repons_title

    context = {'demande': demande, 'demande_per_user': demande_per_user, 'reponse_employe': reponse_employe}
    return render(request, 'demande/demande_details.html', context)


# For Employe

# Create Demande
@login_required
def create_demande(request):
    if request.method == 'POST':
        form = CreateDemandeForm(request.POST)
        if form.is_valid():
            var = form.save(commit=False)
            var.created_by = request.user
            var.demande_status = 'Pending'
            var.save()
            messages.info(request, 'Your demande has been successfully submitted. An engineer would be assigned soon')
            return redirect('dashboard')
        else:
            messages.warning(request, 'Something went wrong. Please check the input')
            return redirect('create-demande')
    else:
        form = CreateDemandeForm()
        context = {'form': form}
        return render(request, 'demande/create_demande.html', context)

# Update demande
@login_required
def update_demande(request, pk):
    demande = Demande.objects.get(pk=pk)
    if request.method == 'POST':
        form = UpdateDemandeForm(request.POST, instance=demande)  # Utilisation de UpdateDemandeForm
        if form.is_valid():
            form.save()
            messages.info(request, 'Your demande has been updated and all changes are saved in the Database')
            return redirect('dashboard')
        else:
            messages.warning(request, 'Something went wrong. Please check the input')
    else:
        form = UpdateDemandeForm(instance=demande)  # Utilisation de UpdateDemandeForm
        context = {'form': form}
        return render(request, 'demande/update_demande.html', context)

# Viewing all created demande
@login_required
def all_demande(request):
    demande = Demande.objects.filter(created_by=request.user).order_by('-date_created')
    context = {'demande': demande}
    return render(request, 'demande/all_demande.html', context)

# For Engineers

# View demande queue
@login_required
def demande_queue(request):
    demande = Demande.objects.filter(demande_status='Pending')  # Correction de Demande.object en Demande.objects
    context = {'demande': demande}
    return render(request, 'demande/demande_queue.html', context)

# Accept a demande from the queue
@login_required
def accept_demande(request, pk):
    demande = Demande.objects.get(pk=pk)  # Correction de Demande.object en Demande.objects
    demande.assigned_to = request.user
    demande.demande_status = 'Active'
    demande.accepted_date = datetime.datetime.now()  # Correction de datatime en datetime
    demande.save()
    messages.info(request, 'Demande has been accepted. Please resolve as soon as possible')
    return redirect('workspace')

# Close a demande


@login_required
def close_demande(request, pk):
    demande = Demande.objects.get(pk=pk)
    demande.demande_status = 'Completed'
    demande.is_resolved = True
    demande.closed_date = datetime.datetime.now()

    # Récupérez la valeur du champ reponse_title à partir de la requête POST
    repons_title = request.POST.get('repons_title', '')

    # Vérifiez si la réponse de l'ingénieur est vide


    # Utilisez la valeur récupérée pour mettre à jour la demande
    demande.repons_title = repons_title
    demande.save()

    messages.info(request, 'Demande has been resolved. Thank you brilliant Support Engineer!')
    return redirect('demande-queue')



# Demande engineer is working on
@login_required
def workspace(request):
    demande = Demande.objects.filter(assigned_to=request.user, is_resolved=False)  # Correction de Demande.object en Demande.objects
    context = {'demande': demande}
    return render(request, 'demande/workspace.html', context)

# All closed/resolved demande
@login_required
def all_closed_demande(request):
    demande = Demande.objects.filter(assigned_to=request.user, is_resolved=True)  # Correction de Demande.object en Demande.objects et is_resolved=False en is_resolved=True
    context = {'demande': demande}
    return render(request, 'demande/all_closed_demande.html', context)

@login_required
def all_repande_demande(request):
    demande = Demande.objects.filter(assigned_to=request.user, is_resolved=True)  # Correction de Demande.object en Demande.objects et is_resolved=False en is_resolved=True
    context = {'demande': demande}
    return render(request, 'demande/all_Repande_demande.html', context)
