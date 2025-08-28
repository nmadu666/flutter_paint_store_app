import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/features/sales/application/customer_providers.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';

class CustomerDialog extends ConsumerStatefulWidget {
  final Customer? customer;

  const CustomerDialog({super.key, this.customer});

  @override
  ConsumerState<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends ConsumerState<CustomerDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _phone1Controller;
  late TextEditingController _phone2Controller;
  late TextEditingController _birthdayController;
  late TextEditingController _emailController;
  late TextEditingController _facebookController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;
  late TextEditingController _newGroupController;
  // ... add controllers for other fields as needed

  // State variables
  DateTime? _selectedDate;
  String? _selectedGender;
  bool _isSupplier = false;
  final List<String> _selectedGroups = [];
  String _billingType = 'Cá nhân';

  // Billing Info Controllers
  // Common
  late TextEditingController _billingBuyerNameController;
  late TextEditingController _billingAddressController;
  late TextEditingController _billingEmailController;
  late TextEditingController _billingPhoneController;
  late TextEditingController _billingBankNameController;
  late TextEditingController _billingBankAccountController;
  // Individual-specific
  late TextEditingController _billingIdCardController; // CCCD
  late TextEditingController _billingPassportController;
  // Organization-specific
  late TextEditingController _billingTaxCodeController;
  late TextEditingController _billingCompanyNameController;
  late TextEditingController _billingStateBudgetCodeController; // Mã ĐVQHNS

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _nameController = TextEditingController(text: customer?.name ?? '');
    _codeController = TextEditingController(text: customer?.code ?? '');
    _phone1Controller = TextEditingController(
      text: customer?.contactNumber ?? '',
    );
    _phone2Controller =
        TextEditingController(); // Assuming no second phone in model
    _emailController = TextEditingController(text: customer?.email ?? '');
    _facebookController = TextEditingController(
      text: customer?.psidFacebook ?? '',
    );
    _addressController = TextEditingController(text: customer?.address ?? '');
    _newGroupController = TextEditingController();
    _notesController = TextEditingController(
      text: customer?.comments ?? '',
    ); // 'comments' for KiotViet API

    // Initialize billing type and controllers
    // NOTE: Assuming 'customer' has these billing fields.
    // Please update your Customer model accordingly.
    _billingType = (customer?.organization ?? '').isEmpty ? 'Cá nhân' : 'Tổ chức';
    _billingBuyerNameController =
        TextEditingController(text: '');
    _billingAddressController =
        TextEditingController(text:  '');
    _billingEmailController = TextEditingController(text: '');
    _billingPhoneController = TextEditingController(text: '');
    _billingBankNameController =
        TextEditingController(text: '');
    _billingBankAccountController =
        TextEditingController(text: '');
    _billingIdCardController = TextEditingController(text: '');
    _billingPassportController =
        TextEditingController(text: '');
    _billingTaxCodeController =
        TextEditingController(text: '');
    _billingCompanyNameController =
        TextEditingController(text: '');
    _billingStateBudgetCodeController =
        TextEditingController(text: '');

    _selectedDate = customer?.birthDate;
    _birthdayController = TextEditingController(
      text: _selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
          : '',
    );

    if (customer?.groups != null) {
      _selectedGroups.addAll(customer!.groups!);
    }

