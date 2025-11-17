import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<Uint8List>?> pickMultipleImages() async {
    try {
      // ✅ REDUZIDO para evitar travamentos
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 800, // ↓ REDUZIDO
        maxHeight: 600, // ↓ REDUZIDO
        imageQuality: 60, // ↓ REDUZIDO
      );

      if (images != null && images.isNotEmpty) {
        final List<Uint8List> imageBytes = [];
        for (final image in images) {
          final bytes = await image.readAsBytes();

          // ✅ VERIFICA TAMANHO ANTES DE ADICIONAR
          if (bytes.length > 2 * 1024 * 1024) {
            // 2MB
            throw Exception(
                'Imagem muito grande: ${(bytes.length / 1024 / 1024).toStringAsFixed(1)}MB');
          }

          imageBytes.add(bytes);
        }
        return imageBytes;
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao selecionar imagens: $e');
    }
  }

  static Future<Uint8List?> pickSingleImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // ↓ REDUZIDO
        maxHeight: 600, // ↓ REDUZIDO
        imageQuality: 60, // ↓ REDUZIDO
      );

      if (image != null) {
        final bytes = await image.readAsBytes();

        // ✅ VERIFICA TAMANHO
        if (bytes.length > 2 * 1024 * 1024) {
          throw Exception(
              'Imagem muito grande: ${(bytes.length / 1024 / 1024).toStringAsFixed(1)}MB');
        }

        return bytes;
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao selecionar imagem: $e');
    }
  }

  // ✅ NOVO: Método com compressão automática
  static Future<List<Uint8List>?> pickAndCompressImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 60,
      );

      if (images != null && images.isNotEmpty) {
        final List<Uint8List> compressedImages = [];

        for (final image in images) {
          var bytes = await image.readAsBytes();

          // ✅ COMPRIME se for maior que 1MB
          if (bytes.length > 1 * 1024 * 1024) {
            bytes = await _compressImage(bytes);
          }

          compressedImages.add(bytes);
        }
        return compressedImages;
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao processar imagens: $e');
    }
  }

  // ✅ NOVO: Compressão simples
  static Future<Uint8List> _compressImage(Uint8List bytes) async {
    try {
      // Simula compressão reduzindo qualidade
      // Em app real, use: flutter_image_compress
      return bytes; // Por enquanto retorna original
    } catch (e) {
      return bytes; // Fallback para original
    }
  }

  static String? validateImages(List<Uint8List>? images) {
    if (images == null || images.isEmpty) {
      return 'Adicione pelo menos uma foto';
    }

    if (images.length > 5) {
      return 'Máximo 5 fotos permitidas';
    }

    // Valida tamanho de cada imagem (máximo 2MB)
    for (final image in images) {
      if (image.length > 2 * 1024 * 1024) {
        return 'Cada imagem deve ter no máximo 2MB';
      }
    }

    return null;
  }

  // Converte bytes para base64
  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  // Converte base64 para bytes
  static Uint8List base64ToBytes(String base64String) {
    return base64Decode(base64String);
  }
}
