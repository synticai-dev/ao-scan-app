import 'package:ao_scan_app/models/resource_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ao_scan_app/controllers/auth_controller.dart';

class ResourcesController extends GetxController {
  final authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ResourceModel> resources = <ResourceModel>[].obs;
  RxList<String> favoriteIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialResources();
    _loadFavorites();
  }

  void _loadInitialResources() {
    resources.assignAll([
      ResourceModel(
        id: '1',
        title: 'AO Scan Technology',
        category: 'Technology',
        description: 'Understand the science behind AO Scan.',
        content: '''
          AO Scan technology is based on the works of researchers from around the world such as Nikola Tesla, Albert Einstein, Marie Curie and many others who have pioneered the study of frequency and vibration.

          The AO Scan Mobile is a comprehensive tool that provides an educational experience by scanning and optimizing the frequencies of the body. It uses bio-resonance and frequency technology to detect imbalances in the body's energy field.

          Key features include:
          - Inner-Voice: Analyzes over 2,000 frequencies across 12 notes in the voice to identify emotional imbalances.
          - Vitals Scan: A complete scan of over 550 blueprint frequencies.
          - Comprehensive Scan: Detailed scans of over 130 organs, bones, and systems.
        ''',
      ),
      ResourceModel(
        id: '2',
        title: 'Quantum Wellness',
        category: 'Health',
        description: 'Learn about quantum wellness and energy healing.',
        content: '''
          Quantum wellness is an approach to health that focuses on the energetic level of the human body. Everything in the universe, including our bodies, is made of energy and vibrates at specific frequencies.

          When our frequencies are in balance, we experience health and vitality. When they are out of balance, we may experience physical or emotional discomfort.

          AO Scan helps to identify these imbalances and provides optimizing frequencies to help bring the body back into a state of resonance.
        ''',
      ),
       ResourceModel(
        id: '3',
        title: 'Product Information',
        category: 'Products',
        description: 'Detailed information about Solex products.',
        content: '''
          Solex offers a variety of products designed to support your wellness journey.

          - AO Scan Mobile: The flagship device for frequency scanning.
          - SEFI (Subtle Energy Frequency Imprinter): Imprints frequencies into jewelry, sugar pellets, or water.
          - Pulse: Wearable technology for continuous frequency support.
        ''',
      ),
    ]);
  }

  Future<void> _loadFavorites() async {
    if (authController.firebaseUser.value == null) return;
    
    try {
      final doc = await _firestore.collection('users').doc(authController.firebaseUser.value!.uid).collection('favorites').get();
      favoriteIds.assignAll(doc.docs.map((d) => d.id).toList());
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> toggleFavorite(String resourceId) async {
    if (authController.firebaseUser.value == null) {
      Get.snackbar('Login Required', 'Please login to save resources.');
      return;
    }

    final uid = authController.firebaseUser.value!.uid;
    final favRef = _firestore.collection('users').doc(uid).collection('favorites').doc(resourceId);

    if (favoriteIds.contains(resourceId)) {
      await favRef.delete();
      favoriteIds.remove(resourceId);
    } else {
      await favRef.set({'savedAt': FieldValue.serverTimestamp()});
      favoriteIds.add(resourceId);
    }
  }

  bool isFavorite(String resourceId) => favoriteIds.contains(resourceId);
}
