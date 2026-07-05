import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../utils/page_transitions.dart';
import '../auth/welcome_screen.dart';

/// Admin Dashboard — Full CRUD untuk Koleksi & Artikel
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _token = '';
  String _adminName = '';
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('api_token') ?? '';
      _adminName = 'Administrator';
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Logout: panggil API Laravel, hapus token lokal, redirect ke WelcomeScreen
  Future<void> _logout() async {
    // Tampilkan dialog konfirmasi logout
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.errorRed),
            SizedBox(width: 10),
            Text('Konfirmasi Keluar'),
          ],
        ),
        content: const Text('Anda yakin ingin keluar dari Panel Admin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isLoggingOut = true);

    try {
      // Panggil API Logout Laravel
      await http.post(
        Uri.parse('${AppConstants.laravelApiBaseUrl}/auth/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
    } catch (_) {
      // Jika API gagal (misal: no internet), tetap lakukan logout lokal
    }

    // Hapus semua data lokal (token, role, session)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    setState(() => _isLoggingOut = false);

    // Redirect ke halaman Welcome
    Navigator.of(context).pushAndRemoveUntil(
      PageTransitions.fadeTransition(const WelcomeScreen()),
      (route) => false,
    );
  }
    // Tampilkan Bottom Sheet Profil Admin
  void _showAdminProfile() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.lightGreen,
              child: Icon(Icons.admin_panel_settings_rounded, size: 40, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 16),
            Text(
              _adminName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Super Administrator',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email_rounded, color: AppTheme.primaryGreen),
              title: const Text('Email'),
              subtitle: const Text('admin@plantdoctor.com'), // Bisa dinamis jika ada dari prefs
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.security_rounded, color: AppTheme.primaryGreen),
              title: const Text('Hak Akses'),
              subtitle: const Text('Full Control (CRUD)'),
              dense: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 180, // Ditinggikan agar tidak tertutup TabBar
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppTheme.primaryGreen,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF57C84D), AppTheme.primaryGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                // Padding bawah ditambah 52 (tinggi TabBar) agar konten sejajar di tengah area yang tersisa
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 10,
                  8,
                  52, 
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar lingkaran Admin (Bisa diklik)
                    GestureDetector(
                      onTap: _showAdminProfile,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 2),
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Teks Panel Admin & salam
                    Expanded(
                      child: GestureDetector(
                        onTap: _showAdminProfile,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Panel Admin',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Halo, $_adminName 👋',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.88),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Tombol Logout dengan loading indicator
                    _isLoggingOut
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            ),
                          )
                        : Tooltip(
                            message: 'Keluar',
                            child: IconButton(
                              onPressed: _logout,
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.15),
                                padding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            // Tab Bar navigasi Koleksi & Artikel
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  // Indikator aktif: pill putih di bawah tab
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                    insets: EdgeInsets.symmetric(horizontal: 24),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.55),
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                  tabs: const [
                    Tab(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.eco_rounded, size: 18),
                          SizedBox(width: 6),
                          Text('Koleksi Tanaman'),
                        ],
                      ),
                    ),
                    Tab(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_rounded, size: 18),
                          SizedBox(width: 6),
                          Text('Artikel'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _AdminKoleksiTab(token: _token),
            _AdminArtikelTab(token: _token),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// SKELETON LOADING WIDGET
// ===========================================================================
class _SkeletonLoading extends StatefulWidget {
  const _SkeletonLoading();
  @override
  State<_SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<_SkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.grey.withValues(alpha: 0.1),
                Colors.grey.withValues(alpha: 0.3),
                Colors.grey.withValues(alpha: 0.1),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (_controller.value * 2.0), -0.3),
              end: Alignment(1.0 + (_controller.value * 2.0), 0.3),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 16,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 10),
                    Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 10),
                    Container(
                        height: 10,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8))),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}


// ===========================================================================
// TAB 1: Manajemen Koleksi Tanaman
// ===========================================================================
class _AdminKoleksiTab extends StatefulWidget {
  final String token;
  const _AdminKoleksiTab({required this.token});

  @override
  State<_AdminKoleksiTab> createState() => _AdminKoleksiTabState();
}

