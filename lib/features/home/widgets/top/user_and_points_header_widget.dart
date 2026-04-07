import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/features/home/widgets/top/user_image_name_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class UserAndPointsHeaderWidget extends StatelessWidget {
  const UserAndPointsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UserImageNameWidget(
      name: context.watch<MainLayoutCubit>().profileModel?.data?.name ?? 'User',
      email: context.read<MainLayoutCubit>().profileModel?.data?.email ?? '',
      imagePath: context.read<MainLayoutCubit>().profileModel?.data?.photo,
      points:
          '${context.read<MainLayoutCubit>().profileModel?.data?.points ?? ''}',
    );
  }
}
