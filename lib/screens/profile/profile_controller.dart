import 'package:get/get.dart';
import '../../../models/user_model.dart';
import '../../../services/user_service.dart';

class ProfileController extends GetxController {
  final UserService _userService = UserService();
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final userData = await _userService.getCurrentUser();
      user.value = userData;
    } catch (e) {
      errorMessage.value = 'Failed to load profile';
      print('Error in fetchUserProfile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _userService.updateUserProfile(updatedUser);
      user.value = updatedUser;
      
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to update profile';
      print('Error in updateProfile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _userService.signOut();
      Get.offAllNamed('/signin');
    } catch (e) {
      errorMessage.value = 'Failed to sign out';
      print('Error in signOut: $e');
    }
  }
} 