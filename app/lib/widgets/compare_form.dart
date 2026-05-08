import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompareForm extends StatefulWidget {
  const CompareForm({super.key, required this.onSubmit, required this.loading});

  final Future<void> Function(String menuName, int eatingOutPrice) onSubmit;
  final bool loading;

  @override
  State<CompareForm> createState() => _CompareFormState();
}

class _CompareFormState extends State<CompareForm> {
  final _menuController = TextEditingController();
  final _priceController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _menuController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final menu = _menuController.text.trim();
    final price = int.tryParse(
      _priceController.text.replaceAll(',', '').trim(),
    );
    if (menu.isEmpty || price == null || price <= 0) {
      setState(() => _error = '메뉴와 외식 가격을 입력해 주세요.');
      return;
    }
    setState(() => _error = null);
    await widget.onSubmit(menu, price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x1F0E0F0C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compare a craving',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _menuController,
            decoration: const InputDecoration(
              labelText: 'Food name',
              hintText: '닭발',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Eating-out price',
              hintText: '23000',
              suffixText: 'KRW',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.loading ? null : _submit,
              child: widget.loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Compare'),
            ),
          ),
        ],
      ),
    );
  }
}
