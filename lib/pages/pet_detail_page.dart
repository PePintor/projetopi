import 'package:flutter/material.dart';
import 'package:app_projetoyuri/models/pet_model.dart';

class PetDetailPage extends StatelessWidget {
  final Pet pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color primaryColor = theme.primaryColor;
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color accentGreen = Colors.green.shade400;
    final Color accentRed = Colors.red.shade400;
    final Color darkText = theme.textTheme.bodyLarge?.color ?? Colors.brown.shade700;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(pet.name),
        backgroundColor: primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
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
                color: primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                image: pet.photos.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(pet.photos.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: pet.photos.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.pets,
                        size: 64,
                        color: darkText,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),

            // Informações básicas
            _sectionTitle('Informações Básicas', darkText),
            const SizedBox(height: 12),
            _buildInfoItem('Nome', pet.name, darkText),
            _buildInfoItem('Espécie', pet.species, darkText),
            _buildInfoItem('Raça', pet.breed, darkText),
            _buildInfoItem('Idade', pet.age, darkText),
            _buildInfoItem('Localização', pet.location, darkText),

            const SizedBox(height: 20),

            // Descrição
            _sectionTitle('Descrição', darkText),
            const SizedBox(height: 8),
            Text(
              pet.description.isEmpty ? 'Sem descrição' : pet.description,
              style: TextStyle(fontSize: 16, color: darkText),
            ),

            const SizedBox(height: 20),

            // Cuidados especiais
            _sectionTitle('Cuidados Especiais', darkText),
            const SizedBox(height: 8),
            Text(
              pet.careInstructions.isEmpty
                  ? 'Nenhum cuidado especial informado'
                  : pet.careInstructions,
              style: TextStyle(fontSize: 16, color: darkText),
            ),

            const SizedBox(height: 20),

            // Saúde
            _sectionTitle('Saúde', darkText),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  pet.vaccinated ? Icons.check_circle : Icons.cancel,
                  color: pet.vaccinated ? accentGreen : accentRed,
                ),
                const SizedBox(width: 8),
                Text(
                  pet.vaccinated ? 'Pet vacinado' : 'Não vacinado',
                  style: TextStyle(
                    color: pet.vaccinated ? accentGreen : accentRed,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Contato
            _sectionTitle('Contato', darkText),
            const SizedBox(height: 8),
            Text(
              pet.contact,
              style: TextStyle(color: darkText),
            ),

            const SizedBox(height: 30),

            // Botão de contato
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Entrando em contato sobre o ${pet.name}...'),
                      backgroundColor: accentGreen,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGreen,
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

  Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Não informado' : value,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
