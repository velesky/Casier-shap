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
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier Produit' : 'Ajouter Produit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image Placeholder
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(
                        Icons.local_drink_rounded,
                        size: 60,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildField(
                      label: 'Nom du produit',
                      controller: _nameController,
                      validator: (v) => v!.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'Prix Achat',
                            controller: _purchasePriceController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Requis' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField(
                            label: 'Prix Vente',
                            controller: _salePriceController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Requis' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'Stock Initial',
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Requis' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField(
                            label: 'Seuil Alerte',
                            controller: _thresholdController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Requis' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isEditing
                      ? 'ENREGISTRER LES MODIFICATIONS'
                      : 'AJOUTER LE PRODUIT',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              if (isEditing) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _delete,
                  child: const Text(
                    'Supprimer le produit',
                    style: TextStyle(
                      color: AppColors.critical,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white12),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryOrange),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = ['Bière', 'Soda', 'Eau', 'Autre'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catégorie',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        DropdownButtonFormField<String>(
          value: _category,
          dropdownColor: AppColors.surface,
          items: categories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) => setState(() => _category = v!),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white12),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: AppColors.critical,
            ),
            const SizedBox(height: 16),
            const Text(
              'Supprimer ce produit ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Attention, cette action est irréversible. Le produit sera définitivement supprimé.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'ANNULER',
                      style: TextStyle(color: Colors.white70),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'SUPPRIMER',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