    if (customer?.gender != null) {
      _selectedGender = customer!.gender! ? 'Nam' : 'Nữ';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    _facebookController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _newGroupController.dispose();

    // Dispose billing controllers
    _billingBuyerNameController.dispose();
    _billingAddressController.dispose();
    _billingEmailController.dispose();
    _billingPhoneController.dispose();
    _billingBankNameController.dispose();
    _billingBankAccountController.dispose();
    _billingIdCardController.dispose();
    _billingPassportController.dispose();
    _billingTaxCodeController.dispose();
    _billingCompanyNameController.dispose();
    _billingStateBudgetCodeController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.customer != null;

      if (isEditing) {
        final updatedCustomer = widget.customer!.copyWith(
          name: _nameController.text,
          code: _codeController.text,
          contactNumber: _phone1Controller.text,
          birthDate: _selectedDate,
          gender: _selectedGender == 'Nam'
              ? true
              : _selectedGender == 'Nữ'
              ? false
              : null,
          email: _emailController.text,
          psidFacebook: _facebookController.text,
          address: _addressController.text,
          groups: _selectedGroups,
          comments: _notesController.text,
          modifiedDate: DateTime.now(),
        );
        ref.read(customersProvider.notifier).updateCustomer(updatedCustomer);
        ref.read(quoteTabsProvider.notifier).updateCustomerForActiveQuote(updatedCustomer);
      } else {
        final newCustomer = Customer(
          id: DateTime.now().millisecondsSinceEpoch,
          name: _nameController.text,
          code: _codeController.text, // Should be auto-generated by backend
          contactNumber: _phone1Controller.text,
          createdDate: DateTime.now(),
          birthDate: _selectedDate,
          gender: _selectedGender == 'Nam'
              ? true
              : _selectedGender == 'Nữ'
              ? false
              : null,
          email: _emailController.text,
          psidFacebook: _facebookController.text,
          address: _addressController.text,
          groups: _selectedGroups,
          comments: _notesController.text,
        );
        ref.read(customersProvider.notifier).addCustomer(newCustomer);
        ref.read(quoteTabsProvider.notifier).updateCustomerForActiveQuote(newCustomer);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customer != null;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isEditing ? 'Sửa thông tin khách hàng' : 'Tạo khách hàng'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Use a breakpoint to switch between layouts
              if (constraints.maxWidth > 800) {
                return _buildWideLayout();
              } else {
                return _buildNarrowLayout();
              }
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Bỏ qua'),
        ),
        FilledButton(onPressed: _handleSave, child: const Text('Lưu')),
      ],
    );
  }

  /// Builds the layout for narrow screens (Mobile)
  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNameField(),
          const SizedBox(height: 16),
          _buildCodeField(),
          const SizedBox(height: 24),
          _buildImageUploader(),
          const SizedBox(height: 24),
          _buildPhone1Field(),
          const SizedBox(height: 16),
          _buildPhone2Field(),
          const SizedBox(height: 16),
          _buildBirthdayField(),
          const SizedBox(height: 16),
          _buildGenderField(),
          const SizedBox(height: 16),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildFacebookField(),
          const SizedBox(height: 16),
          // Expansion sections for consistency with wide layout
          ExpansionTile(
            title: const Text('Địa chỉ'),
            initiallyExpanded: widget.customer?.address?.isNotEmpty ?? false,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildAddressField(),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Nhóm khách hàng, ghi chú'),
            initiallyExpanded:
                (widget.customer?.groups?.isNotEmpty ?? false) ||
                (widget.customer?.comments?.isNotEmpty ?? false),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    _buildGroupField(),
                    const SizedBox(height: 16),
                    _buildNotesField(),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Thông tin xuất hóa đơn'),
            children: [_buildBillingInfoSection()],
          ),
          SwitchListTile(
            title: const Text('Khách hàng là nhà cung cấp'),
            value: _isSupplier,
            onChanged: (value) => setState(() => _isSupplier = value),
          ),
        ],
      ),
    );
  }

  /// Builds the layout for wide screens (Desktop/Tablet)
  Widget _buildWideLayout() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column for input fields
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildNameField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCodeField()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildPhone1Field()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPhone2Field()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildBirthdayField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildGenderField()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildEmailField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFacebookField()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right column for image uploader
              Expanded(flex: 1, child: _buildImageUploader()),
            ],
          ),
          const SizedBox(height: 16),
          // Expansion sections
          ExpansionTile(
            initiallyExpanded: widget.customer?.address?.isNotEmpty ?? false,
            title: const Text('Địa chỉ'),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildAddressField(),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Nhóm khách hàng, ghi chú'),
            initiallyExpanded:
                (widget.customer?.groups?.isNotEmpty ?? false) ||
                (widget.customer?.comments?.isNotEmpty ?? false),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    _buildGroupField(),
                    const SizedBox(height: 16),
                    _buildNotesField(),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Thông tin xuất hóa đơn'),
            children: [_buildBillingInfoSection()],
          ),
          SwitchListTile(
            title: const Text('Khách hàng là nhà cung cấp'),
            value: _isSupplier,
            onChanged: (value) => setState(() => _isSupplier = value),
          ),
        ],
      ),
    );
  }

  // --- Field Widgets ---

  /// Generic text field builder to reduce boilerplate
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    bool readOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        alignLabelWithHint: maxLines > 1,
      ),
      validator: validator,
      onTap: onTap,
    );
  }

  Widget _buildNameField() => _buildTextField(
        controller: _nameController,
        labelText: 'Tên khách hàng',
        hintText: 'Bắt buộc',
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Vui lòng nhập tên' : null,
      );

  Widget _buildCodeField() => _buildTextField(
        controller: _codeController,
        labelText: 'Mã khách hàng',
        hintText: 'Tự động',
        readOnly: true,
      );

  Widget _buildPhone1Field() => _buildTextField(
        controller: _phone1Controller,
        labelText: 'Điện thoại 1',
        keyboardType: TextInputType.phone,
      );

  Widget _buildPhone2Field() => _buildTextField(
        controller: _phone2Controller,
        labelText: 'Điện thoại 2',
        keyboardType: TextInputType.phone,
      );

  Widget _buildEmailField() => _buildTextField(
        controller: _emailController,
        labelText: 'Email',
        keyboardType: TextInputType.emailAddress,
      );

  Widget _buildFacebookField() => _buildTextField(
        controller: _facebookController,
        labelText: 'Facebook',
      );

  Widget _buildAddressField() => _buildTextField(
        controller: _addressController,
        labelText: 'Địa chỉ chi tiết',
        maxLines: 3,
      );

  Widget _buildNotesField() => _buildTextField(
        controller: _notesController,
        labelText: 'Ghi chú (Comments)',
        maxLines: 3,
      );

  Widget _buildBirthdayField() => _buildTextField(
        controller: _birthdayController,
        labelText: 'Sinh nhật',
        readOnly: true,
        suffixIcon: const Icon(Icons.calendar_today),
    onTap: () async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (pickedDate != null && pickedDate != _selectedDate) {
        setState(() {
          _selectedDate = pickedDate;
          _birthdayController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(pickedDate);
        });
      }
    },
  );

  Widget _buildGroupField() {
    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Nhóm khách hàng'),
      child: Wrap(
        spacing: 6.0,
        runSpacing: 0.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ..._selectedGroups.map((group) {
            return Chip(
              label: Text(group),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.all(4),
              onDeleted: () {
                setState(() {
                  _selectedGroups.remove(group);
                });
              },
            );
          }),
          IntrinsicWidth(
            child: TextFormField(
              controller: _newGroupController,
              decoration: const InputDecoration(
                hintText: 'Thêm nhóm...',
                border: InputBorder.none,
                isDense: true,
              ),
              onFieldSubmitted: (value) {
                final trimmedValue = value.trim();
                if (trimmedValue.isNotEmpty &&
                    !_selectedGroups.contains(trimmedValue)) {
                  setState(() {
                    _selectedGroups.add(trimmedValue);
                    _newGroupController.clear();
                  });
                } else {
                  _newGroupController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderField() => DropdownButtonFormField<String>(
    value: _selectedGender,
    decoration: const InputDecoration(labelText: 'Giới tính'),
    items: ['Nam', 'Nữ', 'Khác']
        .map((label) => DropdownMenuItem(value: label, child: Text(label)))
        .toList(),
    onChanged: (value) {
      setState(() {
        _selectedGender = value;
      });
    },
  );

  Widget _buildImageUploader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            // TODO: Handle image picking logic
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined),
                SizedBox(height: 4),
                Text('Thêm ảnh', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ảnh không được vượt quá 2MB',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildBillingInfoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<String>(
            style: SegmentedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            segments: const [
              ButtonSegment(value: 'Cá nhân', label: Text('Cá nhân')),
              ButtonSegment(
                  value: 'Tổ chức', label: Text('Tổ chức/Hộ Kinh Doanh')),
            ],
            selected: {_billingType},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _billingType = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 24),
          if (_billingType == 'Cá nhân')
            _buildIndividualBillingFields()
          else
            _buildOrganizationBillingFields(),
        ],
      ),
    );
  }

  Widget _buildIndividualBillingFields() {
    return Column(
      children: [
        _buildTextField(
            controller: _billingBuyerNameController, labelText: 'Tên người mua'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingAddressController, labelText: 'Địa chỉ'),
        const SizedBox(height: 16),
        _buildTextField(controller: _billingIdCardController, labelText: 'CCCD'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingPassportController, labelText: 'Sổ hộ chiếu'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingEmailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingPhoneController,
            labelText: 'Số điện thoại',
            keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingBankNameController, labelText: 'Ngân hàng'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingBankAccountController,
            labelText: 'Số tài khoản ngân hàng',
            keyboardType: TextInputType.number),
      ],
    );
  }

  Widget _buildOrganizationBillingFields() {
    return Column(
      children: [
        _buildTextField(
            controller: _billingTaxCodeController, labelText: 'Mã số thuế'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingCompanyNameController, labelText: 'Tên công ty'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingAddressController, labelText: 'Địa chỉ'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingBuyerNameController, labelText: 'Tên người mua'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingStateBudgetCodeController, labelText: 'Mã ĐVQHNS'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingEmailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingPhoneController,
            labelText: 'Số điện thoại',
            keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingBankNameController, labelText: 'Ngân hàng'),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _billingBankAccountController,
            labelText: 'Số tài khoản ngân hàng',
            keyboardType: TextInputType.number),
      ],
    );
  }
}
