import 'package:flutter/material.dart';
import 'package:app_projetoyuri/models/pet_model.dart';

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Imagem do pet (placeholder)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.pets, size: 40, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${pet.species} - ${pet.breed}'),
                  const SizedBox(height: 4),
                  Text(pet.location),
                  const SizedBox(height: 4),
                  Text(pet.age),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



//Criar nova rota e tela e navegar a partir de um novo botão; enviar parâmetros e exibi-los.


// lib/pages/nova_page.dart
// import 'package:flutter/material.dart';

// class NovaPage extends StatelessWidget {
//   final String nome;
//   final int idade;

//   const NovaPage({
//     super.key,
//     required this.nome,
//     required this.idade,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Página de Detalhes"),
//       ),
//       body: Center(
//         child: Text(
//           'Nome: $nome\nIdade: $idade anos',
//           style: const TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }



//substituir o appbar por esse que tem com o botão

// appBar: AppBar(
//   title: const Text("Home"),
//   actions: [
//     IconButton(
//       icon: const Icon(Icons.info),
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const NovaPage(
//               nome: "pedro",
//               idade: 22,
//             ),
//           ),
//         );
//       },
//     ),
//   ],
// ),