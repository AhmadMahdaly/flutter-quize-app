
import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class CompactCheckbox extends StatelessWidget {
  const CompactCheckbox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24.w, // Constrain checkbox width
            height: 24.h, // Constrain checkbox height
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryColor,
              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap, // Removes extra tap area
              visualDensity: VisualDensity.compact, // Makes it more compact
            ),
          ),
          8.horizontalSpace, // Minimal spacing
          Expanded(
            child: Text(
              title,
              style: interRegular.copyWith(fontSize: 14.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
