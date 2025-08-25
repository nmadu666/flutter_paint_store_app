import 'package:flutter/material.dart';
import 'package:flutter_paint_store_app/models/customer.dart';

class CustomerDialog extends StatefulWidget {
  final Customer? customer;

  const CustomerDialog({super.key, this.customer});

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog> {
  String? _gender;
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _groupController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _emailController;
  late final TextEditingController _facebookController;
  late final TextEditingController _noteController;

  bool get _isEditMode => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.customer?.id ?? '');
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _phoneController = TextEditingController(text: widget.customer?.phone ?? '');
    _addressController =
        TextEditingController(text: widget.customer?.address ?? '');
    _groupController = TextEditingController();
    _birthDateController = TextEditingController();
    _emailController = TextEditingController();
    _facebookController = TextEditingController();
    _noteController = TextEditingController();
    // _gender = widget.customer?.gender; // Customer model doesn't have gender
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _groupController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _facebookController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: isDesktop
            ? _buildDesktopLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return DefaultTabController(
      length: _isEditMode ? 2 : 1,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditMode)
              _buildEditHeader(context)
            else
              Text('Thêm khách hàng',
                  style: Theme.of(context).textTheme.headlineSmall),
            if (_isEditMode)
              const TabBar(
                tabs: [
                  Tab(text: 'Thông tin chung'),
                  Tab(text: 'Dư nợ'),
                ],
              ),
            const SizedBox(height: 24),
            SizedBox(
              height: 600, // Needs a height for TabBarView in SingleChildScrollView
              child: TabBarView(
                children: [
                  _buildGeneralInfoTabMobile(),
                  if (_isEditMode) const Center(child: Text('Đang xây dựng')),
                ],
              ),
            ),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralInfoTabMobile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 16),
          _buildTextField(label: 'Mã khách hàng', controller: _codeController),
          const SizedBox(height: 16),
          _buildTextField(label: 'Tên khách hàng', controller: _nameController),
          const SizedBox(height: 16),
          _buildTextField(label: 'Số điện thoại', controller: _phoneController),
          const SizedBox(height: 16),
          _buildTextField(label: 'Địa chỉ', controller: _addressController),
          const SizedBox(height: 16),
          _buildTextField(label: 'Nhóm khách hàng', controller: _groupController),
          const SizedBox(height: 16),
          _buildBirthdayAndGender(),
          const SizedBox(height: 16),
          _buildTextField(label: 'Email', controller: _emailController),
          const SizedBox(height: 16),
          _buildTextField(label: 'Facebook', controller: _facebookController),
          const SizedBox(height: 16),
          _buildTextField(label: 'Ghi chú', controller: _noteController),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return DefaultTabController(
      length: _isEditMode ? 3 : 2,
      child: SizedBox(
        width: 800,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditMode)
              _buildEditHeader(context)
            else
              Text('Thêm khách hàng',
                  style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TabBar(
              tabs: [
                const Tab(text: 'Thông tin chung'),
                const Tab(text: 'Thông tin xuất hoá đơn'),
                if (_isEditMode) const Tab(text: 'Dư Nợ'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDesktopGeneralInfoTab(context),
                  const Center(child: Text('Đang xây dựng')),
                  if (_isEditMode)
                    const Center(child: Text('Đang xây dựng')),
                ],
              ),
            ),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEditHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.customer!.name} - ${widget.customer!.id} | Chi nhánh tạo',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text('Nợ: 0 | Tổng bán trừ trả hàng: 0'),
      ],
    );
  }

  Widget _buildDesktopGeneralInfoTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildAvatar(),
                  const SizedBox(height: 16),
                  _buildTextField(
                      label: 'Mã khách hàng', controller: _codeController),
                  const SizedBox(height: 16),
                  _buildTextField(
                      label: 'Tên khách hàng', controller: _nameController),
                  const SizedBox(height: 16),
                  _buildTextField(
                      label: 'Số điện thoại', controller: _phoneController),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Địa chỉ', controller: _addressController),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _buildTextField(
                      label: 'Nhóm khách hàng', controller: _groupController),
                  const SizedBox(height: 16),
                  _buildBirthdayAndGender(),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Email', controller: _emailController),
                  const SizedBox(height: 16),
                  _buildTextField(
                      label: 'Facebook', controller: _facebookController),
                  const SizedBox(height: 16),
                  _buildTextField(
                      label: 'Ghi chú', controller: _noteController, maxLines: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton.filled(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      int maxLines = 1,
      TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget _buildBirthdayAndGender() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildTextField(
              label: 'Ngày sinh', controller: _birthDateController),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _gender,
            onChanged: (String? newValue) {
              setState(() {
                _gender = newValue;
              });
            },
            items: <String>['Nam', 'Nữ', 'Khác']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Giới tính',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isEditMode)
          TextButton(
            onPressed: () {
              // TODO: Delete customer
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Xóa'),
          ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            // TODO: Save customer
            Navigator.of(context).pop();
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}