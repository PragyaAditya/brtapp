import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Owner Admin'), elevation: 2),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.status.isDeviceOwner == false) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildStatusCard(viewModel),
              const SizedBox(height: 24),
              _buildActionsCard(context, viewModel),
              if (viewModel.error != null) ...[
                const SizedBox(height: 24),
                _buildErrorCard(viewModel.error!),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<HomeViewModel>().refreshStatus(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildStatusCard(HomeViewModel viewModel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Policy Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildStatusItem(
              'Device Owner Active',
              viewModel.status.isDeviceOwner,
              viewModel.status.isDeviceOwner ? Colors.green : Colors.red,
            ),
            _buildStatusItem(
              'Uninstall Blocked',
              viewModel.status.isUninstallBlocked,
              viewModel.status.isUninstallBlocked ? Colors.orange : Colors.grey,
            ),
            _buildStatusItem(
              'Policy Applied',
              viewModel.status.isPolicyApplied,
              viewModel.status.isPolicyApplied ? Colors.blue : Colors.grey,
            ),
            _buildStatusItem(
              'Provisioning Status (QR)',
              viewModel.status.isProvisionedViaQR,
              viewModel.status.isProvisionedViaQR ? Colors.cyan : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, bool value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color),
            ),
            child: Text(
              value ? 'ACTIVE' : 'INACTIVE',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context, HomeViewModel viewModel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Management Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Block Uninstallation'),
              subtitle: const Text('Prevents user from removing the app'),
              value: viewModel.status.isUninstallBlocked,
              onChanged:
                  viewModel.status.isDeviceOwner
                      ? (value) => viewModel.toggleUninstallBlocked(value)
                      : null,
            ),
            SwitchListTile(
              title: const Text('Block Factory Reset'),
              subtitle: const Text('Prevents user from wiping device'),
              value: viewModel.status.isFactoryResetDisabled,
              onChanged:
                  viewModel.status.isDeviceOwner
                      ? (value) => viewModel.toggleFactoryResetDisabled(value)
                      : null,
            ),
            const Divider(),
            ListTile(
              title: const Text('FRP Account'),
              subtitle: Text(
                viewModel.status.frpAccount ?? 'Not set (tap to set)',
              ),
              trailing: const Icon(Icons.edit),
              onTap:
                  viewModel.status.isDeviceOwner
                      ? () => _showFRPDialog(context, viewModel)
                      : null,
            ),
            if (!viewModel.status.isDeviceOwner)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Note: Actions require Device Owner privileges. Use QR provisioning or ADB to set.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFRPDialog(BuildContext context, HomeViewModel viewModel) {
    final controller = TextEditingController(text: viewModel.status.frpAccount);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Set FRP Account'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter organizational email',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.setFRPAccount(controller.text);
                  Navigator.pop(context);
                },
                child: const Text('SET'),
              ),
            ],
          ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.red.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(error, style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
