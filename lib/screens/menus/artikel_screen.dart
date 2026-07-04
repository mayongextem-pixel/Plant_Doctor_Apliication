import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/article.dart';

class ArtikelScreen extends StatelessWidget {
  const ArtikelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = Article.mockData;

    return Scaffold(
      appBar: AppBar(title: const Text('Artikel Tanaman')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          itemCount: articles.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingS),
          itemBuilder: (context, index) {
            final article = articles[index];
            return ArticleCard(article: article);
          },
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.lightGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Icon(
                Icons.article_rounded,
                color: AppTheme.primaryGreen,
                size: 32,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.categoryName.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingXS),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article.categoryName,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Text(article.title, style: AppTheme.titleSmall),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    article.description,
                    style: AppTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
