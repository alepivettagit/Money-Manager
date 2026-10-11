import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

class AddTransactionSheet extends StatefulWidget {
  final String accountId;
  final DateTime? initialDate;
  final Function(Transaction) onAdd;

  const AddTransactionSheet({
    super.key,
    required this.accountId,
    this.initialDate,
    required this.onAdd,
  });

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  TransactionType _type = TransactionType.expense;
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedCategory = TransactionCategories.expenseCategories.first.name;
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionType newType) {
    setState(() {
      _type = newType;
      _selectedCategory = newType == TransactionType.expense
          ? TransactionCategories.expenseCategories.first.name
          : TransactionCategories.incomeCategories.first.name;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          DateTime.now().hour,
          DateTime.now().minute,
        );
      });
    }
  }

  void _submit() {
    final amountText = _amountController.text.replaceAll(',', '.').trim();
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci un importo valido maggiore di 0'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final title = _titleController.text.trim().isEmpty
        ? _selectedCategory
        : _titleController.text.trim();

    final note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();

    final newTransaction = Transaction(
      id: const Uuid().v4(),
      accountId: widget.accountId,
      title: title,
      amount: amount,
      date: _selectedDate,
      type: _type,
      category: _selectedCategory,
      note: note,
    );

    widget.onAdd(newTransaction);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = _type == TransactionType.expense;
    final categories = isExpense
        ? TransactionCategories.expenseCategories
        : TransactionCategories.incomeCategories;
    final dateFormat = DateFormat('dd MMM yyyy', 'it_IT');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Nuova Transazione',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Tipo: Spesa / Entrata
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onTypeChanged(TransactionType.expense),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isExpense ? const Color(0xFFEF4444) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Spesa',
                            style: TextStyle(
                              color: isExpense ? Colors.white : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onTypeChanged(TransactionType.income),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !isExpense ? const Color(0xFF10B981) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Entrata',
                            style: TextStyle(
                              color: !isExpense ? Colors.white : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Importo
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981),
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                prefixText: '€ ',
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Titolo / Descrizione
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Descrizione',
                hintText: isExpense ? 'Es. Pranzo fuori, Spesa...' : 'Es. Stipendio, Rimborso...',
                prefixIcon: const Icon(Icons.edit_note_rounded),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Note opzionali
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note aggiuntive (opzionale)',
                hintText: 'Es. Dettagli, ricevuta o luogo...',
                prefixIcon: const Icon(Icons.notes_rounded),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Categoria
            const Text(
              'Categoria',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat.name == _selectedCategory;
                  return ChoiceChip(
                    avatar: Icon(
                      cat.icon,
                      size: 16,
                      color: isSelected ? Colors.white : cat.color,
                    ),
                    label: Text(cat.name),
                    selected: isSelected,
                    selectedColor: cat.color,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat.name);
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Selettore Data
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 10),
                    Text(
                      'Data: ${dateFormat.format(_selectedDate)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pulsante Salva
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                isExpense ? 'Aggiungi Spesa' : 'Aggiungi Entrata',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
