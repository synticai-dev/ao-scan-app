import 'dart:ui';
import 'package:ao_scan_app/models/demo_request_model.dart';
import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class DemoRequestDetailsScreen extends StatelessWidget {
  final DemoRequestModel request;
  const DemoRequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.darkBlue, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Request Details',
          style: AppTextStyle.bold(fontSize: 18, color: AppColors.darkBlue),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 24),
            
            // Photo Preview if available
            if (request.photoUrl != null && request.photoUrl!.isNotEmpty) ...[
              _buildSectionHeader('Photo Sample', Icons.photo_library_rounded),
              const SizedBox(height: 12),
              _buildImageCard(),
              const SizedBox(height: 32),
            ],

            // Audio Player if available
            if (request.audioUrl != null && request.audioUrl!.isNotEmpty) ...[
              _buildSectionHeader('Voice Sample', Icons.mic_rounded),
              const SizedBox(height: 12),
              _buildAudioCard(),
              const SizedBox(height: 32),
            ],

            _buildSectionCard(
              'Personal Information',
              Icons.person_rounded,
              [
                _buildDetailRow('Full Name', '${request.firstName} ${request.lastName}', Icons.badge_outlined),
                _buildDetailRow('Email', request.email, Icons.email_outlined),
                _buildDetailRow('Phone', '${request.phoneCountryCode} ${request.phoneNumber}', Icons.phone_android_outlined),
                _buildDetailRow('Country', request.country, Icons.public_outlined),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildSectionCard(
              'Physical & Personal Attributes',
              Icons.fitness_center_rounded,
              [
                _buildDetailRow('Sex', request.sex, Icons.wc_rounded),
                _buildDetailRow('Weight', '${request.weight} ${request.weightUnit}', Icons.monitor_weight_outlined),
                _buildDetailRow('Height', '${request.height} ${request.heightUnit}', Icons.height_rounded),
                _buildDetailRow('Date of Birth', request.dateOfBirth, Icons.calendar_today_outlined),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionCard(
              'Professional Details',
              Icons.work_rounded,
              [
                _buildDetailRow('Occupation', request.occupation, Icons.business_center_outlined),
                _buildDetailRow('Use Type', request.useType, Icons.category_outlined),
              ],
            ),
            const SizedBox(height: 24),

            if (request.message != null && request.message!.isNotEmpty) ...[
               _buildSectionCard(
                'Message',
                Icons.chat_bubble_rounded,
                [
                  Text(
                    request.message!,
                    style: AppTextStyle.regular(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            if (request.adminNote != null && request.adminNote!.isNotEmpty) ...[
              _buildAdminNoteCard(),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    IconData statusIcon;
    String statusTitle;

    switch (request.status.toLowerCase()) {
      case 'approved':
        statusColor = AppColors.successGreen;
        statusIcon = Icons.verified_rounded;
        statusTitle = 'Approved';
        break;
      case 'rejected':
        statusColor = AppColors.errorRed;
        statusIcon = Icons.cancel_rounded;
        statusTitle = 'Rejected';
        break;
      default:
        statusColor = AppColors.warningAmber;
        statusIcon = Icons.auto_mode_rounded;
        statusTitle = 'Pending Review';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: AppTextStyle.bold(fontSize: 20, color: statusColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Submitted on ${DateFormat('MMMM dd, yyyy').format(request.submissionDate)}',
                  style: AppTextStyle.regular(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: AppTextStyle.bold(fontSize: 16, color: AppColors.darkBlue),
        ),
      ],
    );
  }

  Widget _buildImageCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          request.photoUrl!,
          width: double.infinity,
          height: 350,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 350,
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            height: 200,
            color: Colors.grey.shade100,
            child: const Icon(Icons.broken_image_rounded, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: AudioPlayerWidget(url: request.audioUrl!),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title, icon),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.regular(fontSize: 12, color: AppColors.textLight),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyle.bold(fontSize: 15, color: AppColors.darkBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminNoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sticky_note_2_rounded, color: Colors.amberAccent, size: 20),
              const SizedBox(width: 10),
              Text(
                'Admin Response',
                style: AppTextStyle.bold(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            request.adminNote!,
            style: AppTextStyle.regular(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String url;
  const AudioPlayerWidget({super.key, required this.url});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) setState(() => _duration = newDuration);
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) setState(() => _position = newPosition);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _playerState == PlayerState.playing 
                ? Icons.pause_circle_filled_rounded 
                : Icons.play_circle_filled_rounded,
            color: AppColors.primaryBlue,
            size: 48,
          ),
          onPressed: _playPause,
          padding: EdgeInsets.zero,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                ),
                child: Slider(
                  activeColor: AppColors.primaryBlue,
                  inactiveColor: AppColors.primaryBlue.withOpacity(0.1),
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: AppTextStyle.regular(fontSize: 10, color: AppColors.textSecondary),
                    ),
                    Text(
                      '${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: AppTextStyle.regular(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