class _AdminKoleksiTabState extends State<_AdminKoleksiTab> {
  List<dynamic> _koleksiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKoleksi();
  }

  Future<void> _fetchKoleksi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.laravelApiBaseUrl}/koleksi'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _koleksiList = data['data']['data'] ?? [];
        });
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _deleteKoleksi(int id) async {
    final confirm = await _showConfirmDialog('Hapus koleksi ini?');
    if (!confirm) return;
    await http.delete(
      Uri.parse('${AppConstants.laravelApiBaseUrl}/admin/koleksi/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    _fetchKoleksi();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Koleksi berhasil dihapus'),
            backgroundColor: AppTheme.successGreen),
      );
    }
  }

  Future<bool> _showConfirmDialog(String msg) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal')),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child:
                    const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showKoleksiForm({Map<String, dynamic>? existing}) {
    final nameCtrl =
        TextEditingController(text: existing?['plant_name'] ?? '');
    final notesCtrl = TextEditingController(text: existing?['notes'] ?? '');
    String healthStatus = existing?['health_status'] ?? 'sehat';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, sc) => Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
            child: ListView(controller: sc, children: [
              Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 16),
              Text(existing == null ? 'Tambah Koleksi Baru' : 'Edit Koleksi',
                  style: AppTheme.titleMedium),
              const SizedBox(height: 16),
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Nama Tanaman', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: healthStatus,
                decoration: const InputDecoration(
                    labelText: 'Status Kesehatan', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'sehat', child: Text('Sehat')),
                  DropdownMenuItem(value: 'sakit', child: Text('Sakit')),
                ],
                onChanged: (v) => setS(() => healthStatus = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Catatan Perawatan',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true),
                  maxLines: 4),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () async {
                  Navigator.pop(ctx);
                  setState(() => _isLoading = true);
                  
                  final body = jsonEncode({
                    'plant_name': nameCtrl.text,
                    'health_status': healthStatus,
                    'notes': notesCtrl.text,
                    'scan_date': existing?['scan_date'] ??
                        DateTime.now().toIso8601String().split('T')[0],
                  });
                  
                  final headers = {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${widget.token}',
                  };
                  
                  try {
                    if (existing == null) {
                      await http.post(
                        Uri.parse('${AppConstants.laravelApiBaseUrl}/admin/koleksi'),
                        headers: headers,
                        body: body,
                      );
                    } else {
                      await http.put(
                        Uri.parse('${AppConstants.laravelApiBaseUrl}/admin/koleksi/${existing['id']}'),
                        headers: headers,
                        body: body,
                      );
                    }
                  } catch (_) {}
                  _fetchKoleksi();
                },
                child: Text(existing == null ? 'Simpan' : 'Perbarui Data',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showKoleksiForm(),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Tambah Koleksi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const _SkeletonLoading()
          : _koleksiList.isEmpty
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.eco_outlined,
                          size: 72,
                          color: AppTheme.textLight.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      Text('Belum ada data koleksi',
                          style: AppTheme.bodyLarge
                              .copyWith(color: AppTheme.textLight)),
                    ]))
              : RefreshIndicator(
                  onRefresh: _fetchKoleksi,
                  color: AppTheme.primaryGreen,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: _koleksiList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final item = _koleksiList[i] as Map<String, dynamic>;
                      final isHealthy = item['health_status'] == 'sehat';
                      return Container(
                        decoration: AppTheme.cardDecoration,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isHealthy
                                ? AppTheme.successGreen.withValues(alpha: 0.15)
                                : AppTheme.errorRed.withValues(alpha: 0.15),
                            child: Icon(Icons.local_florist_rounded,
                                color: isHealthy
                                    ? AppTheme.successGreen
                                    : AppTheme.errorRed),
                          ),
                          title: Text(item['plant_name'] ?? '-',
                              style: AppTheme.titleSmall),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isHealthy
                                      ? AppTheme.successGreen
                                      : AppTheme.errorRed,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(isHealthy ? 'Sehat' : 'Sakit',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                              ),
                              if (item['user'] != null) ...[
                                const SizedBox(height: 4),
                                Text('Milik: ${item['user']['name']}',
                                    style: AppTheme.bodySmall),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_rounded,
                                    color: AppTheme.primaryGreen, size: 20),
                                onPressed: () => _showKoleksiForm(existing: item),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_rounded,
                                    color: AppTheme.errorRed, size: 20),
                                onPressed: () => _deleteKoleksi(item['id']),
                                tooltip: 'Hapus',
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

