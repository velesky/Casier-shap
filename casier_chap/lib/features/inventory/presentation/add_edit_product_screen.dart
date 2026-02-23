import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/models/product.dart';
import '../providers/inventory_provider.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  final String? productId;

  const AddEditProductScreen({super.key, this.productId});

  @override
  ConsumerState<AddEditProductScreen> createState() =>
      _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _stockController;
  late TextEditingController _thresholdController;
  String _category = 'Bière';

  @override
  void initState() {
    super.initState();
    final product = widget.productId != null
        ? ref
              .read(inventoryProvider)
              .firstWhere((p) => p.id == widget.productId)
        : null;

    _nameController = TextEditingController(text: product?.name ?? '');
    _purchasePriceController = TextEditingController(
      text: product?.purchasePrice.toString() ?? '',
    );
    _salePriceController = TextEditingController(
      text: product?.salePrice.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: product?.stockQuantity.toString() ?? '',
    );
    _thresholdController = TextEditingController(
      text: product?.criticalThreshold.toString() ?? '10',
    );
    _category = product?.category ?? 'Bière';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.productId ?? const Uuid().v4(),
        name: _nameController.text,
        category: _category,
        purchasePrice: double.parse(_purchasePriceController.text),
        salePrice: double.parse(_salePriceController.text),
        stockQuantity: int.parse(_stockController.text),
        criticalThreshold: int.parse(_thresholdController.text),
      );

      if (widget.productId == null) {
        ref.read(inventoryProvider.notifier).addProduct(product);
      } else {
        ref.read(inventoryProvider.notifier).updateProduct(product);
      }
      context.pop();
    }
  }

  void _delete() {
    showDialog(
      context: context,
      builder: (context) => _DeleteConfirmationDialog(
        onConfirm: () {
          ref.read(inventoryProvider.notifier).deleteProduct(widget.productId!);
          Navigator.pop(context); // Close dialog
          context.pop(); // Close screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productId != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(isEditing ? 'Modifier Produit' : 'Nouveau Produit'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _save,
              child: const Text(
                'VALIDER',
                style: TextStyle(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F0F0F), Color(0xFF000000)],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 120), // Adjust for AppBar
                  // Product Image Placeholder
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.05),
                                Colors.white.withOpacity(0.01),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: Colors.white10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryOrange.withOpacity(
                                  0.05,
                                ),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            _category == 'Bière'
                                ? Icons.sports_bar_rounded
                                : Icons.local_drink_rounded,
                            size: 70,
                            color: AppColors.primaryOrange.withOpacity(0.8),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 3),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('INFORMATIONS GÉNÉRALES'),
                        const SizedBox(height: 16),
                        _buildField(
                          label: 'Nom du produit',
                          controller: _nameController,
                          hint: 'Ex: Bock 65cl',
                          validator: (v) =>
                              v!.isEmpty ? 'Veuillez entrer un nom' : null,
                        ),
                        const SizedBox(height: 24),
                        _buildCategoryDropdown(),
                        const SizedBox(height: 32),
                        _buildLabel('PRIX & FINANCES'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                label: 'Prix Achat',
                                controller: _purchasePriceController,
                                keyboardType: TextInputType.number,
                                hint: '600',
                                suffix: 'FCFA',
                                validator: (v) => v!.isEmpty ? 'Requis' : null,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildField(
                                label: 'Prix Vente',
                                controller: _salePriceController,
                                keyboardType: TextInputType.number,
                                hint: '1000',
                                suffix: 'FCFA',
                                validator: (v) => v!.isEmpty ? 'Requis' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildLabel('STOCK & ALERTES'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                label: 'Quantité Actuelle',
                                controller: _stockController,
                                keyboardType: TextInputType.number,
                                hint: '100',
                                validator: (v) => v!.isEmpty ? 'Requis' : null,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildField(
                                label: 'Seuil Critique',
                                controller: _thresholdController,
                                keyboardType: TextInputType.number,
                                hint: '10',
                                validator: (v) => v!.isEmpty ? 'Requis' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 8,
                      shadowColor: AppColors.primaryOrange.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'METTRE À JOUR' : 'CRÉER LE PRODUIT',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  if (isEditing) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _delete,
                      child: const Text(
                        'SUPPRIMER CE PRODUIT',
                        style: TextStyle(
                          color: AppColors.critical,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.primaryOrange,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.2),
              fontWeight: FontWeight.normal,
            ),
            suffixText: suffix,
            suffixStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white10),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
            ),
            errorStyle: const TextStyle(
              color: AppColors.critical,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = ['Tout', 'Bière', 'Soda', 'Eau', 'Alcool', 'Divers'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catégorie',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        DropdownButtonFormField<String>(
          value: _category,
          dropdownColor: AppColors.surface,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primaryOrange,
          ),
          items: categories
              .where(
                (c) => c != 'Tout',
              ) // Can't assign 'Tout' to a single product
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) => setState(() => _category = v!),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white10),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _DeleteConfirmationDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        padding: const EdgeInsets.all(32),
        borderRadius: 32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.critical.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                size: 48,
                color: AppColors.critical,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Supprimer ?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Cette action est irréversible. Le produit et son historique local seront perdus.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'ANNULER',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.critical,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('SUPPRIMER'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
