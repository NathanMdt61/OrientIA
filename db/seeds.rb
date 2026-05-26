# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Message.destroy_all
Chat.destroy_all
User.destroy_all
Hobbie.destroy_all
Job.destroy_all

# Création de josselin

josselin = User.create(user_name: "Josselin", email: "josselin@example.com", password: "password", age: 15, goal: "découvrir les métiers", school_level: "2nd")

# Création de hobbies

Hobbie.create(title: "sport")
Hobbie.create(title: "jeux vidéo")
Hobbie.create(title: "cuisine")
Hobbie.create(title: "technologie")
Hobbie.create(title: "nature")
Hobbie.create(title: "architecture")
Hobbie.create(title: "dessin")
Hobbie.create(title: "musique")
Hobbie.create(title: "lecture")
Hobbie.create(title: "photo")
Hobbie.create(title: "bricolage")
Hobbie.create(title: "voyage")
Hobbie.create(title: "écriture")
Hobbie.create(title: "mode")
Hobbie.create(title: "pêche")

# Création de Jobs

Job.create(title: "développeur")
Job.create(title: "infirmier")
Job.create(title: "enseignant")
Job.create(title: "commercial")
Job.create(title: "comptable")
Job.create(title: "médecin")
Job.create(title: "architecte")
Job.create(title: "cuisinier")
Job.create(title: "graphiste")
Job.create(title: "ingénieur")
Job.create(title: "avocat")
Job.create(title: "journaliste")
Job.create(title: "photographe")

# Création de chats

chat = Chat.create(title: "Exploration de carrières", user: josselin)

# Création de messages

Message.create(chat: chat, role: "user", content: "Bonjour ! Je veux découvrir des métiers qui me correspondent.")
Message.create(chat: chat, role: "assistant", content: "Bonjour Josselin ! Quels sont tes centres d'intérêt ?")