// ===========================================================================
// TAB 2: Manajemen Artikel
// ===========================================================================
class _AdminArtikelTab extends StatefulWidget {
  final String token;
  const _AdminArtikelTab({required this.token});

  @override
  State<_AdminArtikelTab> createState() => _AdminArtikelTabState();
}

class _AdminArtikelTabState extends State<_AdminArtikelTab> {
  List<dynamic> _artikelList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArtikels();
  }

  Future<void> _fetchArtikels() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.laravelApiBaseUrl}/artikels'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _artikelList = data['data'] ?? []);
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _deleteArtikel(int id) async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Hapus artikel ini?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal')),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child:
                    const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirm) return;
    await http.delete(
      Uri.parse('${AppConstants.laravelApiBaseUrl}/admin/artikels/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    _fetchArtikels();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Artikel berhasil dihapus'),
            backgroundColor: AppTheme.successGreen),
      );
    }
  }

  void _showArtikelForm({Map<String, dynamic>? existing}) {
    final titleCtrl =
        TextEditingController(text: existing?['title'] ?? '');
    final categoryCtrl =
        TextEditingController(text: existing?['category'] ?? '');
    final excerptCtrl =
        TextEditingController(text: existing?['excerpt'] ?? '');
    final contentCtrl =
        TextEditingController(text: existing?['content'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, sc) => Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: ListView(controller: sc, children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 16),
            Text(existing == null ? 'Tambah Artikel Baru' : 'Edit Artikel',
                style: AppTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                    labelText: 'Judul Artikel', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(
                controller: categoryCtrl,
                decoration: const InputDecoration(
                    labelText: 'Kategori (mis: Perawatan)',
                    border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(
                controller: excerptCtrl,
                decoration: const InputDecoration(
                    labelText: 'Ringkasan Singkat',
                    border: OutlineInputBorder()),
                maxLines: 2),
            const SizedBox(height: 12),
            TextField(
                controller: contentCtrl,
                decoration: const InputDecoration(
                    labelText: 'Isi Artikel Lengkap',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true),
                maxLines: 6),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () async {
                Navigator.pop(ctx);
                final body = jsonEncode({
                  'title': titleCtrl.text,
                  'category': categoryCtrl.text,
                  'excerpt': excerptCtrl.text,
                  'content': contentCtrl.text,
                });
                final headers = {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${widget.token}',
                };
                if (existing == null) {
                  await http.post(
                    Uri.parse(
                        '${AppConstants.laravelApiBaseUrl}/admin/artikels'),
                    headers: headers,
                    body: body,
                  );
                } else {
                  await http.put(
                    Uri.parse(
                        '${AppConstants.laravelApiBaseUrl}/admin/artikels/${existing['id']}'),
                    headers: headers,
                    body: body,
                  );
                }
                _fetchArtikels();
              },
              child: Text(existing == null ? 'Publikasikan' : 'Simpan Perubahan',
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showArtikelForm(),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Tambah Artikel',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const _SkeletonLoading()
          : _artikelList.isEmpty
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.article_outlined,
                          size: 72,
                          color: AppTheme.textLight.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      Text('Belum ada artikel',
                          style: AppTheme.bodyLarge
                              .copyWith(color: AppTheme.textLight)),
                    ]))
              : RefreshIndicator(
                  onRefresh: _fetchArtikels,
                  color: AppTheme.primaryGreen,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: _artikelList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final item = _artikelList[i] as Map<String, dynamic>;
                      return Container(
                        decoration: AppTheme.cardDecoration,
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.accentOrange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.article_rounded,
                                color: AppTheme.accentOrange),
                          ),
                          title: Text(item['title'] ?? '-',
                              style: AppTheme.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Text(item['category'] ?? '',
                              style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w600)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_rounded,
                                    color: AppTheme.primaryGreen, size: 20),
                                onPressed: () =>
                                    _showArtikelForm(existing: item),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_rounded,
                                    color: AppTheme.errorRed, size: 20),
                                onPressed: () =>
                                    _deleteArtikel(item['id']),
                                tooltip: 'Hapus',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
