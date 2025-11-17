import 'package:flutter/material.dart';
import 'package:app_projetoyuri/models/pet_model.dart';

class PetDetailPage extends StatelessWidget {
  final Pet pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fotos do pet
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                image: pet.photos.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(pet.photos.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: pet.photos.isEmpty
                  ? const Center(
                      child: Icon(Icons.pets, size: 64, color: Colors.grey),
                    )
                  : null,
            ),
            const SizedBox(height: 20),

            // Informações básicas
            const Text(
              'Informações Básicas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoItem('Nome', pet.name),
            _buildInfoItem('Espécie', pet.species),
            _buildInfoItem('Raça', pet.breed),
            _buildInfoItem('Idade', pet.age),
            _buildInfoItem('Localização', pet.location),
            const SizedBox(height: 20),

            // Descrição
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              pet.description.isEmpty ? 'Sem descrição' : pet.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Cuidados especiais
            const Text(
              'Cuidados Especiais',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              pet.careInstructions.isEmpty
                  ? 'Nenhum cuidado especial informado'
                  : pet.careInstructions,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Saúde
            const Text(
              'Saúde',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  pet.vaccinated ? Icons.check_circle : Icons.cancel,
                  color: pet.vaccinated ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  pet.vaccinated ? 'Pet vacinado' : 'Não vacinado',
                  style: TextStyle(
                    color: pet.vaccinated ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contato
            const Text(
              'Contato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(pet.contact),
            const SizedBox(height: 30),

            // Botão de contato
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Entrando em contato sobre o ${pet.name}...'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Entrar em Contato'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value.isEmpty ? 'Não informado' : value),
        ],
      ),
    );
  }
}
