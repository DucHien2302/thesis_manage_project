import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/student_models.dart';
import 'package:thesis_manage_project/screens/thesis_registration/thesis_registration.dart';
import 'package:thesis_manage_project/services/thesis_service.dart';

/// Widget để hiển thị card đăng ký đề tài trong student dashboard
class ThesisRegistrationCard extends StatelessWidget {
  final StudentModel student;

  const ThesisRegistrationCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.marginRegular),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                  ),
                  child: const Icon(
                    Icons.assignment,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppDimens.marginMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đăng ký đề tài',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimens.marginSmall),
                      Text(
                        'Tìm và đăng ký đề tài ${student.majorName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.marginMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _navigateToMyRegistrations(context),
                    icon: const Icon(Icons.list, size: 16),
                    label: const Text('Đăng ký của tôi'),
                  ),
                ),
                const SizedBox(width: AppDimens.marginRegular),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToThesisList(context),
                    icon: const Icon(Icons.search, size: 16),
                    label: const Text('Tìm đề tài'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _navigateToThesisList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ThesisRegistrationBloc(
            thesisService: ThesisService(),
          ),          child: ThesisListView(
            studentId: student.id,
          ),
        ),
      ),
    );
  }
  void _navigateToMyRegistrations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ThesisRegistrationBloc(
            thesisService: ThesisService(),
          ),
          child: StudentRegistrationsView(
            studentId: student.id,
          ),
        ),
      ),
    );
  }
}
