import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/circle_add_button.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../logic/employees_cubit.dart';
import 'widgets/add_employee_sheet.dart';
import 'widgets/edit_employee_sheet.dart';
import 'widgets/employee_card.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocProvider(
      create: (_) => getIt<EmployeesCubit>()..fetchEmployees(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<EmployeesCubit>();

          return Scaffold(
            backgroundColor: AppColors.surfaceColor.themeColor,
            appBar: AppBar(
              title: AppText(
                LocaleKeys.drawer_employeesManagement.tr(),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor,
              ),
              backgroundColor: primary,
              foregroundColor: AppColors.textPrimaryColor.themeColor,
            ),
            floatingActionButton: CircleAddButton(
              onTap: () => AddEmployeeSheet.show(
                context,
                onSubmit: (name, phone, email) => cubit.addEmployee(
                  name: name,
                  phone: phone,
                  email: email,
                ),
              ),
            ),
            body: BlocBuilder<EmployeesCubit, EmployeesState>(
              builder: (context, state) {
                if (state is EmployeesLoading || state is EmployeesInitial) {
                  return Center(
                    child: CustomLoadingWidget(color: primary, size: 40),
                  );
                }

                if (state is EmployeesError) {
                  return Center(
                    child: AppText(
                      state.message,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                  );
                }

                final employees = (state as EmployeesSuccess).employees;
                if (employees.isEmpty) {
                  return AppEmpty(
                    message: LocaleKeys.employees_empty.tr(),
                    icon: Icons.badge_outlined,
                  );
                }

                return ListView.separated(
                  padding: 16.paddingAll + 50.paddingBottom,
                  itemCount: employees.length,
                  separatorBuilder: (_, __) => 10.height,
                  itemBuilder: (_, i) {
                    final employee = employees[i];
                    return EmployeeCard(
                      employee: employee,
                      onEdit: () => EditEmployeeSheet.show(
                        context,
                        employee: employee,
                        onSubmit: (name, email, status) =>
                            cubit.updateEmployee(
                          id: employee.id,
                          name: name,
                          email: email,
                          status: status,
                        ),
                      ),
                      onDelete: () => cubit.deleteEmployee(employee.id),
                      onToggleActive: (value) => cubit.updateEmployee(
                        id: employee.id,
                        name: employee.name,
                        email: employee.email ?? '',
                        status: value ? 'active' : 'inactive',
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
